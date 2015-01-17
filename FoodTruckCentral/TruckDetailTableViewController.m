//
//  TruckDetailTableViewController.m
//  FoodTruckCentral
//
//  Created by Alice Ren on 1/17/15.
//  Copyright (c) 2015 JAAA. All rights reserved.
//

#import "TruckDetailTableViewController.h"

@interface TruckDetailTableViewController ()

@end

@implementation TruckDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    self.navigationItem.rightBarButtonItem = cartButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1 + [self.truck.menu count];
//    return 2; // hardcode for now
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) { // info section
        return 2;
    }
    
    int numMenuSections = (int)[self.truck.menu count];
    NSArray *menuKeys = [self.truck.menu allKeys];
    for (int i = 0; i < numMenuSections; i++) {
        if (section == i+1) {
            NSInteger ret = [[self.truck.menu objectForKey:[menuKeys objectAtIndex:i]] count];
            return ret;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TruckDetailCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        NSLog(@">>configure cell TruckDetailView");
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = self.truck.name;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%.2f, %.2f",self.truck.coords.latitude, self.truck.coords.longitude];
        }
    } else {
        NSArray *menuKeys = [self.truck.menu allKeys];
        
        NSArray *foodDictArr = [self.truck.menu objectForKey:[menuKeys objectAtIndex:indexPath.section-1]];
        NSDictionary *foodDict = [foodDictArr objectAtIndex:indexPath.row];
        cell.textLabel.text = [[foodDict allKeys] objectAtIndex:0];
        cell.detailTextLabel.text = [[foodDict allValues] objectAtIndex:0];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Information";
    }
    
    int numMenuSections = (int)[self.truck.menu count];
    NSArray *menuKeys = [self.truck.menu allKeys];
    for (int i = 0; i < numMenuSections; i++) {
        if (section == i+1) {
            return [menuKeys objectAtIndex:i];
        }
    }
    
    return @"";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
