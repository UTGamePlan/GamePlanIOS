//
//  GPWebViewController.h
//  GamePlan
//
//  Created by Jeremy Hintz on 8/14/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPWebViewController : UIViewController

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
- (IBAction) backPressed:(UIButton *)sender;



@end
