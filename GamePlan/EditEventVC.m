//
//  EditEventVC.m
//  GamePlan
//
//  Created by Courtney Bohrer on 7/27/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import "EditEventVC.h"
#import "Tailgate.h"
#import "WatchParty.h"
#import "AfterParty.h"

@interface EditEventVC () {
    EventType type;
    NSString *eventName;
    NSString *desc;
    NSDate *startTime;
    NSDate *endTime;
    BOOL isStartPickerViewable;
    BOOL isEndPickerViewable;
    NSMutableArray *invitedFriends;
    int privSetting;
    NSMutableArray *tags;
    UIColor *highlightedButtonColor;
    PFGeoPoint *loc;
    NSString *privacy;
    BOOL privExpanded;
    MKPointAnnotation *annot;
    BOOL *delete;
    NSString *eventClass;
}
@end

@implementation EditEventVC 

@synthesize startDatePicker, endDatePicker, startLabel, endLabel, tailgateButton, watchPartyButton, afterPartyButton, eventNameLabel, eventDescLabel, BYOBButton, FreeFoodButton, CoverChargeButton, KidFriendlyButton, AlumniButton, StudentsButton, event, eventTypeMissing, eventNameMissing, eventLocMissing, eventTimeMissing, privacyButton, inviteButton, privSetting1Button, privSetting2Button, privSetting3Button, privSetting4Button, privLabel, miniMap, expandedMap, miniMapButton, titleLabel, mainMap, privacyLabel, doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad{
    invitedFriends = [[NSMutableArray alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set up view
    [self makeDatePickers];
    eventNameLabel.delegate = self;
    eventDescLabel.delegate = self;
    highlightedButtonColor = [UIColor darkGrayColor];
    [self.myScrollView addSubview:self.myView];
    self.myScrollView.contentSize = self.myView.frame.size;
    [eventTypeMissing setHidden:YES];
    [eventNameMissing setHidden:YES];
    [eventLocMissing setHidden:YES];
    [eventTimeMissing setHidden:YES];
    [privSetting1Button setHidden:YES];
    [privSetting2Button setHidden:YES];
    [privSetting3Button setHidden:YES];
    [privSetting4Button setHidden:YES];
    privExpanded = NO;
    
    
    
    if ( self.event == nil ) {
        self.deleteButton.hidden = YES;
        tags = [[NSMutableArray alloc] init];
        titleLabel.text = @"Add an Event";
        privacy = @"";
        
        // setting up maps
        CLLocationCoordinate2D bbLoc;
        bbLoc.latitude = 30.2804859;
        bbLoc.longitude = -97.7386164;
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01f;
        span.longitudeDelta = 0.01f;
        
        MKCoordinateRegion reg;
        reg.center = bbLoc;
        reg.span = span;
        
        delete = false;
        
        [miniMap setCenterCoordinate:bbLoc animated:YES];
        [miniMap setRegion:reg];
        [expandedMap setCenterCoordinate:bbLoc animated:YES];
        [expandedMap setRegion:reg];
        [expandedMap setHidden:YES];
        
        UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(dropPin:)];
        tapRecognizer.minimumPressDuration = 1.0;
        [expandedMap addGestureRecognizer:tapRecognizer];
        
    } else {
        titleLabel.text = @"Edit Event";
        [doneButton setTitle:@"SAVE" forState:UIControlStateHighlighted];
        [doneButton setTitle:@"SAVE" forState:UIControlStateNormal];
        [doneButton setTitle:@"SAVE" forState:UIControlStateSelected];
        eventNameLabel.text = event.name;
        eventNameLabel.textColor = [UIColor darkGrayColor];
        eventDescLabel.text = event.desc;
        eventDescLabel.textColor = [UIColor darkGrayColor];
        tags = event.tags;
        for (NSString *tag in event.tags) {
            if ([tag isEqualToString:@"BYOB"]) {
                BYOBButton.backgroundColor = highlightedButtonColor;
            } else if ( [tag isEqualToString:@"FreeFood"] ){
                FreeFoodButton.backgroundColor = highlightedButtonColor;
            } else if( [tag isEqualToString:@"CoverCharge"]){
                CoverChargeButton.backgroundColor = highlightedButtonColor;
            } else if( [tag isEqualToString:@"KidFriendly"] ){
                KidFriendlyButton.backgroundColor = highlightedButtonColor;
            } else if( [tag isEqualToString:@"Alumni"] ){
                AlumniButton.backgroundColor = highlightedButtonColor;
            } else if( [tag isEqualToString:@"Students"] ){
                StudentsButton.backgroundColor = highlightedButtonColor;
            }
        }
        loc = event.geoPoint;
        
        //set up map
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01f;
        span.longitudeDelta = 0.01f;
        
        CLLocationCoordinate2D center;
        event.geoPoint.latitude = 30.2804859;
        event.geoPoint.longitude = -97.7386164;
        
        MKCoordinateRegion reg;
        reg.center = center;
        reg.span = span;
        
        delete = false;
        
        [miniMap setCenterCoordinate:center animated:YES];
        [miniMap setRegion:reg];
        [expandedMap setCenterCoordinate:center animated:YES];
        [expandedMap setRegion:reg];
        [expandedMap setHidden:YES];
        
        UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(dropPin:)];
        tapRecognizer.minimumPressDuration = 1.0;
        [expandedMap addGestureRecognizer:tapRecognizer];
        
        annot = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
        annot.coordinate = coord;
        [expandedMap addAnnotation:annot];
        [miniMap addAnnotation:annot];
        privacy = event.privacy;
        privLabel.text = privacy;
        
        //disable buttons and highlight type
        self.tailgateButton.enabled = NO;
        self.watchPartyButton.enabled = NO;
        self.afterPartyButton.enabled = NO;
        id<PFSubclassing> sc = (id<PFSubclassing>)self.event;
        
        if ( [[sc parseClassName] isEqualToString:@"Tailgate"] ) {
            self.tailgateButton.backgroundColor = highlightedButtonColor;
            eventClass = @"Tailgate";
            
        }
        if ( [[sc parseClassName] isEqualToString:@"WatchParty"] ) {
            self.watchPartyButton.backgroundColor = highlightedButtonColor;
            eventClass = @"WatchParty";
        }
        if ( [[sc parseClassName] isEqualToString:@"AfterParty"] ) {
            self.afterPartyButton.backgroundColor = highlightedButtonColor;
            eventClass = @"AfterParty";
        }
        
        //adjust start time
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterShortStyle;
        NSString *displayDate = [df stringFromDate:event.startTime];
        NSDateFormatter *tf = [[NSDateFormatter alloc] init];
        [tf setDateFormat:@"hh:mm a"];
        NSString *displayTime = [tf stringFromDate:event.startTime];
        startLabel.textColor = [UIColor blackColor];
        startLabel.text = [NSString stringWithFormat:@"%@     %@", displayDate, displayTime];
        startTime = event.startTime;
        
        //adjust start time
        df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterShortStyle;
        displayDate = [df stringFromDate:event.endTime];
        tf = [[NSDateFormatter alloc] init];
        [tf setDateFormat:@"hh:mm a"];
        displayTime = [tf stringFromDate:event.endTime];
        endLabel.textColor = [UIColor blackColor];
        endLabel.text = [NSString stringWithFormat:@"%@     %@", displayDate, displayTime];
        endTime = event.endTime;
        
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Type Methods

- (IBAction)tailgateButtonTouchHandler:(id)sender {
    type = tailgateType;
    tailgateButton.backgroundColor = highlightedButtonColor;
    watchPartyButton.backgroundColor = [UIColor whiteColor];
    afterPartyButton.backgroundColor = [UIColor whiteColor];
}

- (IBAction)watchPartyButtonTouchHandler:(id)sender {
    type = watchPartyType;
    tailgateButton.backgroundColor = [UIColor whiteColor];
    watchPartyButton.backgroundColor = highlightedButtonColor;
    afterPartyButton.backgroundColor = [UIColor whiteColor];
}

- (IBAction)afterPartyButtonTouchHandler:(id)sender {
    type = afterPartyType;
    tailgateButton.backgroundColor = [UIColor whiteColor];
    watchPartyButton.backgroundColor = [UIColor whiteColor];
    afterPartyButton.backgroundColor = highlightedButtonColor;
}


-(void) textViewDidBeginEditing:(UITextView *) textView {
    if ([textView.text isEqualToString:@"Event Name"] || [textView.text isEqualToString:@"Event Description"] ) {
        [textView setText:@""];
        textView.textColor = [UIColor darkGrayColor];
    }
}

-(void) dismissKeyboards {
    [self.eventDescLabel resignFirstResponder];
    [self.eventNameLabel resignFirstResponder];
}

#pragma mark - Tag Methods 

- (IBAction)BYOBButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"BYOB"]) {
            [tags removeObject:str];
            BYOBButton.backgroundColor = [UIColor whiteColor];
            [BYOBButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [BYOBButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [BYOBButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            return;
        }
    }
    [tags addObject:@"BYOB"];
    BYOBButton.backgroundColor = highlightedButtonColor;
    [BYOBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [BYOBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [BYOBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self dismissKeyboards];
}

- (IBAction)FreeFoodButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"FreeFood"]) {
            [tags removeObject:str];
            FreeFoodButton.backgroundColor = [UIColor whiteColor];
            [FreeFoodButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [FreeFoodButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [FreeFoodButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            return;
        }
    }
    [tags addObject:@"FreeFood"];
    FreeFoodButton.backgroundColor = highlightedButtonColor;
    [FreeFoodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [FreeFoodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [FreeFoodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self dismissKeyboards];
}


- (IBAction)CoverChargeButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"CoverCharge"]) {
            [tags removeObject:str];
            CoverChargeButton.backgroundColor = [UIColor whiteColor];
            [CoverChargeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [CoverChargeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [CoverChargeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            return;
        }
    }
    [tags addObject:@"CoverCharge"];
    CoverChargeButton.backgroundColor = highlightedButtonColor;
    [CoverChargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [CoverChargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CoverChargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self dismissKeyboards];
}

- (IBAction)KidFriendlyButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"KidFriendly"]) {
            [tags removeObject:str];
            KidFriendlyButton.backgroundColor = [UIColor whiteColor];
            [KidFriendlyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [KidFriendlyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [KidFriendlyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            return;
        }
    }
    [tags addObject:@"KidFriendly"];
    KidFriendlyButton.backgroundColor = highlightedButtonColor;
    [KidFriendlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [KidFriendlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [KidFriendlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self dismissKeyboards];
}

- (IBAction)AlumniButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"Alumni"]) {
            [tags removeObject:str];
            AlumniButton.backgroundColor = [UIColor whiteColor];
            [AlumniButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [AlumniButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [AlumniButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];

            return;
        }
    }
    [tags addObject:@"Alumni"];
    AlumniButton.backgroundColor = highlightedButtonColor;
    [AlumniButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [AlumniButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AlumniButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self dismissKeyboards];
}

- (IBAction)StudentsButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"Students"]) {
            [tags removeObject:str];
            StudentsButton.backgroundColor = [UIColor whiteColor];
            [StudentsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [StudentsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [StudentsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            return;
        }
    }
    [tags addObject:@"Students"];
    StudentsButton.backgroundColor = highlightedButtonColor;
    [StudentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [StudentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [StudentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self dismissKeyboards];
}

#pragma mark - Location Methods

-(IBAction)didClickMiniMap:(id)sender{
    if(loc){
        UIAlertView *didClickAgain = [[UIAlertView alloc]
                                         initWithTitle:@"" message:@"Do you want to change your location?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
        [didClickAgain show];
    } else {
        [miniMap removeAnnotation:annot];
        [expandedMap removeAnnotation:annot];
        [miniMapButton setHidden:YES];
        [miniMap setHidden:YES];
        [expandedMap setHidden:NO];
    }
    [self dismissKeyboards];
}

-(void)alertView: (UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        [miniMapButton setHidden:YES];
        [miniMap setHidden:YES];
        [expandedMap setHidden:NO];
        if(loc){
            [expandedMap removeAnnotation:annot];
            [miniMap removeAnnotation:annot];
        }

    }
}

-(IBAction)dropPin:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint touchPoint = [recognizer locationInView:expandedMap];
    CLLocationCoordinate2D touchMapCoordinate =
    [expandedMap convertPoint:touchPoint toCoordinateFromView:expandedMap];
    
    PFGeoPoint *pfgp = [[PFGeoPoint alloc] init];
    pfgp.latitude = touchMapCoordinate.latitude;
    pfgp.longitude = touchMapCoordinate.longitude;
    loc = pfgp;
    annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    [expandedMap addAnnotation:annot];
    [miniMap addAnnotation:annot];
    [mainMap addAnnotation:annot];
    [expandedMap setHidden:YES];
    [miniMap setHidden:NO];
    [miniMapButton setHidden:NO];
    [miniMap setCenterCoordinate:touchMapCoordinate animated:YES];
    //[annot release];
}

#pragma mark - Event Time Methods

-(void) makeDatePickers{
    double locOflabel = 305;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //START PICKER
    [startDatePicker setHidden:YES];
    [startDatePicker setBackgroundColor:[UIColor whiteColor]];
    isStartPickerViewable = NO;
    startDatePicker.date = [NSDate date];
    [startDatePicker addTarget:self action:@selector(changeStartDateInLabel:) forControlEvents:UIControlEventValueChanged];
    
    //START LABEL
    startTime = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString = [df stringFromDate:startTime];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *timeString = [formatter stringFromDate:startTime];
    startLabel.text = [NSString stringWithFormat:@"%@     %@", dateString, timeString];
    
    //END PICKER
    [endDatePicker setHidden:YES];
    [endDatePicker setBackgroundColor:[UIColor whiteColor]];
    isEndPickerViewable = NO;
    endDatePicker.date = [NSDate date];
    [endDatePicker addTarget:self action:@selector(changeEndDateInLabel:) forControlEvents:UIControlEventValueChanged];
    
    //END LABEL
    endTime = [NSDate date];
    endLabel.text = [NSString stringWithFormat:@"%@     %@", dateString, timeString];
}


- (IBAction)expandStart:(UIButton *)sender {
    [endDatePicker setHidden:YES];
    [self dismissKeyboards];
    if (!isStartPickerViewable) {
        isStartPickerViewable = YES;
        [endLabel setHidden:YES];
        [startDatePicker setHidden:NO];
        [privacyButton setHidden:YES];
        [privacyLabel setHidden:YES];
        [inviteButton setHidden:YES];
    } else {
        isStartPickerViewable = NO;
        [endLabel setHidden:NO];
        [startDatePicker setHidden:YES];
        [privacyButton setHidden:NO];
        [privacyLabel setHidden:NO];
        [inviteButton setHidden:NO];
    }
}

- (IBAction)expandEnd:(UIButton *)sender {
    [startDatePicker setHidden:YES];
    [self dismissKeyboards];
    if (!isEndPickerViewable) {
        isEndPickerViewable = YES;
        [endDatePicker setHidden:NO];
        [privacyButton setHidden:YES];
        [privacyLabel setHidden:YES];
        [inviteButton setHidden:YES];
    } else {
        isEndPickerViewable = NO;
        [endDatePicker setHidden:YES];
        [privacyButton setHidden:NO];
        [privacyLabel setHidden:NO];
        [inviteButton setHidden:NO];
    }
}

- (void)changeStartDateInLabel:(id)sender{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    NSString *displayDate = [df stringFromDate:startDatePicker.date];
    
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"hh:mm a"];
    NSString *displayTime = [tf stringFromDate:startDatePicker.date];
    startLabel.textColor = [UIColor blackColor];
    
    startLabel.text = [NSString stringWithFormat:@"%@     %@", displayDate, displayTime];
    
    startTime = startDatePicker.date;
    
}

- (void)changeEndDateInLabel:(id)sender{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    NSString *displayDate = [df stringFromDate:endDatePicker.date];
    
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"hh:mm a"];
    NSString *displayTime = [tf stringFromDate:endDatePicker.date];
    
    endLabel.text = [NSString stringWithFormat:@"%@     %@", displayDate, displayTime];
    endLabel.textColor = [UIColor blackColor];
    endTime = endDatePicker.date;
    
}

#pragma mark - Pravicy Methods

- (IBAction)expandPrivacy:(id)sender{
    if (privExpanded) {
        [privSetting1Button setHidden:YES];
        [privSetting2Button setHidden:YES];
        [privSetting3Button setHidden:YES];
        [privSetting4Button setHidden:YES];
        privExpanded = NO;
    } else {
        [privSetting1Button setHidden:NO];
        [privSetting2Button setHidden:NO];
        [privSetting3Button setHidden:NO];
        [privSetting4Button setHidden:NO];
        privExpanded = YES;
    }
}

- (IBAction) inviteFriends:(UIButton *)sender
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
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          @"eventID", self.event.objectId, // This event's object id
                          @"eventType", NSStringFromClass([event class]), // This event's object type
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


-(void) pickedPrivSetting{
    privLabel.text = privacy;
    [privSetting1Button setHidden:YES];
    [privSetting2Button setHidden:YES];
    [privSetting3Button setHidden:YES];
    [privSetting4Button setHidden:YES];
    privExpanded = NO;
}

- (IBAction)privSetting1:(UIButton *)sender{
    privacy = @"Invite Only";
    [self pickedPrivSetting];
}

- (IBAction)privSetting2:(UIButton *)sender{
    privacy = @"Friends and Guests";
    [self pickedPrivSetting];
}

-(IBAction)privSetting3:(UIButton *)sender{
    privacy = @"Open Invite";
    [self pickedPrivSetting];
}

-(IBAction)privSetting4:(UIButton *)sender{
    privacy = @"Public";
    [self pickedPrivSetting];
}

- (IBAction)deleteButton:(id)sender{
//    delete = TRUE;
//    UIAlertView *wantToDelete = [[UIAlertView alloc]
//                                  initWithTitle:@"" message:@"Are you sure you want to delete this awesome event???" delegate:self cancelButtonTitle:@"Yes." otherButtonTitles:@"No! Party on!", nil];
//    [wantToDelete show];
//    delete = FALSE;

    PFQuery *qry = [PFQuery queryWithClassName:eventClass];
    [qry getObjectInBackgroundWithId:event.objectId block:^(PFObject *object, NSError *error){
        if ( error ) {
            NSLog(@"Error getting object in editEvent: %@",error);
        } else {
            [object deleteInBackground];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)doneButton:(id)sender {
    BOOL complete = TRUE;
    if (event) {
        event.name = eventName;
        event.desc = desc;
        event.startTime = startTime;
        event.endTime = endTime;
        event.ownerId = [[PFUser currentUser] objectId];
        event.geoPoint = loc;
        event.tags = tags;
        event.privacy = privacy;
        [event saveInBackground];
        UIAlertView *savedEvent = [[UIAlertView alloc]
                                initWithTitle:@"" message:@"Your changes have been saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [savedEvent show];
    }
    if(![tailgateButton.backgroundColor isEqual:highlightedButtonColor] && ![watchPartyButton.backgroundColor isEqual: highlightedButtonColor] && ![afterPartyButton.backgroundColor isEqual:highlightedButtonColor]){
        complete = false;
        [eventTypeMissing setHidden:FALSE];
    }
    if([eventNameLabel.text isEqualToString:@"Event Name"] || [eventNameLabel.text isEqualToString:@""] ){
        complete = false;
        [eventNameMissing setHidden:FALSE];
    }
    if(!loc){
        complete = false;
        [eventLocMissing setHidden:FALSE];
    }
    if ([endLabel.textColor isEqual:[UIColor lightGrayColor]]) {
        complete = false;
        [eventTimeMissing setHidden:FALSE];
    }
    if (!complete) {
        UIAlertView *inCompleteFields = [[UIAlertView alloc]
                                        initWithTitle:@"" message:@"Please complete the required fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [inCompleteFields show];
        
    }else {
        
        //set defaults
        eventName = eventNameLabel.text;
        if ([eventDescLabel.text isEqualToString:@"Event Description"]) {
            desc = @"";
        } else {
            desc = eventDescLabel.text;
        }
        if ([privacy isEqualToString:@""]) {
            privacy = @"Public";
        }
        
        Event *genericEvent = nil;
        
        if (type == tailgateType) {
            Tailgate *tg = [[Tailgate alloc]init];
            genericEvent = tg;
            tg.name = eventName;
            tg.desc = desc;
            tg.startTime = startTime;
            tg.endTime = endTime;
            tg.ownerId = [[PFUser currentUser] objectId];
            tg.confirmedInvites = [NSMutableArray arrayWithObject:[[PFUser currentUser] objectId]];
            tg.geoPoint = loc;
            tg.tags = tags;
            tg.privacy = privacy;
            [tg saveInBackground];
            UIAlertView *savedTG = [[UIAlertView alloc]
                                             initWithTitle:@"" message:@"Thank you for hosting your tailgate with Game Plan!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [savedTG show];
        } else if(type == watchPartyType){
            WatchParty *wp = [[WatchParty alloc]init];
            genericEvent = wp;
            wp.name = eventName;
            wp.desc = desc;
            wp.startTime = startTime;
            wp.endTime = endTime;
            wp.ownerId = [[PFUser currentUser] objectId];
            wp.confirmedInvites = [NSMutableArray arrayWithObject:[[PFUser currentUser] objectId]];
            wp.geoPoint = loc;
            wp.tags = tags;
            wp.privacy = privacy;
            [wp saveInBackground];
            UIAlertView *savedWP = [[UIAlertView alloc]
                                             initWithTitle:@"" message:@"Thank you for hosting your watch party with Game Plan!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [savedWP show];
        } else if(type == afterPartyType){
            AfterParty *ap = [[AfterParty alloc]init];
            genericEvent = ap;
            ap.name = eventName;
            ap.desc = desc;
            ap.startTime = startTime;
            ap.endTime = endTime;
            ap.ownerId = [[PFUser currentUser] objectId];
            ap.confirmedInvites = [NSMutableArray arrayWithObject:[[PFUser currentUser] objectId]];
            ap.geoPoint = loc;
            ap.tags = tags;
            ap.privacy = privacy;
            [ap saveInBackground];
            UIAlertView *savedAP = [[UIAlertView alloc]
                                    initWithTitle:@"" message:@"Thank you for hosting your after party with Game Plan!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [savedAP show];
        }
        
        //get parse ids for invited friends
        PFQuery *queryUsers = [PFUser query];
        [queryUsers whereKey:@"FacebookID" containedIn:invitedFriends];
        
        [queryUsers findObjectsInBackgroundWithBlock:^(NSArray *invitedUsers, NSError *error){
            
            if ( error ) {
                NSLog(@"Error finding friends %@", error);
            } else {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (PFUser *user in invitedUsers) {
                    [arr  addObject:[user objectId]];
                }
                genericEvent.pendingInvites = arr;
                [genericEvent saveInBackground];
            }
            
        }];

        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (IBAction)didTouchCancelButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
