//
//  GPEventDetailViewController.m
//  GamePlan
//
//  Created by Jeremy Hintz on 7/26/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import "GPEventDetailViewController.h"
#import "Tailgate.h"
#import "AfterParty.h"
#import "WatchParty.h"
#import "Restaurant.h"

@interface GPEventDetailViewController ()

@end

@implementation GPEventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapPreview.delegate = self;
    [self populateLabels];
    [self zoomInToMap];
}

- (void)populateLabels
{
    // EVENT NAME LABEL
    self.eventNameLabel.numberOfLines = 0;
    self.eventNameLabel.text = self.event.name;
    // HOST LABEL
    if (self.event.ownerId > 0) {
        PFQuery *query = [PFUser query];
        PFUser *owner = (PFUser *)[query getObjectWithId:self.event.ownerId];
        self.hostLabel.text = [NSString stringWithFormat:@"Hosted by: %@", [owner objectForKey:@"Name"]];
    } else {
        self.hostLabel.text = @"";
    }
    // DATE LABEL
    NSDateFormatter *longDateFormatter = [[NSDateFormatter alloc] init];
    longDateFormatter.dateStyle = NSDateFormatterLongStyle;
    NSDateFormatter *shortDateFormatter = [[NSDateFormatter alloc] init];
    shortDateFormatter.dateStyle = NSDateFormatterLongStyle;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
    
    NSString *startDate = [longDateFormatter stringFromDate:self.event.startTime];
    NSString *startTime = [timeFormatter stringFromDate:self.event.startTime];
    if (self.event.endTime) {
        NSString *endDate = [longDateFormatter stringFromDate:self.event.endTime];
        NSString *endTime = [timeFormatter stringFromDate:self.event.endTime];
        if ([startDate isEqualToString:endDate]) {
            self.dateLabel.text = [NSString stringWithFormat:@"%@ from %@ to %@",startDate,startTime,endTime];
        } else {
            NSString *startShort = [shortDateFormatter stringFromDate:self.event.startTime];
            NSString *endShort = [shortDateFormatter stringFromDate:self.event.endTime];
            self.dateLabel.text = [NSString stringWithFormat:@"%@ %@ to %@ %@",startShort,startTime,endShort,endTime];
        }
    }
    // DESCRIPTION LABEL
    CGRect descriptionBackgroundFrame = self.descriptionBackground.frame;
    float descriptionBackgroundTopYVal = descriptionBackgroundFrame.origin.y;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.text = self.event.desc;
    [self.descriptionLabel sizeToFit];
    CGRect descriptionFrame = self.descriptionLabel.frame;
    [self.descriptionBackground setFrame:CGRectMake(0, descriptionBackgroundTopYVal, descriptionBackgroundFrame.size.width, (descriptionFrame.origin.y+descriptionFrame.size.height-descriptionBackgroundTopYVal+15.0))];
    // MAP PREVIEW
    descriptionBackgroundFrame = self.descriptionBackground.frame;
    CGRect mapFrame = self.mapPreview.frame;
    [self.mapPreview setFrame:CGRectMake(0, descriptionBackgroundFrame.origin.y+descriptionBackgroundFrame.size.height+1.0, mapFrame.size.width, mapFrame.size.height)];
    // WHO'S GOING
}

- (void)zoomInToMap
{
    PFGeoPoint *eventGeoPoint = self.event.geoPoint;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(eventGeoPoint.latitude, eventGeoPoint.longitude);
    float zoom = 0.005f;
    MKCoordinateRegion myRegion;
    MKCoordinateSpan span;
    span.latitudeDelta = zoom;
    span.longitudeDelta = zoom;
    myRegion.span = span;
    myRegion.center = CLLocationCoordinate2DMake(eventGeoPoint.latitude, eventGeoPoint.longitude);;
    [self.mapPreview setRegion:myRegion animated:YES];
    [self.mapPreview addAnnotation:annotation];
    self.mapPreview.zoomEnabled = NO;
    self.mapPreview.scrollEnabled = NO;
    self.mapPreview.userInteractionEnabled = NO;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // Try to dequeue an existing pin view first.
    MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:self.eventType];
    if (!pinView)
    {
        // If an existing pin view was not available, create one.
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:self.eventType];
        pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-pin.png", self.eventType]]; // TODO: MAKE A LARGER IMAGE
        pinView.canShowCallout = YES;
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (IBAction) getDirectionsPressed:(UIButton *)sender
{
    
}

- (IBAction) inviteFriendsPressed:(UIButton *)sender
{
    // Initialize the friend picker
    FBFriendPickerViewController *friendPickerController =
    [[FBFriendPickerViewController alloc] init];
    // Set the friend picker title
    friendPickerController.title = @"INVITE";
    
    // TODO: Set up the delegate to handle picker callbacks, ex: Done/Cancel button
    
    // Load the friend data
    [friendPickerController loadData];
    // Show the picker modally
    [friendPickerController presentModallyFromViewController:self animated:YES handler:nil];
    
    // Set up the delegate
    friendPickerController.delegate = self;
    // Load the friend data
    NSSet *fields = [NSSet setWithObjects:@"installed", nil];
    friendPickerController.fieldsForRequest = fields;
    [friendPickerController loadData];
}

/*
 * Event: Error during data fetch
 */
- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error
{
    NSLog(@"Error during data fetch.");
}

/*
 * Event: Data loaded
 */
- (void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    // NSLog(@"Friend data loaded.");
}

// Only load people who have downloaded Game Plan
-(BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user{
    BOOL installed = [user objectForKey:@"installed"] != nil;
    return installed;
}

/*
 * Event: Selection changed
 */
- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    //NSLog(@"Current friend selections: %@", friendPicker.selection);
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSMutableArray *peopleToPushTo = [[NSMutableArray alloc] init];
    FBFriendPickerViewController *friendPickerController =
    (FBFriendPickerViewController*)sender;

    for (id<FBGraphUser> user in friendPickerController.selection) {
        [peopleToPushTo addObject:user.id];
    }

    PFQuery *users = [PFUser query];
    [users whereKey:@"FacebookID" containedIn:peopleToPushTo];
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:users];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:@"Hi, I'm trying to send a push notification"];
    [push sendPushInBackground];
//
//    NSString *message = [[PFUser currentUser] objectForKey:@"profile"][@"name"];
//    message = [message stringByAppendingString:@" invited you to "];
//    message = [message stringByAppendingString:self.name];
//    message = [message stringByAppendingString:@" on Game Plan"];
//    
//    
//    NSDictionary *data = @{@"alert": message, @"eventObjectID": self.objectID, @"userID":[PFUser currentUser].objectId, @"eventType":self.eventType};
//    
//    PFQuery *pushQuery = [PFInstallation query];
//    
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//    });
//    
//    
//    [pushQuery whereKey:@"objectId" containedIn:installationIDs];
//    
//    PFPush *push = [[PFPush alloc] init];
//    [push setQuery:pushQuery];
//    [push setMessage:message];
//    [push setData:data];
//    [push sendPushInBackground];
    
    [[sender presentingViewController] dismissModalViewControllerAnimated:YES];
}

/*
 * Event: Cancel button clicked
 */
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    NSLog(@"Canceled");
    // Dismiss the friend picker
    [[sender presentingViewController] dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) backPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
