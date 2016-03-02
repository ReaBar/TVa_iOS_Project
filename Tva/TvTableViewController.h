//
//  TvTableViewController.h
//  Tva
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Program.h"
#import "User.h"
@interface TvTableViewController : UITableViewController <UIActionSheetDelegate,UIAlertViewDelegate>
- (IBAction)editTime:(id)sender;

@property(nonatomic) NSArray *timeData;
@property NSArray* programsData;
@property NSString* editTime;
@property Program* favoriteProgram;
@property (nonatomic) NSString* timeSelected;
@property User* user;
@end
