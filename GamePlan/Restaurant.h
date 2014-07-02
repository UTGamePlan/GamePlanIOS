//
//  Restaurant.h
//  GamePlan
//
//  Created by Courtney Bohrer on 6/24/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <Parse/PFObject+Subclass.h>

@interface Restaurant : PFObject <PFSubclassing, MKAnnotation>

@property (nonatomic, strong) PFGeoPoint *geoPoint;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;

@end
