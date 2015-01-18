//
//  TrackingMapViewController.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "TrackingMapViewController.h"

@interface TrackingMapViewController ()

@end

@implementation TrackingMapViewController {
    NSMutableData *receivedData;
    dispatch_source_t _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderID = [self.dictionary objectForKey:@"id"];
    
    self.trackingMapView.delegate = self;
    MKCoordinateSpan defaultSpan = MKCoordinateSpanMake(0.2, 0.4);
    
    CLLocationCoordinate2D dropoffCoords = [self getCoordsWithKey:@"dropoff"];
    CLLocationCoordinate2D pickupCoords = [self getCoordsWithKey:@"pickup"];
    
    [self addAnnotationAtCoords:dropoffCoords withTitle:@"Dropoff Location" withSubtitle:nil];
    [self addAnnotationAtCoords:pickupCoords withTitle:@"Pickup Location" withSubtitle:nil]; // later: update subtitle to have ETA?
    
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMake(dropoffCoords, defaultSpan);
    [self.trackingMapView setRegion:defaultRegion];
    
    [self startCourierPollingTimer];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinLocation"];
    
    if ([annotation.title isEqualToString:@"Dropoff Location"]) {
        newAnnotation.pinColor = MKPinAnnotationColorPurple;
    } else if ([annotation.title isEqualToString:@"Pickup Location"]) {
        newAnnotation.pinColor = MKPinAnnotationColorGreen;
    }
    
    newAnnotation.canShowCallout = YES;
    
    return newAnnotation;
}

-(void)addAnnotationAtCoords:(CLLocationCoordinate2D)coords withTitle:(NSString *)title withSubtitle:(NSString *)subtitle {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coords;
    annotation.title = title;
    if (subtitle)
        annotation.subtitle = subtitle;
    [self.trackingMapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    NSLog(@"made connection");
    [receivedData setLength:0];
}

-(CLLocationCoordinate2D)getCoordsWithKey:(NSString *)key {
    NSDictionary *subDict = [self.dictionary objectForKey:key];
    NSDictionary *coordDict = [subDict objectForKey:@"location"];
    return CLLocationCoordinate2DMake([[coordDict objectForKey:@"lat"] floatValue], [[coordDict objectForKey:@"lng"] floatValue]);
}

-(CLLocationCoordinate2D)getCoordsFromDictionary:(NSDictionary *)dict withKey:(NSString *)key {
    NSDictionary *coordDict = [dict objectForKey:key];
    return CLLocationCoordinate2DMake([[coordDict objectForKey:@"lat"] floatValue], [[coordDict objectForKey:@"lng"] floatValue]);
}

- (NSString *) dateFromISO8601DateString:(NSString *) dateString {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate * date = [dateFormatter dateFromString:dateString];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *eta = date;
    dateFormatter.dateFormat = @"M/dd/yy 'at' hh:mm a";
    return [dateFormatter stringFromDate:eta];
}

-(void)queryDeliveryWithIdentifier:(NSString*)identifier {
    NSString *url = [NSString stringWithFormat:@"https://api.postmates.com/v1/customers/cus_KASCAdgaCzH92F/deliveries/%@", identifier];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"92811ee4-a36f-42a3-b8d6-541dfd4944be", @""];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    receivedData = [NSMutableData dataWithCapacity: 0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [theConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                          forMode:NSDefaultRunLoopMode];
    [theConnection start];
    if (!theConnection) {
        NSLog(@"Error connecting");
    }
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    //do nothing
}

dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

-(void) startCourierPollingTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    double secondsToFire = 10.00f;
    double secondsToFire = 1.00f;
    
    _timer = CreateDispatchTimer(secondsToFire, queue, ^{
        [self getCourierUpdates];
    });
}

- (void)cancelCourierPollingTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

-(void)getCourierUpdates {
    @autoreleasepool {
        [self queryDeliveryWithIdentifier:self.orderID];
        // self.dictionary should be updated; now update courier pin
        if ([[self.dictionary objectForKey:@"status"] isEqualToString:@"delivered"]) {
            [self cancelCourierPollingTimer];
            [self showAlertWithMessage:@"Your order was delivered!"];
        } else if (!([self.dictionary objectForKey:@"courier"] == [NSNull null])) {
            self.courierCoords = [self getCoordsWithKey:@"courier"];
            NSString *ETAstr = [@"ETA: " stringByAppendingString:[self dateFromISO8601DateString:[self.dictionary objectForKey:@"dropoff_eta"]]];
            [self addAnnotationAtCoords:self.courierCoords withTitle:@"Courier" withSubtitle:ETAstr];
        }
    }
}

-(void) showAlertWithMessage:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Arrived"
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
    
//    NSLog(@"tracking dictionary: %@", dictionary);
    self.dictionary = [dictionary mutableCopy];
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
