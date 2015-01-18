//
//  TrackingMapViewController.h
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TrackingMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *trackingMapView;

@property (strong, nonatomic) CLLocation *currentLocation;

@property NSMutableDictionary *dictionary;

@end
