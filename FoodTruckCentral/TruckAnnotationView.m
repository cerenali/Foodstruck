//
//  TruckAnnotationView.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/16/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "TruckAnnotationView.h"

@implementation TruckAnnotationView

-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)newCoords {
    self = [super init];
    
    if (self) {
        self.title = newTitle;
        self.coordinate = newCoords;
    }

    return self;
}

-(MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"TruckAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
