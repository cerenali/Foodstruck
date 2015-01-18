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
}

- (IBAction)getQuote:(id)sender {
    NSString *dropoffAddress = self.addressField.text;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(NSString*)getQuoteFromAddress:(NSString*)pickupAddress To:(NSString*)dropoffAddress {
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
    return nil;
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
    
    NSString *priceString = [dictionary objectForKey:@"fee"];
    NSString *price = [NSString stringWithFormat:@"$%.2f", [priceString doubleValue]];
    self.deliveryChargeLabel.text = [NSString stringWithFormat:@"Charge for Delivery: %@", price];
    
    //need to update total
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
