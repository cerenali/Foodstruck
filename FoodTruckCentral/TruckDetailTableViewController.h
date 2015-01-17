//
//  TruckDetailTableViewController.h
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodTruckData.h"

@interface TruckDetailTableViewController : UITableViewController

@property FoodTruckData *truck;
@property NSMutableArray *cartArr;

@end
