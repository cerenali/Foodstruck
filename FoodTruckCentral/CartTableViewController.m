//
//  CartTableViewController.m
//  
//
//  Created by Joseph Cappadona on 1/17/15.
//
//

#import "CartTableViewController.h"
#import "CheckoutViewController.h"

@interface CartTableViewController ()

@end

@implementation CartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.cartArr)
        self.cartArr = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Checkout"
                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(segueToCheckout)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)segueToCheckout {
    [self performSegueWithIdentifier:@"toCheckout" sender:self];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) { // food section
        return [self.cartArr count] + 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        NSLog(@"error: cart tableview cell not configured");
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == [self.cartArr count]) { // last row: display total
            cell.textLabel.text = @"Total";
            float totalPrice = [self calculateTotalPrice];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", totalPrice];
            
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor darkGrayColor];
        } else {
            NSDictionary *foodDict = [self.cartArr objectAtIndex:indexPath.row];
            NSString *itemName = [[foodDict allKeys] objectAtIndex:0];
            cell.textLabel.text = itemName;
            float price = [[foodDict objectForKey:itemName] floatValue] / 100;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", price];
        }
    }
    
    return cell;
}

-(float)calculateTotalPrice {
    float total = 0;
    for (NSDictionary *foodDict in self.cartArr) {
        float price = [[foodDict objectForKey:[[foodDict allKeys] objectAtIndex:0]] floatValue] / 100;
        total += price;
    }
    return total;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == [self.cartArr count]) {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // can't delete last row
    if (indexPath.row == [self.cartArr count]) {
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.cartArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toCheckout"]) {
        CheckoutViewController *destination = [segue destinationViewController];
        destination.cartArr = self.cartArr;
        destination.truckCoords = self.truckCoords;
        destination.truckPhone = self.truckPhone;
        destination.truckName = self.truckName;
    }
}

@end
