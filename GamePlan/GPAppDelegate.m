//
//  GPAppDelegate.m
//  GamePlanIOS
//
//  Created by Jeremy Hintz on 6/7/14.
//  Copyright (c) 2014 Game Plan. All rights reserved.
//

#import "GPAppDelegate.h"
#import "Event.h"
#import "Tailgate.h"
#import "WatchParty.h"
#import "AfterParty.h"
#import "Restaurant.h"
#import "Game.h"
#import "GPEventDetailViewController.h"
#import "TransitionDelegate.h"


@implementation GPAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Parse Methods

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

#pragma mark - iOS Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"DrHrpL0Bikli0kNhTEBs6SQ7YvxQG1RfiFQGSosN" clientKey:@"EUWx7bvy66G0zg6f3GuHmqwLlI3gvVSlNRNr6kAe"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    [Tailgate registerSubclass];
    [WatchParty registerSubclass];
    [AfterParty registerSubclass];
    [Restaurant registerSubclass];
    [Game registerSubclass];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    // this is for if the app is opened from a push notification
    NSDictionary *payload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(payload) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Yay!"
                                                          message:[NSString stringWithFormat:@"%@: %@", [payload objectForKey:@"eventID"], [payload objectForKey:@"eventType"]]
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    
//        NSString *eventID = [payload objectForKey:@"eventID"];
//        NSString *eventType = [payload objectForKey:@"eventType"];
//        PFObject *event = [PFObject objectWithoutDataWithClassName:eventType objectId:eventID];
//        
//        [event fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//            if (!error && [PFUser currentUser]) {
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                GPEventDetailViewController *eventDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"event-details"];
//                if ([eventType isEqualToString:@"Tailgate"]) {
//                    eventDetailViewController.event = (Tailgate *)object;
//                } else if ([eventType isEqualToString:@"WatchParty"]) {
//                    eventDetailViewController.event = (WatchParty *)object;
//                } else if ([eventType isEqualToString:@"AfterParty"]) {
//                    eventDetailViewController.event = (AfterParty *)object;
//                }
//                eventDetailViewController.eventType = eventType;
//                [[GPAppDelegate topMostController] presentModalViewController:eventDetailViewController animated:YES];
//
//            }
//        }];
    
    }
    
    return YES;
}

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)payload fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Yay!"
                                                      message:[NSString stringWithFormat:@"%@: %@", [payload objectForKey:@"eventID"], [payload objectForKey:@"eventType"]]
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
//    NSString *eventID = [payload objectForKey:@"eventID"];
//    NSString *eventType = [payload objectForKey:@"eventType"];
//    PFObject *event = [PFObject objectWithoutDataWithClassName:eventType objectId:eventID];
//    
//    [event fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        if (error) {
//            handler(UIBackgroundFetchResultFailed);
//        } else if ([PFUser currentUser]) {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            GPEventDetailViewController *eventDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"event-details"];
//            if ([eventType isEqualToString:@"Tailgate"]) {
//                eventDetailViewController.event = (Tailgate *)object;
//            } else if ([eventType isEqualToString:@"WatchParty"]) {
//                eventDetailViewController.event = (WatchParty *)object;
//            } else if ([eventType isEqualToString:@"AfterParty"]) {
//                eventDetailViewController.event = (AfterParty *)object;
//            }
//            eventDetailViewController.eventType = eventType;
//            [[GPAppDelegate topMostController] presentModalViewController:eventDetailViewController animated:YES];
//            handler(UIBackgroundFetchResultNewData);
//        } else {
//            // handler(UIBackgroundModeNoData); <-- not sure why this doesn't work
//        }
//    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
