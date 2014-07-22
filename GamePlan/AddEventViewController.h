//
//  AddEventViewController.h
//  GamePlan
//
//  Created by Courtney Bohrer on 6/16/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventViewController : UIViewController


typedef enum {
    tailgateType, watchPartyType, afterPartyType
} EventType;

#pragma mark - Event Type
@property (weak, nonatomic) IBOutlet UIButton *tailgateButton;
@property (weak, nonatomic) IBOutlet UIButton *watchPartyButton;
@property (weak, nonatomic) IBOutlet UIButton *afterPartyButton;
- (IBAction)tailgateButtonTouchHandler:(id)sender;
- (IBAction)watchPartyButtonTouchHandler:(id)sender;
- (IBAction)afterPartyButtonTouchHandler:(id)sender;

#pragma mark - Evnt Name and Description
@property (strong, nonatomic) IBOutlet UITextView *eventNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *eventDescLabel;


#pragma mark - Event Times
@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
- (IBAction)expandStart:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;
- (IBAction)expandEnd:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;

# pragma mark - Privacy Settings
- (IBAction)makePublicEvent:(id)sender;
- (IBAction)makeInviteOnlyEvent:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *publicEventButton;
@property (strong, nonatomic) IBOutlet UIButton *inviteOnlyButton;
- (IBAction)friendsCanInviteFriends:(id)sender;
- (IBAction)friendsCanNotInviteFriends:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *canInviteFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *canNotInviteFriends;


- (IBAction)inviteFriends:(UIButton *)sender;

- (IBAction)doneButton:(id)sender;
@end
