//
//  GPEventDetailViewController.m
//  GamePlan
//
//  Created by Jeremy Hintz on 7/26/14.
//  Copyright (c) 2014 Courtney Bohrer. All rights reserved.
//

#import "GPEventDetailViewController.h"
#import "Tailgate.h"
#import "AfterParty.h"
#import "WatchParty.h"
#import "Restaurant.h"

@interface GPEventDetailViewController ()

@end

@implementation GPEventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateLabels];
    [self zoomInToMap];
}

- (void)populateLabels
{
    // EVENT NAME LABEL
    self.eventNameLabel.numberOfLines = 0;
    self.eventNameLabel.text = [self.eventInfo objectForKey:@"name"];
    // HOST LABEL
    if ([self.eventInfo objectForKey:@"ownerId"]) {
        self.hostLabel.text = [self.eventInfo objectForKey:@"ownerId"];
    } else {
        self.hostLabel.text = @"";
    }
    // DATE LABEL
    if ([self.eventInfo objectForKey:@"startTime"]){
        NSDateFormatter *longDateFormatter = [[NSDateFormatter alloc] init];
        longDateFormatter.dateStyle = NSDateFormatterLongStyle;
        NSDateFormatter *shortDateFormatter = [[NSDateFormatter alloc] init];
        shortDateFormatter.dateStyle = NSDateFormatterLongStyle;
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"h:mm a"];
        
        NSString *startDate = [longDateFormatter stringFromDate:[self.eventInfo objectForKey:@"startTime"]];
        NSString *startTime = [timeFormatter stringFromDate:[self.eventInfo objectForKey:@"startTime"]];
        if ([self.eventInfo objectForKey:@"endTime"]) {
            NSString *endDate = [longDateFormatter stringFromDate:[self.eventInfo objectForKey:@"endTime"]];
            NSString *endTime = [timeFormatter stringFromDate:[self.eventInfo objectForKey:@"endTime"]];
            if ([startDate isEqualToString:endDate]) {
                self.dateLabel.text = [NSString stringWithFormat:@"%@ from %@ to %@",startDate,startTime,endTime];
            } else {
                NSString *startShort = [shortDateFormatter stringFromDate:[self.eventInfo objectForKey:@"startTime"]];
                NSString *endShort = [shortDateFormatter stringFromDate:[self.eventInfo objectForKey:@"endTime"]];
                self.dateLabel.text = [NSString stringWithFormat:@"%@ %@ to %@ %@",startShort,startTime,endShort,endTime];
            }
        }
    }
}

- (void)zoomInToMap
{
    PFGeoPoint *eventGeoPoint = [self.eventInfo objectForKey:@"geoPoint"];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(eventGeoPoint.latitude, eventGeoPoint.longitude);
    float zoom = 0.02f;
    MKCoordinateRegion myRegion;
    MKCoordinateSpan span;
    span.latitudeDelta = zoom;
    span.longitudeDelta = zoom;
    myRegion.span = span;
    myRegion.center = CLLocationCoordinate2DMake(eventGeoPoint.latitude, eventGeoPoint.longitude);;
    [self.mapPreview setRegion:myRegion animated:YES];
    [self.mapPreview addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    // Handle any custom annotations.
    NSString *eventType = [self.eventInfo objectForKey:@"eventType"];
    
    // Try to dequeue an existing pin view first.
    MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:eventType];
    if (!pinView)
    {
        // If an existing pin view was not available, create one.
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:eventType];
        pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-pin.png", eventType]];
        pinView.canShowCallout = YES;
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
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
