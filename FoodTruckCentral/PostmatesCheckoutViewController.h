//
//  PostmatesCheckoutViewController.h
//  FoodTruckCentral
//
//  Created by Joseph Cappadona on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PostmatesCheckoutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UILabel *deliveryChargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodChargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property CLLocationCoordinate2D truckCoords;
@property NSArray *cartArr;
@property NSString *truckPhone;
@property NSString *truckName;

@end
