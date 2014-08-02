//
//  PendingInvitesTableViewCell.h
//  GamePlan
//
//  Created by Courtney Bohrer on 8/2/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingInvitesTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *eventName;
@property (nonatomic, weak) IBOutlet UIButton *yesButton;
@property (nonatomic, weak) IBOutlet UIButton *noButton;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;


@end
