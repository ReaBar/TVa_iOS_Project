//
//  TvTableViewController.m
//  Tva
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "TvTableViewController.h"
#import "TvTableViewCell.h"
#import "Program.h"
#import "Model.h"

@interface TvTableViewController ()
@end

@implementation TvTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Model instance] getProgramsAsynch:^(NSArray * array) {
              self.programsData=array;
             [self.tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated{
    [[Model instance] getProgramsAsynch:^(NSArray* array){
        if(self.programsData.count != array.count){
            self.programsData = array;
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

    return _programsData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TvTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TvTableViewCell" forIndexPath:indexPath];
    Program* pr= [_programsData objectAtIndex:indexPath.row];
    cell.name.text=pr.name;
    cell.hour.text=[NSString stringWithFormat:@" %@-%@",
                    pr.begin,pr.end];
    NSString* imageProgram= [NSString stringWithFormat:@"%@.png",pr.channel];
    cell.imageView.image = [UIImage imageNamed:imageProgram];
    
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
 

}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:@"Do you want to set this program as a favorite?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [[Model instance] addProgramToUserAsynch:_favoriteProgram block:^(NSError* er){}];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    _favoriteProgram = [_programsData objectAtIndex:indexPath.row];
}

- (IBAction)editTime:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Please choose time you want to see the programs:" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"00:00-04:00" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* begin = @"00:00";
        NSString* end = @"04:00";
        [[Model instance] getUserProgramsByHourAsynch:begin end:end block:^(NSArray * array) {
            self.programsData=array;
            [self.tableView reloadData];
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"04:00-08:00" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* begin = @"04:00";
        NSString* end = @"08:00";
        [[Model instance] getUserProgramsByHourAsynch:begin end:end block:^(NSArray * array) {
            self.programsData=array;
            [self.tableView reloadData];
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"08:00-12:00" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* begin = @"08:00";
        NSString* end = @"12:00";
        [[Model instance] getUserProgramsByHourAsynch:begin end:end block:^(NSArray * array) {
            self.programsData=array;
            [self.tableView reloadData];
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"12:00-16:00" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* begin = @"12:00";
        NSString* end = @"16:00";
        [[Model instance] getUserProgramsByHourAsynch:begin end:end block:^(NSArray * array) {
            self.programsData=array;
            [self.tableView reloadData];
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"16:00-20:00" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* begin = @"16:00";
        NSString* end = @"20:00";
        [[Model instance] getUserProgramsByHourAsynch:begin end:end block:^(NSArray * array) {
            self.programsData=array;
            [self.tableView reloadData];
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"20:00-00:00" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* begin = @"20:00";
        NSString* end = @"00:00";
        [[Model instance] getUserProgramsByHourAsynch:begin end:end block:^(NSArray * array) {
            self.programsData=array;
            [self.tableView reloadData];
        }];
    }]];

    [self presentViewController:actionSheet animated:YES completion:nil];
}
@end
