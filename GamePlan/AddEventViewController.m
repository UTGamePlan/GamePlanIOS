//
//  AddEventViewController.m
//  GamePlan
//
//  Created by Courtney Bohrer on 6/16/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import "AddEventViewController.h"
#import "Event.h"
#import "Tailgate.h"
#import "WatchParty.h"
#import "AfterParty.h"


@interface AddEventViewController (){
    EventType *type;
    NSString *eventName;
    NSString *desc;
    NSDate *startTime;
    NSDate *endTime;
    BOOL isPublicEvent;
    BOOL friendsCanInvite;
    BOOL isStartPickerViewable;
    BOOL isEndPickerViewable;
    UIColor *orangeColor;
    NSMutableArray *invitedFriends;
}
@end

@implementation AddEventViewController

@synthesize startDatePicker, endDatePicker, startLabel, endLabel, tailgateButton, watchPartyButton, afterPartyButton, publicEventButton, inviteOnlyButton, eventNameLabel, eventDescLabel, canInviteFriendsButton, canNotInviteFriends;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeDatePickers];
    eventNameLabel.delegate = self;
    eventDescLabel.delegate = self;
    //change to the right color later
    orangeColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Event Type Methods

- (IBAction)tailgateButtonTouchHandler:(id)sender {
    type = tailgateType;
    tailgateButton.backgroundColor = [UIColor orangeColor];
    watchPartyButton.backgroundColor = [UIColor whiteColor];
    afterPartyButton.backgroundColor = [UIColor whiteColor];
}

- (IBAction)watchPartyButtonTouchHandler:(id)sender {
    type = watchPartyType;
    tailgateButton.backgroundColor = [UIColor whiteColor];
    watchPartyButton.backgroundColor = [UIColor orangeColor];
    afterPartyButton.backgroundColor = [UIColor whiteColor];
}

- (IBAction)afterPartyButtonTouchHandler:(id)sender {
    type = afterPartyType;
    tailgateButton.backgroundColor = [UIColor whiteColor];
    watchPartyButton.backgroundColor = [UIColor whiteColor];
    afterPartyButton.backgroundColor = [UIColor orangeColor];
}


-(void) textViewDidBeginEditing:(UITextView *) textView {
    [textView setText:@""];
    textView.textColor = [UIColor blackColor];
}

-(void) dismissKeyboards {
    [self.eventDescLabel resignFirstResponder];
    [self.eventNameLabel resignFirstResponder];
}

#pragma mark - Event Time Methods

-(void) makeDatePickers{
    double locOflabel = 302.5;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //START PICKER
    startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, locOflabel+20, screenWidth, 162)];
    startDatePicker.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [self.view addSubview:startDatePicker];
    [startDatePicker setHidden:YES];
    isStartPickerViewable = NO;
    startDatePicker.date = [NSDate date];
    [startDatePicker addTarget:self action:@selector(changeStartDateInLabel:) forControlEvents:UIControlEventValueChanged];
    
    //START LABEL
    startTime = [NSDate date];
    startLabel = [[UILabel alloc] init];
    startLabel.frame = CGRectMake(120, locOflabel, 160, 30);
    startLabel.textAlignment = UITextAlignmentLeft;
    startLabel.textColor = [UIColor lightGrayColor];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString = [df stringFromDate:startTime];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *timeString = [formatter stringFromDate:startTime];
    startLabel.text = [NSString stringWithFormat:@"%@     %@", dateString, timeString];
    [self.view addSubview:startLabel];
    
    //END PICKER
    endDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, locOflabel+53, screenWidth, 162)];
    endDatePicker.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [self.view addSubview:endDatePicker];
    [endDatePicker setHidden:YES];
    isEndPickerViewable = NO;
    endDatePicker.date = [NSDate date];
    [endDatePicker addTarget:self action:@selector(changeEndDateInLabel:) forControlEvents:UIControlEventValueChanged];
    
    //END LABEL
    endTime = [NSDate date];
    endLabel = [[UILabel alloc] init];
    endLabel.frame = CGRectMake(120, locOflabel+ 32.5, 160, 30);
    endLabel.textAlignment = UITextAlignmentLeft;
    endLabel.textColor = [UIColor lightGrayColor];
    endLabel.text = [NSString stringWithFormat:@"%@     %@", dateString, timeString];
    [self.view addSubview:endLabel];
}


