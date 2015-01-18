//
//  CartTableViewController.h
//  
//
//  Created by Joseph Cappadona on 1/17/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CartTableViewController : UITableViewController

@property NSMutableArray *cartArr;
@property CLLocationCoordinate2D truckCoords;
@property NSString *truckPhone;
@property NSString *truckName;

@end
