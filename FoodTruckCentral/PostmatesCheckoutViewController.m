//
//  PostmatesCheckoutViewController.m
//  FoodTruckCentral
//
//  Created by Joseph Cappadona on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "PostmatesCheckoutViewController.h"

@interface PostmatesCheckoutViewController ()

@end

@implementation PostmatesCheckoutViewController{
    NSMutableData *receivedData;
    NSMutableDictionary *dictionary;
    BOOL hasQuote;
    NSString *deliveryAddress;
    BOOL deliveryRequestSuccess;
}

- (IBAction)getQuote:(id)sender {
    NSString *dropoffAddress = self.addressTextField.text;
    deliveryAddress = self.addressTextField.text;
    NSString *pickupAddress = [NSString stringWithFormat:@"%f,%f", self.truckCoords.latitude, self.truckCoords.longitude];
    [self getQuoteFromAddress:pickupAddress To:dropoffAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    hasQuote = NO;
    deliveryRequestSuccess = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(NSString*)createPostStringFromDictionary:(NSMutableDictionary*)dict {
    NSMutableString *vars_str = [[NSMutableString alloc] init];
    if (dict != nil && dict.count > 0) {
        BOOL first = YES;
        for (NSString *key in dict) {
            if (!first) {
                [vars_str appendString:@"&"];
            }
            first = NO;
            
            [vars_str appendString:key];
            NSLog(@"%@",key);
            [vars_str appendString:@"="];
            [vars_str appendString:[dict valueForKey:key]];
        }
    }
    return vars_str;
}

-(void)getQuoteFromAddress:(NSString*)pickupAddress To:(NSString*)dropoffAddress {
    if(!([self.nameTextField.text length] == 0) && !([self.phoneTextField.text length] == 0) && !([self.addressTextField.text length] == 0)){
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        //Get Quote
        NSString *url = @"https://api.postmates.com/v1/customers/cus_KASCAdgaCzH92F/delivery_quotes";
        NSString *pickup_address = pickupAddress;
        NSString *dropoff_address = dropoffAddress;
        [data setObject:pickup_address forKey:@"pickup_address"];
        [data setObject:dropoff_address forKey:@"dropoff_address"];
        
        NSString *post = [self createPostStringFromDictionary:data];
        NSLog(@"%@", post);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"92811ee4-a36f-42a3-b8d6-541dfd4944be", @""];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        receivedData = [NSMutableData dataWithCapacity: 0];
        
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (!theConnection) {
            NSLog(@"Error connecting");
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"made connection");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    dictionary = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
    NSLog(@"%@", dictionary);
    NSLog(@"returned data");
    
    if ([[dictionary objectForKey:@"kind"] isEqualToString:@"delivery_quote"]) {
        
        
        NSString *priceString = [dictionary objectForKey:@"fee"];
        NSString *fee = [NSString stringWithFormat:@"$%.2f", [priceString doubleValue]];
        self.deliveryChargeLabel.text = [NSString stringWithFormat:@"Charge for Delivery: %@", fee];
        
        float subtotal = [self calculateSubtotalPrice];
        NSString *foodPrice = [NSString stringWithFormat:@"$%.2f", subtotal];
        self.foodChargeLabel.text = [NSString stringWithFormat:@"Charge for Food: %@", foodPrice];
        
        NSString *totalPrice = [NSString stringWithFormat:@"%f", subtotal + [priceString doubleValue]];
        self.totalLabel.text = [NSString stringWithFormat:@"Total: %@", totalPrice];
        
        hasQuote = YES;
    } else if ([[dictionary objectForKey:@"kind"] isEqualToString:@"delivery"]) {
        deliveryRequestSuccess = YES;
        
    } else if ([[dictionary objectForKey:@"kind"] isEqualToString:@"error"]) {
        if ([[dictionary objectForKey:@"code"] isEqualToString:@"invalid_params"]) {
            NSDictionary *params = [dictionary objectForKey:@"params"];
            NSString *wrongParam = params.allKeys[0];
            if([wrongParam isEqualToString:@"dropoff_phone_number"]) {
                /*
                 ALERT THAT "Phone numbers must be in the format XXX-XXX-XXXX."
                 */
            }
        } else if ([[dictionary objectForKey:@"code"] isEqualToString:@"address_undeliverable"]) {
            /*
             ALERT THAT "Please enter a valid address."
             */
        } else if ([[dictionary objectForKey:@"code"] isEqualToString:@"address_undeliverable"]) {
            /*
             ALERT THAT "Please enter a valid address."
             */
        } else if ([[dictionary objectForKey:@"code"] isEqualToString:@"unknown"]) {
            /*
             ALERT THAT "Unknown error. Please make sure all fields are valid."
             */
        }
    }
}

-(float)calculateSubtotalPrice{
    float total = 0;
    for (NSDictionary *foodDict in self.cartArr) {
        float price = [[foodDict objectForKey:[[foodDict allKeys] objectAtIndex:0]] floatValue] / 100;
        total += price;
    }
    return total;
}
- (IBAction)submitOrder:(id)sender {
    NSString *errorMessage = [[NSString alloc] init];
    
    if(!([self.nameTextField.text length] == 0) && !([self.phoneTextField.text length] == 0) && !([self.addressTextField.text length] == 0)){
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        //Create Delivery
        NSString *url = @"https://api.postmates.com/v1/customers/cus_KASCAdgaCzH92F/deliveries";
        
        NSString *manifest=@"";
        for(NSDictionary*dict in self.cartArr) {
            [manifest stringByAppendingString:dict.allKeys[0]];
            [manifest stringByAppendingString:@"\n"];
        }
        
        NSString *pickup_name=self.truckName;
        NSString *pickup_address=[NSString stringWithFormat:@"%f,%f",self.truckCoords.latitude,self.truckCoords.longitude];
        NSString *pickup_phone_number=self.truckPhone;
        NSString *dropoff_name=self.nameTextField.text;
        NSString *dropoff_address=deliveryAddress;
        NSString *dropoff_phone_number=self.phoneTextField.text;
        [data setObject:manifest forKey:@"manifest"];
        [data setObject:pickup_name forKey:@"pickup_name"];
        [data setObject:pickup_address forKey:@"pickup_address"];
        [data setObject:pickup_phone_number forKey:@"pickup_phone_number"];
        [data setObject:dropoff_name forKey:@"dropoff_name"];
        [data setObject:dropoff_address forKey:@"dropoff_address"];
        [data setObject:dropoff_phone_number forKey:@"dropoff_phone_number"];
        
        NSString *post = [self createPostStringFromDictionary:data];
        NSLog(@"%@", post);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"92811ee4-a36f-42a3-b8d6-541dfd4944be", @""];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        receivedData = [NSMutableData dataWithCapacity: 0];
        
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (!theConnection) {
            NSLog(@"Error connecting");
        }
    } else {
        /*
            ALERT THAT "All fields must be filled."
         */
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
