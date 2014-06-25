//
//  GPFacebookLoginViewController.h
//  GamePlanIOS
//
//  Created by Courtney Bohrer on 6/7/14.
//  Copyright (c) 2014 Game Plan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "GPMapViewController.h"

@interface GPFacebookLoginViewController : UIViewController

- (IBAction)loginButtonTouchHandler:(id)sender;
@property (nonatomic, strong) UIButton *userProfilePictureButtonForMapViewController;
@property (strong, nonatomic) IBOutlet UIImageView *topBarForMapViewController;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBarForMapViewController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarForMapViewController;
@property (strong, nonatomic) IBOutlet UIButton *menuButtonForMapViewController;
@property (strong, nonatomic) IBOutlet UIButton *myLocationButtonForMapViewController;
@property (strong, nonatomic) IBOutlet UIButton *filterButtonForMapViewController;
@property (strong, nonatomic) IBOutlet UIButton *refreshButtonForMapViewController;

@end
