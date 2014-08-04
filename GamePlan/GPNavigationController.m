//
//  GPNavigationController.m
//  GamePlanIOS
//
//  Created by Jeremy Hintz on 6/18/14.
//  Copyright (c) 2014 Jeremy Hintz. All rights reserved.
//

#import "GPNavigationController.h"

@interface GPNavigationController ()

@end

@implementation GPNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController panGestureRecognized:sender];
}

@end