- (IBAction)expandStart:(UIButton *)sender {
    [endDatePicker setHidden:YES];
    [self dismissKeyboards];
    if (!isStartPickerViewable) {
        isStartPickerViewable = YES;
        [endLabel setHidden:YES];
        [startDatePicker setHidden:NO];
    } else {
        isStartPickerViewable = NO;
        [endLabel setHidden:NO];
        [startDatePicker setHidden:YES];
    }
}

- (IBAction)expandEnd:(UIButton *)sender {
    [startDatePicker setHidden:YES];
    [self dismissKeyboards];
    if (!isEndPickerViewable) {
        isEndPickerViewable = YES;
        [endDatePicker setHidden:NO];
    } else {
        isEndPickerViewable = NO;
        [endDatePicker setHidden:YES];
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

- (IBAction)makePublicEvent:(id)sender {
    isPublicEvent = TRUE;
    publicEventButton.backgroundColor = orangeColor;
    inviteOnlyButton.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)makeInviteOnlyEvent:(id)sender {
    isPublicEvent = FALSE;
    publicEventButton.backgroundColor = [UIColor whiteColor];
    inviteOnlyButton.backgroundColor = orangeColor;
}
- (IBAction)friendsCanInviteFriends:(id)sender {
    friendsCanInvite = TRUE;
    canInviteFriendsButton.backgroundColor = orangeColor;
    canNotInviteFriends.backgroundColor = [UIColor whiteColor];
}

- (IBAction)friendsCanNotInviteFriends:(id)sender {
    friendsCanInvite = FALSE;
    canInviteFriendsButton.backgroundColor = [UIColor whiteColor];
    canNotInviteFriends.backgroundColor = orangeColor;
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
    for (id<FBGraphUser> user in friendPickerController.selection) {
        [invitedFriends addObject:user.id];
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



- (IBAction)doneButton:(id)sender {
    if (type == tailgateType) {
        Tailgate *tg = [[Tailgate alloc]init];
        tg.eventName = eventNameLabel.text;
        tg.desc = eventDescLabel.text;
        tg.startTime = startTime;
        tg.endTime = endTime;
        tg.ownerId = [[PFUser currentUser] objectForKey:@"objectId"];
        tg.isPublicEvent = isPublicEvent;
        tg.friendsCanInvite = friendsCanInvite;
        tg.invitedFriends = invitedFriends;
        tg.RSVPdFriends = @[[[PFUser currentUser] objectForKey:@"objectId"]];
        tg.geoPoint = nil;
        [tg saveInBackground];
    } else if(type == watchPartyType){
        WatchParty *wp = [[WatchParty alloc]init];
        wp.eventName = eventNameLabel.text;
        wp.desc = eventDescLabel.text;
        wp.startTime = startTime;
        wp.endTime = endTime;
        wp.ownerId = [[PFUser currentUser] objectForKey:@"objectId"];
        wp.isPublicEvent = isPublicEvent;
        wp.friendsCanInvite = friendsCanInvite;
        wp.invitedFriends = invitedFriends;
        wp.RSVPdFriends = @[[[PFUser currentUser] objectForKey:@"objectId"]];
        wp.geoPoint = nil;
        [wp saveInBackground];
    } else if(type == afterPartyType){
        AfterParty *ap = [[AfterParty alloc]init];
        ap.eventName = eventNameLabel.text;
        ap.desc = eventDescLabel.text;
        ap.startTime = startTime;
        ap.endTime = endTime;
        ap.ownerId = [[PFUser currentUser] objectForKey:@"objectId"];
        ap.isPublicEvent = isPublicEvent;
        ap.friendsCanInvite = friendsCanInvite;
        ap.invitedFriends = invitedFriends;
        ap.RSVPdFriends = @[[[PFUser currentUser] objectForKey:@"objectId"]];
        ap.geoPoint = nil;
        [ap saveInBackground];
    }
}
@end
