//
//  GPFacebookLoginViewController.m
//  GamePlanIOS
//
//  Created by Courtney Bohrer on 6/7/14.
//  Copyright (c) 2014 Game Plan. All rights reserved.
//

#import "GPFacebookLoginViewController.h"

@interface GPFacebookLoginViewController ()

@end

@implementation GPFacebookLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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

- (IBAction)loginButtonTouchHandler:(id)sender {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"email", @"user_birthday", @"user_location", @"user_friends", @"read_friendlists"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                              message:[NSString stringWithFormat:@"An error occured. Please check your network connectivity and try again."]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            
        } else {
            NSLog(@"User with facebook signed up and logged in!");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //Create Facebook requests
            FBRequest *request1 = [FBRequest requestForGraphPath:@"me"];
            
            // Send request to Facebook
            [request1 startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    //get facebook id and pic URL
                    NSString *facebookID = userData[@"id"];
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    
                    if (facebookID) {
                        [[PFUser currentUser] setObject:facebookID forKey:@"FacebookID"];
                        [defaults setObject:facebookID forKey:@"facebookID"];
                        NSLog(@"FACEBOOK ID: %@", facebookID);
                    }
                    
                    if (userData[@"name"]) {
                        [[PFUser currentUser] setObject:userData[@"name"] forKey:@"Name"];
                        [defaults setObject:userData[@"name"] forKey:@"name"];
                        NSLog(@"Name: %@", userData[@"name"]);
                    }
                    
                    if (userData[@"location"][@"name"]) {
                        [[PFUser currentUser] setObject:userData[@"location"][@"name"] forKey:@"Location"];
                    }
                    
                    if (userData[@"gender"]) {
                        [[PFUser currentUser] setObject:userData[@"gender"] forKey:@"Gender"];
                    }
                    
                    if (userData[@"birthday"]) {
                        [[PFUser currentUser] setObject:userData[@"birthday"] forKey:@"Birthday"];
                    }
                    
                    if (userData[@"email"]) {
                        [[PFUser currentUser] setObject:userData[@"email"] forKey:@"email"];
                    }
                    
                    if ([pictureURL absoluteString]) {
                        NSLog(@"PICTURE URL");
                        [[PFUser currentUser] setObject:[pictureURL absoluteString] forKey:@"FBPictureURL"];
                        [defaults setObject:(NSURL *)[pictureURL absoluteString] forKey:@"pictureURL"];
                        // Set the profile picture button back on the map view screen
                        [self.userProfilePictureButtonForMapViewController setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[pictureURL absoluteString]]]] forState:UIControlStateNormal];
                    }
                    
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    currentInstallation[@"user"] = [PFUser currentUser];
                    [currentInstallation saveInBackground];
                    
                    if([currentInstallation objectId]) {
                        [[PFUser currentUser] setObject:[[PFInstallation currentInstallation] objectId] forKey:@"InstallationID"];
                    }
                    
                    [[PFUser currentUser] saveInBackground];
                    [self presentMenuBarsOnMapViewController];
                }
            }];
            
            /* make the API call for users' friends */
            [FBRequestConnection startWithGraphPath:@"/me/friends"
                                         parameters:nil
                                         HTTPMethod:@"GET"
                                  completionHandler:^(
                                                      FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error
                                                      ) {
                                      NSDictionary *response = (NSDictionary *)result;
                                      NSArray *data = [response objectForKey:@"data"];
                                      [[PFUser currentUser] setObject:data forKey:@"Friends"];
                                      
                                      [[PFUser currentUser] saveInBackground];
                                  }];
            [defaults setObject:@"YES" forKey:@"userLoggedIn"];
            
            [self dismissViewControllerAnimated:YES completion:nil];

        }
    }];
}

-(void)presentMenuBarsOnMapViewController
{
    CGRect topBarFrame = self.topBarForMapViewController.frame;
    CGRect searchBarFrame = self.searchBarForMapViewController.frame;
    CGRect bottomBarFrame = self.bottomBarForMapViewController.frame;
    CGRect menuButtonFrame = self.menuButtonForMapViewController.frame;
    CGRect filterButtonFrame = self.filterButtonForMapViewController.frame;
    CGRect refreshButtonFrame = self.refreshButtonForMapViewController.frame;
    CGRect myLocationButtonFrame = self.myLocationButtonForMapViewController.frame;
    CGRect profileImageButtonFrame = self.userProfilePictureButtonForMapViewController.frame;
    
    [UIView beginAnimations:@"raise filterView!" context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.topBarForMapViewController setFrame:CGRectMake(0, 0, topBarFrame.size.width, topBarFrame.size.height)];
    [self.searchBarForMapViewController setFrame:CGRectMake(searchBarFrame.origin.x, 18.0, searchBarFrame.size.width, searchBarFrame.size.height)];
    [self.bottomBarForMapViewController setFrame:CGRectMake(bottomBarFrame.origin.x, self.view.frame.size.height-bottomBarFrame.size.height, bottomBarFrame.size.width, bottomBarFrame.size.height)];
    bottomBarFrame = self.bottomBarForMapViewController.frame;
    float newButtonYVal = self.view.frame.size.height - 0.5*(bottomBarFrame.size.height - menuButtonFrame.size.height);
    [self.menuButtonForMapViewController setFrame:CGRectMake(menuButtonFrame.origin.x, newButtonYVal, menuButtonFrame.size.width, menuButtonFrame.size.height)];
    [self.myLocationButtonForMapViewController setFrame:CGRectMake(myLocationButtonFrame.origin.x, newButtonYVal, myLocationButtonFrame.size.width, myLocationButtonFrame.size.height)];
    [self.filterButtonForMapViewController setFrame:CGRectMake(filterButtonFrame.origin.x, newButtonYVal, filterButtonFrame.size.width, filterButtonFrame.size.height)];
    [self.refreshButtonForMapViewController setFrame:CGRectMake(refreshButtonFrame.origin.x, newButtonYVal, refreshButtonFrame.size.width, refreshButtonFrame.size.height)];
    [self.userProfilePictureButtonForMapViewController setFrame:CGRectMake(profileImageButtonFrame.origin.x, 20, profileImageButtonFrame.size.width, profileImageButtonFrame.size.height)];
    
    [UIView commitAnimations];
}

@end
