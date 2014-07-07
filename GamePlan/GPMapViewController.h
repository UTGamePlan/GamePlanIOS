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
#import "REFrostedViewController.h"

@interface GPMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UITableView *menuView;

@property (strong, nonatomic) IBOutlet UIButton *userProfileImageButton;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIButton *myLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction) showMenuPressed:(UIButton *)sender;
- (IBAction) myLocationPressed:(UIButton *)sender;
- (IBAction) userProfilePicturePressed:(UIButton *)sender;

@end
