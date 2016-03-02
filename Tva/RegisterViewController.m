//
//  RegisterViewController.m
//  Tva
//
//  Created by Rea Bar on 28.12.2015.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end
Model *model;
User *user;

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *color = [UIColor orangeColor];
    _logo.font = [UIFont fontWithName:@"FabfeltScript-Bold" size:5];
    _logo.text = @"TVa";
    [_logo setTextColor:color];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signupButton:(id)sender {
    _isValidPassWord= [self validatePassword];
    if (_isValidPassWord) {

        [[Model instance] signup:_userNameInput.text pwd:_passwordInput.text block:^(BOOL res){
            if (!res) {
                [self alert];
            }
            else{
                [self dismissViewControllerAnimated:YES completion:nil];
                [model addUserToDB];
            }
        }];
    }
    }

-(void)alert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Signup Error"
                                                                   message:@"Username/Password is invalid "
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(BOOL)validatePassword{
    if([_passwordInput.text isEqualToString:_reapeatPasswordInput.text]){
        return YES;
    }
    NSLog(@"Password doesn't match");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Password Error"
                                                                   message:@"Password doesn't match"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    return NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameText resignFirstResponder];
    [self.passWordText resignFirstResponder];
    [self.reapeatPasswordInput resignFirstResponder];
}

@end
