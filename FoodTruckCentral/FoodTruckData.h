//
//  FoodTruckData.h
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/16/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>

@interface FoodTruckData : NSObject
-(id)initWithSnapshot:(FDataSnapshot *)snapshot;
-(CLLocationDistance)getDistanceToLocation:(CLLocation*)location;
-(float)getDistanceInMilesToLocation:(CLLocation*)location;

@property NSString *name;
@property CLLocationCoordinate2D coords;
@property NSMutableDictionary *menu;
@property NSString *owner;
@end
