//
//  DetailViewController.m
//  Tva
//
//  Created by Admin on 12/23/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
@interface DetailViewController ()

@end

@implementation DetailViewController{
    Model *model;
    BOOL sessionAlive;
    User* user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [Model instance];
    if([model getCurrentUser] != nil){
        [self.activityIndicator startAnimating];
        sessionAlive = YES;
        [model parseUserAsynch:^(User *us) {
            if(us.cable != nil){
                [self.cableBtn setTitle:us.cable forState:UIControlStateNormal];
            }
        }];
        [model getUserImage:[model getCurrentUser] block:^(UIImage *image) {
            if(image!= nil){
                [_photo setImage:image forState:UIControlStateNormal];
                [self.activityIndicator stopAnimating];
                 self.activityIndicator.hidden = YES;
            }
        }];
        self.cableData= [[NSArray alloc] initWithObjects:@"YES",@"HOT", nil];
        self.cableTableView.delegate=self;
        self.cableTableView.dataSource=self;
        self.cableTableView.hidden=YES;
      
        //[self viewDidAppear:YES];
    }
    else{
        sessionAlive = NO;
        //[self viewDidAppear:NO];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    if(sessionAlive == NO && self.view.window){
        [self performSegueWithIdentifier:@"toLoginSegue" sender:self];
    }
    else{
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      return [self.cableData count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* simpleTableIdentifier=@"simpleTableItem";
    
    
    UITableViewCell *cell = [(UITableView*)tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell==NULL) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text=[self.cableData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell= [self.cableTableView cellForRowAtIndexPath:indexPath];
    [self.cableBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    self.cableTableView.hidden=YES;
    self.cableName=cell.textLabel.text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseCable:(id)sender {
    if (self.cableTableView.hidden==YES) {
        self.cableTableView.hidden=NO;
    }
    else
        self.cableTableView.hidden=YES;
}

- (IBAction)save:(id)sender {
    UIImage *tempImage = [UIImage imageNamed:@"photo.png"];
    NSData *checkedImage = UIImagePNGRepresentation(tempImage);
    NSData *image = UIImagePNGRepresentation(_photo.imageView.image);
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    if (![image isEqualToData:checkedImage]){
        [model saveUserImage:_photo.currentImage block:^(NSError *error) {
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];

        }];
    }
    if(_cableName != nil){
        [model addCableAsynch:_cableName block:^(NSError *error){}];
    }
    
    if(self.friendField.text != nil && ![self.friendField.text isEqual:@""]){
        [model addFriendAsynch:_friendField.text block:^(NSError* error){}];
    }
    self.friendField.text = nil;
}

-(void)alert{
UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error in save"
                                                               message:@"one of the parameters does not fit. please check again."
                                                        preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {}];

[alert addAction:defaultAction];
[self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)logOut:(id)sender {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            ViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            appDelegate.window.rootViewController = vc;
             //[self performSegueWithIdentifier:@"toLoginSegue" sender:self];
    [[Model instance] logout:^(BOOL res){
        if(res && self.view.window){
            NSLog(@"Logged out successfully");
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

-(IBAction)toFavoritePrograms:(id)sender {
    if(!self.view.window){
        [self performSegueWithIdentifier:@"toFavorChannelSegue" sender:self];
    }
}

- (IBAction)browseImage:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *newImage = image;
    [_photo setImage:newImage forState:UIControlStateNormal];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.friendField resignFirstResponder];
}
@end
