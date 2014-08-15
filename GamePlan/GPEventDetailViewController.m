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

int attendee;

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
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.text = self.event.desc;
    [self.descriptionLabel sizeToFit];
    CGRect descriptionFrame = self.descriptionLabel.frame;
    // HASHTAGS
    [self.tagsLabel setFrame:CGRectMake(13.0, descriptionFrame.origin.y+descriptionFrame.size.height+15.0, 287.0, 32.0)];
    NSString *hashtags = @"";
    for (NSString *tag in self.event.tags) {
        hashtags = [hashtags stringByAppendingString:[NSString stringWithFormat:@"#%@    ", tag]];
    }
    self.tagsLabel.text = hashtags;
    self.tagsLabel.numberOfLines = 0;
    [self.tagsLabel sizeToFit];
    // WHO'S GOING
    attendee = 1;
    CGRect attendeesBackgroundFrame = self.attendeesBackground.frame;
    [self.attendeesBackground setFrame:CGRectMake(0, self.tagsLabel.frame.origin.y+self.tagsLabel.frame.size.height+15.0, attendeesBackgroundFrame.size.width, attendeesBackgroundFrame.size.height)];
    attendeesBackgroundFrame = self.attendeesBackground.frame;
    [self.whosGoingLabel setFrame:CGRectMake(0, attendeesBackgroundFrame.origin.y+2.0, self.whosGoingLabel.frame.size.width, self.whosGoingLabel.frame.size.height)];
    float attendeesOriginYValue = attendeesBackgroundFrame.origin.y + 20.0;
    [self.attendeeOne setFrame:CGRectMake(self.attendeeOne.frame.origin.x, attendeesOriginYValue, 40, 40)];
    [self.attendeeTwo setFrame:CGRectMake(self.attendeeTwo.frame.origin.x, attendeesOriginYValue, 40, 40)];
    [self.attendeeThree setFrame:CGRectMake(self.attendeeThree.frame.origin.x, attendeesOriginYValue, 40, 40)];
    [self.attendeeFour setFrame:CGRectMake(self.attendeeFour.frame.origin.x, attendeesOriginYValue, 40, 40)];
    [self.andMoreLabel setFrame:CGRectMake(212.0, attendeesBackgroundFrame.origin.y+29.0, 88, 21)];
    
    for (NSString *userID in self.event.confirmedInvites) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:userID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error){
                PFUser *user = [objects firstObject];
                NSLog(@"%@", [user objectForKey:@"FBPictureURL"]);
                if (attendee == 1) {
                    [self.attendeeOne.layer setCornerRadius:self.attendeeOne.frame.size.width/2];
                    self.attendeeOne.layer.borderWidth = 1.0f;
                    self.attendeeOne.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    self.attendeeOne.layer.masksToBounds = YES;
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[user objectForKey:@"FBPictureURL"]]]];
                    UIImage *cropped = [self squareImageFromImage:image scaledToSize:40.0];
                    self.attendeeOne.image = cropped;
                } else if (attendee == 2) {
                    [self.attendeeTwo.layer setCornerRadius:self.attendeeTwo.frame.size.width/2];
                    self.attendeeTwo.layer.borderWidth = 1.0f;
                    self.attendeeTwo.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    self.attendeeTwo.layer.masksToBounds = YES;
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[user objectForKey:@"FBPictureURL"]]]];
                    UIImage *cropped = [self squareImageFromImage:image scaledToSize:40.0];
                    self.attendeeTwo.image = cropped;
                } else if (attendee == 3) {
                    [self.attendeeThree.layer setCornerRadius:self.attendeeThree.frame.size.width/2];
                    self.attendeeThree.layer.borderWidth = 1.0f;
                    self.attendeeThree.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    self.attendeeThree.layer.masksToBounds = YES;
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[user objectForKey:@"FBPictureURL"]]]];
                    UIImage *cropped = [self squareImageFromImage:image scaledToSize:40.0];
                    self.attendeeThree.image = cropped;
                } else if (attendee == 4) {
                    [self.attendeeFour.layer setCornerRadius:self.attendeeFour.frame.size.width/2];
                    self.attendeeFour.layer.borderWidth = 1.0f;
                    self.attendeeFour.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    self.attendeeFour.layer.masksToBounds = YES;
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[user objectForKey:@"FBPictureURL"]]]];
                    UIImage *cropped = [self squareImageFromImage:image scaledToSize:40.0];
                    self.attendeeFour.image = cropped;
                }
                attendee++;
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    int numAttendees = (int)[self.event.confirmedInvites count];
    if (numAttendees > 4) {
        self.andMoreLabel.text = [NSString stringWithFormat:@"plus %d more", (numAttendees-4)];
    } else {
        self.andMoreLabel.text = @"";
    }
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, attendeesBackgroundFrame.origin.y+attendeesBackgroundFrame.size.height+15.0);
}

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
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
    MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:[self.eventType lowercaseString]];
    if (!pinView)
    {
        // If an existing pin view was not available, create one.
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:[self.eventType lowercaseString]];
        pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-pin.png", [self.eventType lowercaseString]]]; // TODO: MAKE A LARGER IMAGE
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
    
    NSMutableArray *pendingInvites = [NSMutableArray arrayWithArray:([self.event objectForKey:@"pendingInvites"])];
    [users findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFUser *user in objects) {
                [pendingInvites addObject:[NSString stringWithFormat:@"%@", [user objectId]]];
            }
            [self.event saveInBackground];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:users];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // get the current user's first name
    NSString *name = [[[defaults objectForKey:@"name"] componentsSeparatedByString: @" "] firstObject];
    NSString *message = [NSString stringWithFormat:@"%@ invited you to %@", name, self.event.name];
    // [push setMessage:message];
    
    NSLog(@"%@", self.eventType);
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          @"eventID", self.event.objectId, // This event's object id
                          @"eventType", self.eventType, // This event's object id
                          nil];

    [push setData:data];
    [push sendPushInBackground];
    
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

- (IBAction)shareOnFBPressed:(UIButton *)sender
{
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.event.name, @"name",
                                   @"Game Plan", @"caption",
                                   self.event.description, @"description",
                                   @"https://itunes.apple.com/us/app/longhorn-game-plan/id854557819?mt=8", @"link",
                                   @"http://i.imgur.com/VFFX5Yb.png", @"picture",
                                   nil];
    
    // Show the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"%@", [NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User cancelled.
                                                          NSLog(@"User cancelled.");
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              // User clicked the Share button
                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];

}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (IBAction) addToPlaybookPressed:(UIButton *)sender
{
    // [self.event.confirmedInvites append [PFUser currentUser]];
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
