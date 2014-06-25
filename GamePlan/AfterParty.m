//
//  AfterParty.m
//  GamePlan
//
//  Created by Courtney Bohrer on 6/16/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import "AfterParty.h"

@implementation AfterParty

+ (NSString *) parseClassName
{
    return @"After Party";
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D ret;
    
    ret.latitude = self.geoPoint.latitude;
    ret.longitude = self.geoPoint.longitude;
    
    return ret;
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    if ( !self.geoPoint ) {
        self.geoPoint = [PFGeoPoint geoPoint];
    }
    self.geoPoint.latitude = newCoordinate.latitude;
    self.geoPoint.longitude = newCoordinate.longitude;
    [self saveInBackground];
}

- (NSString *)title
{
    return self.eventName;
}

- (NSString *)subtitle
{
    return self.desc;
}

@end
