//
//  RetriveFoodTrucks.m
//  FoodTruckCentral
//
//  Created by Joseph Cappadona on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "RetrieveFoodTrucks.h"

@implementation RetrieveFoodTrucks : NSObject

//sortType should be "name" or "owner" or "id" or "distance"
-(id)initWithURL:(NSString*)url sortedBy:(NSString*)sortType {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://popping-fire-4216.firebaseio.com/"];
    [ref authAnonymouslyWithCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            NSLog(@"error connecting");
        } else {
            NSLog(@"fetching data");
            
            [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    FDataSnapshot *myData = snapshot.children.allObjects[0];
                    
                    for (FDataSnapshot* child in myData.children) {
                        if ([child hasChildren]) {
                            FoodTruckData *truck = [[FoodTruckData alloc] initWithSnapshot:child];
                            NSString *key = [[NSString alloc] init];
                            if ([sortType isEqualToString:@"name"]) {
                                key = truck.name;
                            } else if ([sortType isEqualToString:@"owner"]) {
                                key = truck.owner;
                            } else if ([sortType isEqualToString:@"id"]) {
                                key = truck.identifier;
                            } else if ([sortType isEqualToString:@"distance"]) {
                                key =[[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%f", truck.coords.latitude],
                                                                      @",",
                                                                      [NSString stringWithFormat:@"%f", truck.coords.longitude]];
                            }
                            [self.myData setObject:truck forKey:truck.name];
                        }
                    }
                    
                });
            } withCancelBlock:^(NSError *error) {
                NSLog(@"%@", error.description);
            }];
            
        }
    }];
    return self;
}

-(NSMutableDictionary*)getAllFoodTrucksAsDictionary {
    return self.myData;
}

-(NSMutableArray*)getAllFoodTrucksAsArray {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *key in [self.myData allKeys]) {
        [arr addObject:key];
    }
    return arr;
}

-(FoodTruckData*)getFoodTruckWithName:(NSString*)name {
    return [self.myData objectForKey:name];
}
@end
