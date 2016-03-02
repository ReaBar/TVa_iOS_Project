//
//  RegisterViewController.h
//  Tva
//
//  Created by Rea Bar on 28.12.2015.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
@interface RegisterViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *reapeatPasswordInput;
- (IBAction)backButton:(id)sender;
- (IBAction)signupButton:(id)sender;
@property (nonatomic) BOOL isValidPassWord;
@property (weak, nonatomic) IBOutlet UILabel *logo;
-(BOOL)validatePassword;
-(void)alert;
@end
