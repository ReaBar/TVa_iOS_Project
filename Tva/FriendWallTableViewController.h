//
//  FriendWallTableViewController.h
//  Tva
//
//  Created by Admin on 1/2/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "Program.h"
#import "User.h"

@interface FriendWallTableViewController : UITableViewController
@property (nonatomic)   NSArray *tableData;
@property (nonatomic) NSString* friendTitle;
@end
