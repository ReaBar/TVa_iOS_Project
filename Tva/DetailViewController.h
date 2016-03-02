//
//  DetailViewController.h
//  Tva
//
//  Created by Admin on 12/23/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Model.h"
@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photo;
@property (weak, nonatomic) IBOutlet UITextField *friendField;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *cableBtn;
@property (weak, nonatomic) IBOutlet UITableView *cableTableView;
@property (weak,nonatomic) NSString* userName;
@property(nonatomic) NSArray *cableData;
@property (weak,nonatomic) NSString* cableName;
- (IBAction)chooseCable:(id)sender;
- (IBAction)browseImage:(id)sender;
- (IBAction)save:(id)sender;
-(void) alert;
- (IBAction)logOut:(id)sender;
- (IBAction)toFavoritePrograms:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
