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
}
@end

@implementation EditEventVC 

@synthesize startDatePicker, endDatePicker, startLabel, endLabel, tailgateButton, watchPartyButton, afterPartyButton, eventNameLabel, eventDescLabel, BYOBButton, FreeFoodButton, CoverChargeButton, KidFriendlyButton, AlumniButton, StudentsButton, event, eventTypeMissing, eventNameMissing, eventLocMissing, eventTimeMissing, privacyButton, inviteButton, privSetting1Button, privSetting2Button, privSetting3Button, privSetting4Button, privLabel, miniMap, expandedMap, miniMapButton, titleLabel, mainMap, privacyLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set up view
    [self makeDatePickers];
    eventNameLabel.delegate = self;
    eventDescLabel.delegate = self;
    highlightedButtonColor = [UIColor darkGrayColor];
    [self.myScrollView addSubview:self.myView];
    self.myScrollView.contentSize = self.myView.bounds.size;
    [eventTypeMissing setHidden:YES];
    [eventNameMissing setHidden:YES];
    [eventLocMissing setHidden:YES];
    [eventTimeMissing setHidden:YES];
    [privSetting1Button setHidden:YES];
    [privSetting2Button setHidden:YES];
    [privSetting3Button setHidden:YES];
    [privSetting4Button setHidden:YES];
    privExpanded = NO;
    
    // setting up maps
    CLLocationCoordinate2D bbLoc;
    bbLoc.latitude = 30.2804859;
    bbLoc.longitude = -97.7386164;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1f;
    span.longitudeDelta = 0.1f;
    
    MKCoordinateRegion reg;
    reg.center = bbLoc;
    reg.span = span;
    
    delete = false;
    
    [miniMap setCenterCoordinate:bbLoc animated:YES];
    [miniMap setRegion:reg];
    [expandedMap setCenterCoordinate:bbLoc animated:YES];
    [expandedMap setRegion:reg];
    [expandedMap setHidden:YES];
    
    //UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropPin:)];
    UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(dropPin:)];
    tapRecognizer.minimumPressDuration = 1.0;
    [expandedMap addGestureRecognizer:tapRecognizer];
    
    if(event){
        titleLabel.text = @"Edit Event";
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
        annot = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
        annot.coordinate = coord;
        [expandedMap addAnnotation:annot];
        [miniMap addAnnotation:annot];
        privacy = event.privacy;
        privLabel.text = privacy;
            
        } else {
            tags = [[NSMutableArray alloc] init];
            invitedFriends = [[NSMutableArray alloc] init];
            titleLabel.text = @"Add an Event";
//        CGRect newFrame = self.myView.frame;
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        newFrame.size.width = screenRect.size.width;
//        newFrame.size.height = screenRect.size.height+100;
//        [self.myView setFrame:newFrame];
        privacy = @"";
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( self.event == nil ) {
        self.deleteButton.hidden = YES;
    } else {
        self.tailgateButton.enabled = NO;
        self.watchPartyButton.enabled = NO;
        self.afterPartyButton.enabled = NO;
        
        id<PFSubclassing> sc = (id<PFSubclassing>)self.event;
        
        if ( [[sc parseClassName] isEqualToString:@"Tailgate"] ) {
            self.tailgateButton.selected = YES;
        }
        if ( [[sc parseClassName] isEqualToString:@"Watch Party"] ) {
            self.watchPartyButton.selected = YES;
        }
        if ( [[sc parseClassName] isEqualToString:@"After Party"] ) {
            self.afterPartyButton.selected = YES;
        }
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
            return;
        }
    }
    [tags addObject:@"BYOB"];
    BYOBButton.backgroundColor = highlightedButtonColor;
    [self dismissKeyboards];
}

- (IBAction)FreeFoodButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"FreeFood"]) {
            [tags removeObject:str];
            FreeFoodButton.backgroundColor = [UIColor whiteColor];
            return;
        }
    }
    [tags addObject:@"FreeFood"];
    FreeFoodButton.backgroundColor = highlightedButtonColor;
    [self dismissKeyboards];
}


