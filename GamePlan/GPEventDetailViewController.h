//
//  GPEventDetailViewController.h
//  GamePlan
//
//  Created by Jeremy Hintz on 7/26/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Event.h"

@interface GPEventDetailViewController : UIViewController <MKMapViewDelegate,FBFriendPickerDelegate>

@property (nonatomic,strong) Event *event;
@property (nonatomic,strong) NSString *eventType;

@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *hostLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionBackground;
@property (strong, nonatomic) IBOutlet MKMapView *mapPreview;
@property (strong, nonatomic) IBOutlet UILabel *attendeesBackground;
@property (strong, nonatomic) IBOutlet UILabel *whosGoingLabel;
@property (strong, nonatomic) IBOutlet UIImageView *attendeeOne;
@property (strong, nonatomic) IBOutlet UIImageView *attendeeTwo;
@property (strong, nonatomic) IBOutlet UIImageView *attendeeThree;
@property (strong, nonatomic) IBOutlet UIImageView *attendeeFour;
@property (strong, nonatomic) IBOutlet UILabel *andMoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *buttonBackground;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;
@property (strong, nonatomic) IBOutlet UIButton *playbookButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction) backPressed:(UIButton *)sender;
- (IBAction) inviteFriendsPressed:(UIButton *)sender;
- (IBAction) addToPlaybookPressed:(UIButton *)sender;
- (IBAction) shareOnFBPressed:(UIButton *)sender;
- (IBAction) getDirectionsPressed:(UIButton *)sender;


@end
