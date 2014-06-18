//
//  GPMapViewController.m
//  GamePlanIOS
//
//  Created by Jeremy Hintz on 6/7/14.
//  Copyright (c) 2014 Game Plan. All rights reserved.
//

#import "GPMapViewController.h"
#import "TransitionDelegate.h"

@interface GPMapViewController ()

@property (nonatomic, strong) TransitionDelegate *transitionController;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

@end

//Coordinates of Bob Bullock Museum
#define BB_LAT 30.2804859;
#define BB_LONG -97.7386164;

//Span
#define ZOOM 0.02f;

@implementation GPMapViewController
@synthesize transitionController;

BOOL userAllowedLocationTracking;
BOOL userLocationUpdatedOnce;
int timeInSecondsSinceLocationSavedInParse;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This is what allows us to pop transluscent modals
    self.transitionController = [[TransitionDelegate alloc] init];
    
    [self setUpLocationManager];
    [self loadEventPins];
    [self setProfilePhoto];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Check to see if the user is logged in, and if not pop up a FBLoginViewController
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUserLoggedIn = [defaults objectForKey:@"userLoggedIn"];
    if (!([currentUserLoggedIn isEqualToString:@"YES"]))
    {
        // Reference to facebook log in view controller drawn in Main.storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GPFacebookLoginViewController *facebookLoginViewController = [storyboard instantiateViewControllerWithIdentifier:@"FBLogin"];
        facebookLoginViewController.userProfilePictureButtonForMapViewController = self.userProfileImageButton;
        facebookLoginViewController.view.backgroundColor = [UIColor clearColor];
        [facebookLoginViewController setTransitioningDelegate:transitionController];
        facebookLoginViewController.modalPresentationStyle= UIModalPresentationCustom;
        [self presentViewController:facebookLoginViewController animated:YES completion:nil];
    }
}

#pragma mark - User Location

- (void)setUpLocationManager
{
    userLocationUpdatedOnce = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

// handling the user's choice whether or not to allow us to use their location
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        userAllowedLocationTracking = NO;
        // If user doesn't allow location permissions, then just zoom in on Bob Bullock
        MKCoordinateRegion myRegion;
        CLLocationCoordinate2D center;
        center.latitude = BB_LAT;
        center.longitude = BB_LONG;
        MKCoordinateSpan span;
        span.latitudeDelta = ZOOM;
        span.longitudeDelta = ZOOM;
        myRegion.center = center;
        myRegion.span = span;
        [self.mapView setRegion:myRegion animated:YES];
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        userAllowedLocationTracking = YES;
    }
}

// this is called as soon as we have a lock on user location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    if(!(userLocationUpdatedOnce)) {
        MKCoordinateRegion myRegion;
        CLLocationCoordinate2D center;
        center.latitude = self.currentLocation.coordinate.latitude;
        center.longitude = self.currentLocation.coordinate.longitude;
        MKCoordinateSpan span;
        span.latitudeDelta = ZOOM;
        span.longitudeDelta = ZOOM;
        myRegion.center = center;
        myRegion.span = span;
        [self.mapView setRegion:myRegion animated:YES];
        [self.mapView setShowsUserLocation:YES];
        userLocationUpdatedOnce = YES;
    }
    if (timeInSecondsSinceLocationSavedInParse > 60) {
        PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:self.currentLocation];
        [[PFUser currentUser] setObject:userLocation forKey:@"userLocation"];
        [[PFUser currentUser] saveInBackground];
        timeInSecondsSinceLocationSavedInParse = 0;
    }
    timeInSecondsSinceLocationSavedInParse++;
}

- (IBAction) showMenu:(UIButton *)sender
{
    
}


- (void)loadEventPins
{
    [self loadTailgatePins];
    [self loadAfterPartyPins];
    [self loadWatchPartyPins];
    [self loadRestaurantPins];
}

- (void)loadTailgatePins
{
    
}

- (void)loadAfterPartyPins
{
    
}

- (void)loadWatchPartyPins
{
    
}

- (void)loadRestaurantPins
{
    PFQuery *restaurantQuery = [PFQuery queryWithClassName:@"Restaurants"];
    [restaurantQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // TODO: Implement handling of calls to restaurant data
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

-(void) setProfilePhoto
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.userProfileImageButton.layer setCornerRadius:self.userProfileImageButton.frame.size.width/2];
    self.userProfileImageButton.layer.masksToBounds = YES;
    UIImage *userProfileImage;
    if([defaults objectForKey:@"pictureURL"]!=nil) {
        userProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[defaults objectForKey:@"pictureURL"]]]];
    } else {
        userProfileImage = [UIImage imageNamed:@"default_profile.jpg"];
    }
    [self.userProfileImageButton setBackgroundImage:userProfileImage forState:UIControlStateNormal];
}











@end
