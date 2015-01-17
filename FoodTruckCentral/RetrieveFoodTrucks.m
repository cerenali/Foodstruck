//
//  RetriveFoodTrucks.m
//  FoodTruckCentral
//
//  Created by Joseph Cappadona on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "RetrieveFoodTrucks.h"

@implementation RetrieveFoodTrucks : NSObject

//sortType should be "name" or "owner" or "coords"
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

-(NSMutableDictionary*)getAllFoodTrucks {
    return self.myData;
}

-(FoodTruckData*)getFoodTruckWithName:(NSString*)name {
    return [self.myData objectForKey:name];
}
@end
