//
//  ViewController.h
//  Tva
//
//  Created by Admin on 12/8/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import <Parse/Parse.h>


@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
- (IBAction)facebookButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *logoOutlet;
@property (nonatomic, assign) id currentResponder;
- (IBAction)login:(id)sender;
//
@end

