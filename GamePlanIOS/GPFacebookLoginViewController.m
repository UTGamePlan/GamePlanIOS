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
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //Create Facebook requests
            FBRequest *request1 = [FBRequest requestForGraphPath:@"me"];
            FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends"];
            
            // Send request to Facebook
            [request1 startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    NSLog(@"USERDATA: %@", userData);
                    
                    //get facebook id and pic URL
                    NSString *facebookID = userData[@"id"];
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    
                    if (facebookID) {
                        [[PFUser currentUser] setObject:facebookID forKey:@"FacebookID"];
                        [defaults setObject:facebookID forKey:@"facebookID"];
                    }
                    
                    if (userData[@"name"]) {
                        [[PFUser currentUser] setObject:userData[@"name"] forKey:@"Name"];
                        [defaults setObject:userData[@"name"] forKey:@"name"];
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
                        [[PFUser currentUser] setObject:[pictureURL absoluteString] forKey:@"FBPictureURL"];
                        [defaults setObject:(NSURL *)[pictureURL absoluteString] forKey:@"pictureURL"];
                    }
                    NSLog(@"%@", pictureURL);
                    
                    [[PFUser currentUser] save];
                    
                }
            }];

            [ friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userData = (NSDictionary *)result;

                    NSArray *friendObjects = [result objectForKey:@"data"];
                    [[PFUser currentUser] setObject:friendObjects forKey:@"friends"];
                    [defaults setObject:friendObjects forKey:@"friends"];
                    [[PFUser currentUser] save];
                }
            }];
            
            
        } else {
            NSLog(@"User with facebook logged in!");

        }
    }];
}
@end
