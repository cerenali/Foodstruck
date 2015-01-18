//
//  TrackingMapViewController.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "TrackingMapViewController.h"

@interface TrackingMapViewController ()

@end

@implementation TrackingMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.trackingMapView.delegate = self;
    MKCoordinateSpan defaultSpan = MKCoordinateSpanMake(0.5, 1.0);
    
    CLLocationCoordinate2D dropoffCoords = [self getCoordsFromDictionaryWithKey:@"dropoff"];
    CLLocationCoordinate2D pickupCoords = [self getCoordsFromDictionaryWithKey:@"pickup"];
    
    [self addAnnotationAtCoords:dropoffCoords withTitle:@"Dropoff Location" withSubtitle:nil];
    [self addAnnotationAtCoords:pickupCoords withTitle:@"Courier" withSubtitle:@"Your delivery is on its way"]; // later: update subtitle to have ETA?
    
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMake(dropoffCoords, defaultSpan);
    [self.trackingMapView setRegion:defaultRegion];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinLocation"];
    
    if ([annotation.title isEqualToString:@"Dropoff Location"]) {
        newAnnotation.pinColor = MKPinAnnotationColorPurple;
    }
    
    newAnnotation.canShowCallout = YES;
    
    return newAnnotation;
}

-(void)addAnnotationAtCoords:(CLLocationCoordinate2D)coords withTitle:(NSString *)title withSubtitle:(NSString *)subtitle {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coords;
    annotation.title = title;
    if (subtitle)
        annotation.subtitle = subtitle;
    [self.trackingMapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CLLocationCoordinate2D)getCoordsFromDictionaryWithKey:(NSString *)key {
    NSDictionary *dropoff = [self.dictionary objectForKey:key];
    NSDictionary *coordDict = [dropoff objectForKey:@"location"];
    return CLLocationCoordinate2DMake([[coordDict objectForKey:@"lat"] floatValue], [[coordDict objectForKey:@"lng"] floatValue]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
