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
-(id)initWithName:(NSString*)name withCoords:(CLLocationCoordinate2D*)coords;
-(CLLocationDistance)getDistanceToLocation:(CLLocation*)location;
-(float)getDistanceInMilesToLocation:(CLLocation*)location;
-(NSMutableDictionary*)dictionaryToSend;

@property NSString *name;
@property CLLocationCoordinate2D coords;
@property NSMutableDictionary *menu;
@property NSString *owner;
@property NSString *identifier;
@property NSString *email;
@property NSString *cellnum;
@end
