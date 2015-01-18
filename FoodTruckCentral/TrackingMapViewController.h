//
//  TrackingMapViewController.h
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TrackingMapViewController : UIViewController <MKMapViewDelegate, NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *trackingMapView;

@property CLLocationCoordinate2D courierCoords;
@property NSMutableDictionary *dictionary;
@property NSString *orderID;

@end
