//
//  Restaurant.m
//  GamePlan
//
//  Created by Courtney Bohrer on 6/24/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

@synthesize geoPoint, name, desc;

+ (NSString *) parseClassName
{
    return @"Restaurant";
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
    return self.name;
}

- (NSString *)subtitle
{
    return self.desc;
}

@end