- (IBAction)CoverChargeButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"CoverCharge"]) {
            [tags removeObject:str];
            CoverChargeButton.backgroundColor = [UIColor whiteColor];
            return;
        }
    }
    [tags addObject:@"CoverCharge"];
    CoverChargeButton.backgroundColor = highlightedButtonColor;
    [self dismissKeyboards];
}

- (IBAction)KidFriendlyButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"KidFriendly"]) {
            [tags removeObject:str];
            KidFriendlyButton.backgroundColor = [UIColor whiteColor];
            return;
        }
    }
    [tags addObject:@"KidFriendly"];
    KidFriendlyButton.backgroundColor = highlightedButtonColor;
    [self dismissKeyboards];
}

- (IBAction)AlumniButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"Alumni"]) {
            [tags removeObject:str];
            AlumniButton.backgroundColor = [UIColor whiteColor];
            return;
        }
    }
    [tags addObject:@"Alumni"];
    AlumniButton.backgroundColor = highlightedButtonColor;
    [self dismissKeyboards];
}

- (IBAction)StudentsButtonTouchHandler:(id)sender{
    for(NSString *str in tags ){
        if ([str isEqualToString:@"Students"]) {
            [tags removeObject:str];
            StudentsButton.backgroundColor = [UIColor whiteColor];
            return;
        }
    }
    [tags addObject:@"Students"];
    StudentsButton.backgroundColor = highlightedButtonColor;
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

- (IBAction)inviteFriends:(UIButton *)sender {
    // Initialize the friend picker
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    // Set the friend picker title
    friendPickerController.title = @"INVITE";
    
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

/*
 * Event: Done button clicked
 */
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    FBFriendPickerViewController *friendPickerController =
    (FBFriendPickerViewController*)sender;
    
    //save invited friends
//    for (id<FBGraphUser> user in friendPickerController.selection) {
//        NSString *userId = [NSString stringWithFormat:@"%d",[user objectForKey:@"id"]];
//        [invitedFriends addObject: userId];
//    }
    
    for (id<FBGraphUser> user in friendPickerController.selection) {
        NSString *str = [NSString stringWithFormat:@"%@", user.id];
        [invitedFriends addObject:str];
    }
    
    //dismiss modal
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


-(void)saveEvent: (Event *)event{
    NSDictionary *eventsIHost = [[PFUser currentUser] objectForKey:@"EventsIHost"];
    NSDictionary *playbook = [[PFUser currentUser] objectForKey:@"Playbook"];
    
    if(!eventsIHost)
        eventsIHost = [[NSDictionary alloc] init];
    if (!playbook) {
        playbook = [[NSDictionary alloc] init];
    }
    
    NSString *className;
    if (type == tailgateType) {
        className = @"Tailgate";
    } else if(type == watchPartyType) {
        className = @"WatchParty";
    } else {
        className = @"AfterParty";
    }
    
    [eventsIHost setValue:className forKeyPath:event.objectId];
    [[PFUser currentUser] setObject:eventsIHost forKey:@"EventsIHost"];
    [playbook setValue:className forKeyPath:event.objectId];
    [[PFUser currentUser] setObject:playbook forKey:@"Playbook"];
    
//    if([[[PFUser currentUser] objectForKey:@"EventsIHost"] isEqual: nil])
//       [[PFUser currentUser] setObject:[[NSMutableArray alloc] initWithObjects:event.objectId, nil] forKey:@"EventsIHost"];
//    else
//        [[PFUser currentUser] addObject:event.objectId forKey:@"EventsIHost"];
//    if ([[[PFUser currentUser] objectForKey:@"Playbook"] isEqual:nil]) {
//        [[PFUser currentUser] setObject:[[NSMutableArray alloc] initWithObjects:event.objectId, nil] forKey:@"Playbook"];
//    }
//    [[PFUser currentUser] addObject:event.objectId forKey:@"Playbook"];
    
    [[PFUser currentUser] saveInBackground];
}

- (IBAction)deleteButton:(id)sender{
//    delete = TRUE;
//    UIAlertView *wantToDelete = [[UIAlertView alloc]
//                                  initWithTitle:@"" message:@"Are you sure you want to delete this awesome event???" delegate:self cancelButtonTitle:@"Yes." otherButtonTitles:@"No! Party on!", nil];
//    [wantToDelete show];
//    delete = FALSE;

    [event deleteInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)doneButton:(id)sender {
    BOOL complete = TRUE;
    if (event) {
        event.name = eventName;
        event.desc = desc;
        event.startTime = startTime;
        event.endTime = endTime;
        event.ownerId = [[PFUser currentUser] objectId];
        event.invitedFriends = invitedFriends;
        event.RSVPdFriends = [NSMutableArray arrayWithObject:[[PFUser currentUser] objectId]];
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
        
        //get parse ids for invited friends
       NSMutableArray *invitedFriendsIDs = [[NSMutableArray alloc] init];
        PFQuery *queryUsers = [PFUser query];
        [queryUsers whereKey:@"FacebookID" containedIn:invitedFriends];
        
        NSArray *invitedFriendUsers = [queryUsers findObjects];
        
        if (type == tailgateType) {
            Tailgate *tg = [[Tailgate alloc]init];
            
            tg.name = eventName;
            tg.desc = desc;
            tg.startTime = startTime;
            tg.endTime = endTime;
            tg.ownerId = [[PFUser currentUser] objectId];
            tg.invitedFriends = invitedFriendsIDs;
            tg.RSVPdFriends = [NSMutableArray arrayWithObject:[[PFUser currentUser] objectId]];
            tg.geoPoint = loc;
            tg.tags = tags;
            tg.privacy = privacy;
            [tg saveInBackground];
            
            for (PFUser *user in invitedFriendUsers){
                [invitedFriendsIDs addObject:user.objectId];
//                [user addObject:tg forKey:@"PendingInvites"];
//                [user saveInBackground];
            }
            
            [self performSelector:@selector(saveEvent:) withObject:tg afterDelay:0.5];
            UIAlertView *savedTG = [[UIAlertView alloc]
                                             initWithTitle:@"" message:@"Thank you for hosting your tailgate with Game Plan!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [savedTG show];
        } else if(type == watchPartyType){
            WatchParty *wp = [[WatchParty alloc]init];
            wp.name = eventName;
            wp.desc = desc;
            wp.startTime = startTime;
            wp.endTime = endTime;
            wp.ownerId = [[PFUser currentUser] objectId];
            wp.invitedFriends = invitedFriendsIDs;
            wp.RSVPdFriends = [NSMutableArray arrayWithObject:[[PFUser currentUser] objectId]];
            wp.geoPoint = loc;
            wp.tags = tags;
            wp.privacy = privacy;
            [wp saveInBackground];
            [self performSelector:@selector(saveEvent:) withObject:wp afterDelay:0.5];
            UIAlertView *savedWP = [[UIAlertView alloc]
                                             initWithTitle:@"" message:@"Thank you for hosting your watch party with Game Plan!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [savedWP show];
        } else if(type == afterPartyType){
            AfterParty *ap = [[AfterParty alloc]init];
            ap.name = eventName;
            ap.desc = desc;
            ap.startTime = startTime;
            ap.endTime = endTime;
            ap.ownerId = [[PFUser currentUser] objectId];
            ap.invitedFriends = invitedFriendsIDs;
            ap.RSVPdFriends = [NSMutableArray arrayWithObject:[[PFUser currentUser] objectId]];
            ap.geoPoint = loc;
            ap.tags = tags;
            ap.privacy = privacy;
            [ap saveInBackground];
            
            [self performSelector:@selector(saveEvent:) withObject:ap afterDelay:0.5];
            UIAlertView *savedAP = [[UIAlertView alloc]
                                    initWithTitle:@"" message:@"Thank you for hosting your after party with Game Plan!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [savedAP show];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (IBAction)didTouchCancelButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
