//
//  GPRootViewController.m
//  GamePlanIOS
//
//  Created by Jeremy Hintz on 6/19/14.
//  Copyright (c) 2014 Jeremy Hintz. All rights reserved.
//

#import "GPRootViewController.h"

@interface GPRootViewController ()

@end

@implementation GPRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

@end
