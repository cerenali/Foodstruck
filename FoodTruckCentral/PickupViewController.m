//
//  PickupViewController.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/18/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "PickupViewController.h"
#import "MainMapViewController.h"

@interface PickupViewController ()

@end

@implementation PickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.date.autocorrectionType = UITextAutocorrectionTypeNo;
    self.date.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.date.textAlignment = NSTextAlignmentLeft;
    self.date.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.date.clearsOnBeginEditing = YES;
    self.date.placeholder = @"1/17/15";
    [self.date setEnabled:YES];
    
    self.time.autocorrectionType = UITextAutocorrectionTypeNo;
    self.time.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.time.textAlignment = NSTextAlignmentLeft;
    self.time.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.time.clearsOnBeginEditing = YES;
    self.time.placeholder = @"7:30 AM";
    [self.time setEnabled:YES];
    
    /* copy in manifest and pricing methods */
    NSString *manifest= [[NSString alloc] init];
    for(NSDictionary*dict in self.cartArr) {
        NSString *str = dict.allKeys[0];
        NSString *price = [NSString stringWithFormat:@"$%.2f",[[dict objectForKey:str] doubleValue] / 100];
        manifest = [manifest stringByAppendingString:[NSString stringWithFormat:@"%@ - %@\n",str,price]];
    }
    manifest = [manifest stringByAppendingString:[NSString stringWithFormat:@"\nTotal: $%.2f",[self calculateTotalPrice]]];
    
    self.manifestView.text = manifest;
}

-(float)calculateTotalPrice {
    float total = 0;
    for (NSDictionary *foodDict in self.cartArr) {
        float price = [[foodDict objectForKey:[[foodDict allKeys] objectAtIndex:0]] floatValue] / 100;
        total += price;
    }
    return total;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    
    [self.manifestView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmOrderPickup:(id)sender {
    if ([self.date.text length] == 0) {
        //ALERT THAT "Please enter a date for pickup."
        [self showErrorAlertWithMessage:@"Please enter a date for pickup"];
    } else if ([self.time.text length] == 0) {
        //ALERT THAT "Please enter a time for pickup."
        [self showErrorAlertWithMessage:@"Please enter a time for pickup"];
    } else {
        if ([self sendTwilioMessage]) {
            //ALERT THAT "Pickup scheduled!" and return to map
            [self showSuccessAlertWithMessage:@"Pickup scheduled!"];
        }
    }
}

-(void) showSuccessAlertWithMessage:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Success"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
//                             [self.navigationController popToRootViewControllerAnimated:YES];
                             [self performSegueWithIdentifier:@"returnToMapVC" sender:self];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) showErrorAlertWithMessage:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)sendTwilioMessage {
    NSLog(@"Sending request.");
    
    // Common constants
    NSString *kTwilioSID = @"AC50aec497430c6d3ba36dc998e456aa7c";
    NSString *kTwilioSecret = @"6ea0990a8c22e0c1173015d4dcca81a7";
    NSString *kFromNumber = @"+15162521715";
    NSString *kToNumber = self.truckPhone;
    NSString *kMessage = [NSString stringWithFormat:@"Pickup Date: %@\nPickupTime: %@\n\nOrder:\n%@",self.date.text,self.time.text,self.manifestView.text];
    
    // Build request
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Set up the body
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kFromNumber, kToNumber, kMessage];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Handle the received data
    if (error) {
        NSLog(@"Error: %@", error);
        return NO;
    } else {
        NSString *receivedString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"Request sent. %@", receivedString);
        return YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
