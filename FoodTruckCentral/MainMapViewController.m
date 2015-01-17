//
//  MainMapViewController.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/16/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "MainMapViewController.h"
#import "FoodTruckData.h"
#import "TruckAnnotationView.h"
#import "TruckListTableViewController.h"

@interface MainMapViewController ()

@end

@implementation MainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // first-time setup
    if (!self.currentLocation)
        self.currentLocation = [[CLLocation alloc] init];
    if (!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    if (!self.annotationView)
        self.annotationView = [[MKAnnotationView alloc] init];
    if (!self.foodTruckArr)
        self.foodTruckArr = [[NSMutableArray alloc] init];
    if (!self.annotationArr)
        self.annotationArr = [[NSMutableArray alloc] init];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) { // iOS 8+
        [[UIApplication sharedApplication] sendAction:@selector(requestWhenInUseAuthorization)
                                                   to:self.locationManager
                                                 from:self
                                             forEvent:nil];
    }
    
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    
    // note: best accuracy, but uses most CPU and battery
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    MKCoordinateSpan defaultSpan = MKCoordinateSpanMake(0.5, 1.0);
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMake(self.currentLocation.coordinate, defaultSpan);
    [self.mapView setRegion:defaultRegion];
    
    // hard-coded data for now
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(38, -122.4167);
    FoodTruckData *truck1 = [[FoodTruckData alloc] initWithName:@"Tang Chinese Food" withCoords:&coords1];
    [self.foodTruckArr addObject:truck1];
    // iterate through foodTruckArr and create map annotations for each food truck
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    for (FoodTruckData *truck in self.foodTruckArr) {
        NSLog(@"name: %@", truck.name);
        annotation.coordinate = truck.coords;
        annotation.title = truck.name;
        float dist = [truck getDistanceInMilesToLocation:self.locationManager.location];
        annotation.subtitle = [NSString stringWithFormat:@"%.2f mi",dist];
        [self.mapView addAnnotation:annotation];
        
//        TruckAnnotationView *truckAnnotation = [[TruckAnnotationView alloc] initWithTitle:truck.name location:truck.coords];
//        [self.mapView addAnnotation:truckAnnotation];
    }
}

- (IBAction)centerButtonClicked:(id)sender {
    CLLocationCoordinate2D current = self.locationManager.location.coordinate;
    [self.mapView setCenterCoordinate:current];
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    
//    if ([annotation isKindOfClass:[TruckAnnotationView class]]) {
//        TruckAnnotationView *myLocation = (TruckAnnotationView *)annotation;
//        
//        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"TruckAnnotation"];
//        
//        if (annotationView == nil)
//            annotationView.annotation = myLocation.annotationView;
//        else
//            annotationView.annotation = annotation;
//        
//        return annotationView;
//    } else
//        return nil;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D location = self.mapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000.0, 1000.0);
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toListView"]) {
        TruckListTableViewController *destination = [segue destinationViewController];
        if (!destination.foodTruckArr)
            destination.foodTruckArr = [[NSMutableArray alloc] init];
        destination.foodTruckArr = self.foodTruckArr;
        destination.userLocation = self.locationManager.location;
    }
}

- (IBAction)unwindToSegue:(UIStoryboardSegue *)segue
{
    //
}

@end
