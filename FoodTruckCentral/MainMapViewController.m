//
//  MainMapViewController.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/16/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "MainMapViewController.h"
#import "FoodTruckData.h"
#import "TruckListTableViewController.h"
#import "RetrieveFoodTrucks.h"
#import "TruckDetailTableViewController.h"

@interface MainMapViewController ()

@end

@implementation MainMapViewController

- (IBAction)returnToMapVC:(UIStoryboardSegue *)segue {
}

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
    
    NSString *firebaseURL = @"https://popping-fire-4216.firebaseio.com/";
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"%@", snapshot.value);
        if ([snapshot hasChildren]) {
            for (FDataSnapshot *childSnap in snapshot.children) {
//                NSLog(@"%@", childSnap.value);
                FoodTruckData *tr = [[FoodTruckData alloc] initWithSnapshot:childSnap];
                [self.foodTruckArr addObject:tr];
            }
            [self reloadAnnotations];
        }
    }];
    [self reloadAnnotations];
    
    CLLocationCoordinate2D current = self.locationManager.location.coordinate;
    [self.mapView setCenterCoordinate:current];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(current, 1000.0, 1000.0);
    [self.mapView setRegion:region animated:YES];
}

-(void) reloadAnnotations {
    // iterate through foodTruckArr and create map annotations for each food truck
    for (FoodTruckData *truck in self.foodTruckArr) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = truck.coords;
        annotation.title = truck.name;
        float dist = [truck getDistanceInMilesToLocation:self.locationManager.location];
        annotation.subtitle = [NSString stringWithFormat:@"%.2f mi",dist];
        [self.mapView addAnnotation:annotation];
        self.mapView.showsUserLocation = YES;
    }
}

- (IBAction)centerButtonClicked:(id)sender {
    CLLocationCoordinate2D current = self.locationManager.location.coordinate;
    [self.mapView setCenterCoordinate:current];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }

    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinLocation"];
    
    newAnnotation.canShowCallout = YES;
    newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; // UIButtonTypeDetailDisclosure
    
    return newAnnotation;
}

-(FoodTruckData *) getTruckByName:(NSString *)name {
    for (FoodTruckData *tr in self.foodTruckArr) {
        if ([tr.name isEqualToString:name]) {
            return tr;
        }
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self performSegueWithIdentifier:@"toTruckDetailViewFromMap" sender:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D location = self.mapView.userLocation.location.coordinate;
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000.0, 1000.0);
    
    //[self.mapView setRegion:region animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toListView"]) {
        UINavigationController *navController = [segue destinationViewController];
        TruckListTableViewController *destination = (TruckListTableViewController *)([navController viewControllers][0]);
        if (!destination.foodTruckArr)
            destination.foodTruckArr = [[NSMutableArray alloc] init];
        destination.foodTruckArr = self.foodTruckArr;
        destination.userLocation = self.locationManager.location;
    } else if ([[segue identifier] isEqualToString:@"toTruckDetailViewFromMap"]) {
        UINavigationController *navController = [segue destinationViewController];
        TruckDetailTableViewController *destination = (TruckDetailTableViewController *)([navController viewControllers][0]);
        
        MKAnnotationView *annotationView = sender;
        NSString *trName = annotationView.annotation.title;
        destination.truck = [self getTruckByName:trName];
    }
}

- (IBAction)unwindToSegue:(UIStoryboardSegue *)segue
{
    //
}

@end
