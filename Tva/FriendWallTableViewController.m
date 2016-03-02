//
//  FriendWallTableViewController.m
//  Tva
//
//  Created by Admin on 1/2/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "FriendWallTableViewController.h"
#import "FriendWallTableViewCell.h"
#import "User.h"
#import "Program.h"
@interface FriendWallTableViewController ()

@end

@implementation FriendWallTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationItem.leftBarButtonItem setTintColor:[UIColor darkGrayColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    [[Model instance] getFriendProgramsAsynch:_friendTitle block:^(NSArray* array){
        self.tableData=array;
       [self.tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendWallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendWallTableViewCell" forIndexPath:indexPath];
    Program* pr= [_tableData objectAtIndex:indexPath.row];
    cell.programName.text=pr.name;
    return cell;
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
