//
//  GPMapViewController.h
//  GamePlanIOS
//
//  Created by Jeremy Hintz on 6/7/14.
//  Copyright (c) 2014 Game Plan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "GPFacebookLoginViewController.h"

@interface GPMapViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) UITableView *menuView;

@property (strong, nonatomic) IBOutlet UIButton *userProfileImageButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction) showMenu:(UIButton *)sender;

@end
