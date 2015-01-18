//
//  CheckoutViewController.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "CheckoutViewController.h"
#import "PostmatesCheckoutViewController.h"

@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float totalPrice = [self calculateTotalPrice];
    NSString *priceString = [NSString stringWithFormat:@"$%.2f", totalPrice];
    self.priceLabel.text = priceString;
}

-(float)calculateTotalPrice {
    float total = 0;
    for (NSDictionary *foodDict in self.cartArr) {
        float price = [[foodDict objectForKey:[[foodDict allKeys] objectAtIndex:0]] floatValue] / 100;
        total += price;
    }
    return total;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toPostmatesCheckout"]) {
        PostmatesCheckoutViewController *destination = [segue destinationViewController];
        destination.cartArr = self.cartArr;
        destination.truckPhone = self.truckPhone;
    }
}

@end
