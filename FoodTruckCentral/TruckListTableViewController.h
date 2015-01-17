//
//  TruckListTableViewController.h
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/16/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TruckListTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *foodTruckArr;
@property (strong, nonatomic) CLLocation *userLocation;

@end
