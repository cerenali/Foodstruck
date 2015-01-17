//
//  CheckoutViewController.h
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *postmatesDeliveryButton;
@property (weak, nonatomic) IBOutlet UIButton *googleWalletButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property NSArray *cartArr;

@end
