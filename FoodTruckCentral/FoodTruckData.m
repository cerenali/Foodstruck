//
//  FoodTruckData.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/16/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "FoodTruckData.h"

@implementation FoodTruckData

-(id) initWithName:(NSString *)name withCoords:(CLLocationCoordinate2D)coordinates {
    self.name = name;
    self.coords = coordinates;
    
    return self;
}

-(CLLocationDistance)getDistanceToLocation:(CLLocation*)location {
    CLLocation *truckLocation = [[CLLocation alloc] initWithLatitude:self.coords.latitude longitude:self.coords.longitude];
    return [location distanceFromLocation:truckLocation];
}

-(float)getDistanceInMilesToLocation:(CLLocation*)location {
    return [self getDistanceToLocation:location]*0.000621371192; // convert from meters to miles
}

@end
