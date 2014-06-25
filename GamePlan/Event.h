//
//  Event.h
//  GamePlan
//
//  Created by Courtney Bohrer on 6/16/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <Parse/PFObject+Subclass.h>

@interface Event : PFObject <PFSubclassing, MKAnnotation>

@property (nonatomic, strong) PFGeoPoint *geoPoint;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic) BOOL isPublicEvent;
@property (nonatomic) BOOL friendsCanInvite;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@end
