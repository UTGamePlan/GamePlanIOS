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
@end

@implementation GPMapViewController
@synthesize transitionController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.transitionController = [[TransitionDelegate alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Check to see if the user is logged in, and if not pop up a FBLoginViewController
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUserLoggedIn = [defaults objectForKey:@"userLoggedIn"];
    if (!([currentUserLoggedIn isEqualToString:@"YES"]))
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FBLogin"];
        vc.view.backgroundColor = [UIColor clearColor];
        [vc setTransitioningDelegate:transitionController];
        vc.modalPresentationStyle= UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
