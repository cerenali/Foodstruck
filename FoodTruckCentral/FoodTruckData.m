//
//  FoodTruckData.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/16/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "FoodTruckData.h"

@implementation FoodTruckData

-(id) initWithSnapshot:(FDataSnapshot *)snapshot{
    //childSnap = one, two, three,...
    for (FDataSnapshot* childSnap in snapshot.children) {
        if ([childSnap hasChildren]) {
            //childSnap1 = Menu, name, owner, coordinates
            for (FDataSnapshot* childSnap1 in childSnap.children) {
                NSLog(@">%@", childSnap1.key);
                if ([childSnap1.key isEqualToString:@"Menu"]) {
                    NSMutableDictionary *menu = [[NSMutableDictionary alloc] init];
                    //childSnap2=Categories
                    for (FDataSnapshot* childSnap2 in childSnap1.children) {
                        //NSLog(@">%@", childSnap2.key);
                        if ([childSnap2 hasChildren]) {
                            for (FDataSnapshot* childSnap3 in childSnap2.children) {
                                //NSLog(@">%@", childSnap3.key);
                                NSMutableArray *dishes = [[NSMutableArray alloc] init];
                                if ([childSnap3 hasChildren]) {
                                    //childSnap4.key = chicken, lamb,...; childSnap4.value = 4.50, 5.00,...
                                    for (FDataSnapshot* childSnap4 in childSnap3.children) {
                                        NSMutableDictionary *dishAndPrice = [[NSMutableDictionary alloc] init];
                                        [dishAndPrice setObject:childSnap4.value forKey:childSnap4.key
                                         ];
                                        [dishes addObject:dishAndPrice];
                                    }
                                }
                                [menu setObject:dishes forKey:childSnap3.key];
                            }
                        }
                    }
                    self.menu = menu;
                }
                if ([childSnap1.key isEqualToString:@"name"]) {
                    self.name = childSnap1.value;
                }
                if ([childSnap1.key isEqualToString:@"owner"]) {
                    self.owner = childSnap1.value;
                }
                if ([childSnap1.key isEqualToString:@"coordinates"]) {
                    //childSnap2=coordinates
                    for (FDataSnapshot* childSnap2 in childSnap1.children) {
                        CLLocationCoordinate2D temp;
                        if ([childSnap2.key isEqualToString:@"longitude"]) {
                            temp.longitude = [childSnap2.value doubleValue];
                        }
                        if ([childSnap2.key isEqualToString:@"latitude"]) {
                            temp.latitude = [childSnap2.value doubleValue];
                        }
                        
                        self.coords = CLLocationCoordinate2DMake(temp.latitude, temp.longitude);
                    }
                }
            }
        }
    }
    
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
