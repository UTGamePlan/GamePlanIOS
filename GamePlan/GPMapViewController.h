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

@interface GPMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *menuView;

@property (strong, nonatomic) IBOutlet UIButton *userProfileImageButton;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBar;
@property (strong, nonatomic) IBOutlet UITextField *searchBar;
@property (retain, nonatomic) UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UIImageView *badge;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIButton *myLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *gameSchedule;
@property (strong, nonatomic) NSMutableArray *tailgates;
@property (strong, nonatomic) NSMutableArray *afterParties;
@property (strong, nonatomic) NSMutableArray *watchParties;
@property (strong, nonatomic) NSMutableArray *restaurants;

#pragma mark - buttons
- (IBAction) showMenuPressed:(UIButton *)sender;
- (IBAction) myLocationPressed:(UIButton *)sender;
- (IBAction) userProfilePicturePressed:(UIButton *)sender;
- (IBAction) filterButtonPressed:(UIButton *)sender;
- (IBAction) refreshButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *dismissSearchViewButton;
- (IBAction)dismissSearchView:(UIButton *)sender;

#pragma mark - filter
@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UIButton *toggleTailgatesButton;
@property (strong, nonatomic) IBOutlet UIButton *toggleAfterPartiesButton;
@property (strong, nonatomic) IBOutlet UIButton *toggleWatchPartiesButton;
@property (strong, nonatomic) IBOutlet UISlider *startDateSlider;
@property (strong, nonatomic) IBOutlet UISlider *endDateSlider;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) NSArray *datesAsStrings;
- (IBAction) toggleTailgatesPressed:(UIButton *)sender;
- (IBAction) toggleAfterPartiesPressed:(UIButton *)sender;
- (IBAction) toggleWatchPartiesPressed:(UIButton *)sender;
@property (strong, nonatomic) NSDate *pastDate;
@property (strong, nonatomic) NSDate *futureDate;
@property BOOL showTailgates;
@property BOOL showAfterParties;
@property BOOL showWatchParties;
@property BOOL showRestaurants;
@property BOOL showEventsInMyPlaybookOnly;
@property int radius;

@end
