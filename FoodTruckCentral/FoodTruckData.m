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
            for (FDataSnapshot* childSnap1 in snapshot.children) {
//                NSLog(@">%@", childSnap1.key);
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
                        if ([childSnap2.key isEqualToString:@"long"]) {
                            temp.longitude = [childSnap2.value doubleValue];
                        }
                        if ([childSnap2.key isEqualToString:@"lat"]) {
                            temp.latitude = [childSnap2.value doubleValue];
                        }
                        
                        self.coords = CLLocationCoordinate2DMake(temp.latitude, temp.longitude);
                    }
                }
                if ([childSnap1.key isEqualToString:@"id"]) {
                    self.identifier = childSnap1.value;
                }
                if ([childSnap1.key isEqualToString:@"email"]) {
                    self.email = childSnap1.value;
                }
                if ([childSnap1.key isEqualToString:@"cellnum"]) {
                    self.cellnum = childSnap1.value;
                }
            }
    
    return self;
}

//only use for testing
-(id)initWithName:(NSString*)name withCoords:(CLLocationCoordinate2D*)coords {
    self.name = name;
    self.coords = *(coords);
    return self;
}

-(CLLocationDistance)getDistanceToLocation:(CLLocation*)location {
    CLLocation *truckLocation = [[CLLocation alloc] initWithLatitude:self.coords.latitude longitude:self.coords.longitude];
    return [location distanceFromLocation:truckLocation];
}

-(float)getDistanceInMilesToLocation:(CLLocation*)location {
    return [self getDistanceToLocation:location]*0.000621371192; // convert from meters to miles
}

-(NSMutableDictionary*)dictionaryToSend {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.menu forKey:@"Menu"];
    [dict setObject:self.owner forKey:@"owner"];
    [dict setObject:self.identifier forKey:@"id"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:self.email forKey:@"email"];
    [dict setObject:self.cellnum forKey:@"cellnum"];
    
    NSMutableDictionary *coordinates = [[NSMutableDictionary alloc] init];
    [coordinates setObject:[NSString stringWithFormat:@"%f", self.coords.latitude] forKey:@"lat"];
    [coordinates setObject:[NSString stringWithFormat:@"%f", self.coords.longitude] forKey:@"long"];
    [dict setObject:coordinates forKey:@"coordinates"];
    
    return dict;
}

@end
