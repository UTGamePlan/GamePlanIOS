//
//  GPWebViewController.m
//  GamePlan
//
//  Created by Jeremy Hintz on 8/14/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import "GPWebViewController.h"

@interface GPWebViewController ()

@end

@implementation GPWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //load url into webview
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webview loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) backPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
