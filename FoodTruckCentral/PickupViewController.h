//
//  PickupViewController.h
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/18/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextView *manifestView;

@property NSString *truckPhone;
@property NSArray *cartArr;
@property NSString *truckName;

@end
