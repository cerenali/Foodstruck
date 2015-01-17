//
//  TruckAnnotationView.h
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/16/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface TruckAnnotationView : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)newCoords;
-(MKAnnotationView *)annotationView;

@end
