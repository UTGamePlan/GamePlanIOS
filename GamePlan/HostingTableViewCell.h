//
//  HostingTableViewCell.h
//  GamePlan
//
//  Created by Courtney Bohrer on 8/2/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostingTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *eventName;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
