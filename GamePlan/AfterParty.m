//
//  AfterParty.m
//  GamePlan
//
//  Created by Courtney Bohrer on 6/16/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import "AfterParty.h"

@implementation AfterParty

@dynamic geoPoint, name, desc, ownerId, isPublicEvent, friendsCanInvite, startTime, endTime;

+ (NSString *) parseClassName
{
    return @"After Party";
}

@end
