//
//  EditEventVC.h
//  GamePlan
//
//  Created by Courtney Bohrer on 7/27/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Event.h"

@interface EditEventVC : UIViewController <UITextViewDelegate, FBViewControllerDelegate>

typedef enum {
    tailgateType, watchPartyType, afterPartyType
} EventType;

@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet MKMapView *miniMap;
- (IBAction)didClickMiniMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *miniMapButton;
@property (weak, nonatomic) IBOutlet MKMapView *expandedMap;

#pragma mark - Event Type
@property (weak, nonatomic) IBOutlet UIButton *tailgateButton;
@property (weak, nonatomic) IBOutlet UIButton *watchPartyButton;
@property (weak, nonatomic) IBOutlet UIButton *afterPartyButton;
- (IBAction)tailgateButtonTouchHandler:(id)sender;
- (IBAction)watchPartyButtonTouchHandler:(id)sender;
- (IBAction)afterPartyButtonTouchHandler:(id)sender;

#pragma mark - Event Name and Description
@property (strong, nonatomic) IBOutlet UITextView *eventNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *eventDescLabel;

#pragma mark - HashTag Buttons
@property (weak, nonatomic) IBOutlet UIButton *BYOBButton;
- (IBAction)BYOBButtonTouchHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *FreeFoodButton;
- (IBAction)FreeFoodButtonTouchHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CoverChargeButton;
- (IBAction)CoverChargeButtonTouchHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *KidFriendlyButton;
- (IBAction)KidFriendlyButtonTouchHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AlumniButton;
- (IBAction)AlumniButtonTouchHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *StudentsButton;
- (IBAction)StudentsButtonTouchHandler:(id)sender;


#pragma mark - Event Times
@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
- (IBAction)expandStart:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;
- (IBAction)expandEnd:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;

# pragma mark - Privacy Settings
- (IBAction)expandPrivacy:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *privLabel;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
- (IBAction)inviteFriends:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *privSetting1Button;
- (IBAction)privSetting1:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *privSetting2Button;
- (IBAction)privSetting2:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *privSetting3Button;
- (IBAction)privSetting3:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *privSetting4Button;
- (IBAction)privSetting4:(UIButton *)sender;

#pragma mark - Finalize Buttons
- (IBAction)doneButton:(id)sender;
- (IBAction)deleteButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

#pragma mark - Missing Field Messages
@property (weak, nonatomic) IBOutlet UILabel *eventTypeMissing;
@property (weak, nonatomic) IBOutlet UILabel *eventNameMissing;
@property (weak, nonatomic) IBOutlet UILabel *eventLocMissing;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeMissing;


@end
