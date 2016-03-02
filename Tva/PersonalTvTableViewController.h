//
//  PersonalTvTableViewController.h
//  Tva
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "User.h"
#import "Program.h"
#import "PersonalTvTableViewCell.h"
@interface PersonalTvTableViewController : UITableViewController
- (IBAction)backButton:(id)sender;
@property (nonatomic) NSArray* programsData;
@property (nonatomic) User* user;



@end
