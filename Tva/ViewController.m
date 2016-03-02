//
//  ViewController.m
//  Tva
//
//  Created by Admin on 12/8/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "ModelParse.h"
#import "User.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    /*FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.readPermissions =
    @[@"public_profile", @"email"];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];*/
    UIColor *color = [UIColor orangeColor];
    _logoOutlet.font = [UIFont fontWithName:@"FabfeltScript-Bold" size:50];
    _logoOutlet.text = @"TVa";
    [_logoOutlet setTextColor:color];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TVA.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



    //
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toTabBarSegue"]){
        DetailViewController* nextVc= segue.destinationViewController;
    
    }
}*/
- (IBAction)facebookButton:(id)sender {
}


- (IBAction)login:(id)sender{
    [[Model instance] login:_userNameText.text pwd:_passWordText.text block:^(BOOL res){
        if (res) {
             [self performSegueWithIdentifier:@"toTabBarSegue" sender:self];
        }
        
        else{
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login Error"
                                                                           message:@"Username/password is invalid"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameText resignFirstResponder];
    [self.passWordText resignFirstResponder];
}
@end
