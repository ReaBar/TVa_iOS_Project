//
//  WallTableViewController.m
//  Tva
//
//  Created by Admin on 12/31/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "WallTableViewController.h"
#import "FriendWallTableViewController.h"
@interface WallTableViewController ()

@end

@implementation WallTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
self.tableView.backgroundColor = [UIColor darkGrayColor];
     [[Model instance] getFriendsAsynch:^(NSArray* array){
         _tableData=array;
         [self.tableView reloadData];
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [[Model instance] getFriendsAsynch:^(NSArray* array){
        if(_tableData.count != array.count){
            _tableData = array;
            [self.tableView reloadData];
        };
    }];
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
    WallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WallTableViewCell" forIndexPath:indexPath];

    User* us= [_tableData objectAtIndex:indexPath.row];
    cell.name.text=us.userName;
    cell.accessoryType=UITableViewCellSelectionStyleBlue;
    cell.imageName=us.imageName;
    cell.image.image=nil;
    if(us.imageName != nil && ![us.imageName isEqualToString:@""]){
        [[Model instance] getUserImage:us.userName block:^(UIImage *image) {
            if ([cell.imageName isEqualToString:us.imageName]){
                if (image != nil) {
                    cell.image.image = image;
                   
                }else{
                    cell.image.image = [UIImage imageNamed:@"photo.png"];
                }
            }
        }];
    }else{
        cell.image.image = [UIImage imageNamed:@"photo.png"];
    }

    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FriendWallTableViewController* friendVC = [sb
                                    instantiateViewControllerWithIdentifier:@"friendViewController"];
    User* us= [_tableData objectAtIndex:indexPath.row];
    friendVC.friendTitle=us.userName;
    friendVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self showViewController:friendVC sender:self];
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
