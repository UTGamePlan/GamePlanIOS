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

@implementation GPMapViewController
@synthesize transitionController;

BOOL userAllowedLocationTracking;
int timeInSecondsSinceLocationSavedInParse;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This is what allows us to pop transluscent modals
    self.transitionController = [[TransitionDelegate alloc] init];
    
    [self setUpLocationManager];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Check to see if the user is logged in, and if not pop up a FBLoginViewController
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUserLoggedIn = [defaults objectForKey:@"userLoggedIn"];
    if (!([currentUserLoggedIn isEqualToString:@"YES"]))
    {
        // Reference to view controller drawn in Main.storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FBLogin"];
        vc.view.backgroundColor = [UIColor clearColor];
        [vc setTransitioningDelegate:transitionController];
        vc.modalPresentationStyle= UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - User Location

- (void)setUpLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        userAllowedLocationTracking = NO;
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        userAllowedLocationTracking = YES;
    }
}

// this is called as soon as we have a lock on user location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    if (timeInSecondsSinceLocationSavedInParse > 60) {
        PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:self.currentLocation];
        [[PFUser currentUser] setObject:userLocation forKey:@"userLocation"];
        [[PFUser currentUser] saveInBackground];
        timeInSecondsSinceLocationSavedInParse = 0;
    }
    timeInSecondsSinceLocationSavedInParse++;
}













@end
