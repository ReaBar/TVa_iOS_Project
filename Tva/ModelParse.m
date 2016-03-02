//
//  ModelParse.m
//  Tva
//
//  Created by Admin on 12/26/15.
//  Copyright © 2015 Admin. All rights reserved.
#import "ModelParse.h"

@implementation ModelParse
-(id)init{
    self = [super init];
    if (self) {
        [Parse setApplicationId:@"A8EaRabiTUhDiMnXJ6tC7H8QMgwViB0TEiXZtt72"
               clientKey:@"sGwydNIeXBRBfu1QLTzskKjxmxglW0GmNP1Sx9aQ"];
    }
    return self;
}


-(BOOL)login:(NSString*)user pwd:(NSString*)pwd{
    NSError* error;
    PFUser* puser = [PFUser logInWithUsername:[user lowercaseString] password:pwd error:&error];
    if (error == nil && puser != nil) {
        return YES;
    }
    return NO;
}
-(BOOL)signup:(NSString*)user pwd:(NSString*)pwd{
    NSError* error;
    PFUser* puser = [PFUser user];
    puser.username = [user lowercaseString];
    puser.password = pwd;
    return [puser signUp:&error];
}
-(NSString*)getCurrentUser{
    PFUser* user = [PFUser currentUser];
    if (user.username != nil) {
        return [user.username lowercaseString];
    }else{
        return nil;
    }
}
-(BOOL)logout{
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser!=nil) {
        return NO;
    }
    else
        return YES;
}
-(void)addNewUser:(NSString*)userName withPassword:(NSString*)password{
    PFUser* obj = [PFUser user];
    obj.password = password;
    obj.username = [userName lowercaseString];
    [obj signUp];
}
-(void)addUser:(User *)userName{
    PFUser* obj = [PFUser user];
    obj.password = userName.password;
    obj.username = [userName.userName lowercaseString];
    [obj signUp];
}
-(void)deleteUser:(User*)userName{
    PFQuery* query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:userName.userName];
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFUser* obj = [res objectAtIndex:0];
        [obj delete];
    }
}
//-----optional to delete----///
-(User*)getUser:(NSString *)userName{
    User* user = nil;
    PFQuery* query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:[userName lowercaseString]];
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFUser* obj = [res objectAtIndex:0];
        user = [[User alloc] init:obj.username password:obj.password];
    }
    return user;
}
-(NSArray*)getUsers{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    NSArray* res = [query findObjects];
    for (PFUser* obj in res) {
        User*  user = [[User alloc] init:obj.username password:obj.password];
        [array addObject:user];
    }
    return array;
}
-(User*)getUserDetails:(NSString*)userName password:(NSString*)passWord{
    User* user = nil;
    PFQuery* query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:[userName lowercaseString]];
    [query whereKey:@"password" equalTo:passWord];
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFUser* obj = [res objectAtIndex:0];
        user = [[User alloc] init:obj.username password:obj.password];
    }
    return user;
}
//-----------------------------//
-(void)addFriend:(NSString *)friendUserName{
    _checkValidUserFriend=NO;
    PFUser *currentUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
    [query whereKey:@"username" equalTo:[friendUserName lowercaseString]];
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFQuery* query2 = [PFQuery queryWithClassName:@"userFriends"];
        [query2 whereKey:@"username" equalTo:currentUser.username];
        [query2 whereKey:@"friend" equalTo:[friendUserName lowercaseString]];
        NSArray* res2 = [query2 findObjects];
        if(res2.count == 0){
            _checkValidUserFriend=YES;
            PFObject* obj = [PFObject objectWithClassName:@"userFriends"];
            obj[@"username"]=currentUser.username;
            obj[@"friend"]=[friendUserName lowercaseString];
            [obj save];
        }
    }
}
-(void)saveImage:(UIImage*)image withName:(NSString*)imageName{
    PFUser* user = [PFUser currentUser];
    NSData* imageData = UIImageJPEGRepresentation(image,0);
    PFFile* file = [PFFile fileWithName:imageName data:imageData];
    PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
    [query whereKey:@"username" equalTo:user.username];
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFObject *fileObj = [res objectAtIndex:0];
        fileObj[@"imageName"] = imageName;
        fileObj[@"file"] = file;
        [fileObj save];
    }
    else{
        PFObject* fileObj = [PFObject objectWithClassName:@"userSettings"];
        fileObj[@"username"] = user.username;
        fileObj[@"imageName"] = imageName;
        fileObj[@"file"] = file;
        [fileObj save];
    }
}
-(UIImage*)getImage:(NSString*)imageName{
    @synchronized(self) {
        //PFUser* user = [PFUser currentUser];
        PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
        [query whereKey:@"username" equalTo:imageName];
        PFObject* obj = [query getFirstObject];
        PFFile* file = obj[@"file"];
        NSData* data = [file getData];
        UIImage* image = [UIImage imageWithData:data];
        /*NSArray* res = [query findObjects];
         UIImage* image = nil;
         if (res.count == 1) {
         PFObject* imObj = [res objectAtIndex:0];
         PFFile* file = imObj[@"file"];
         NSData* data = [file getData];
         image = [UIImage imageWithData:data];
         }*/
        return image;
    }
}
-(void)addCable:(NSString*)cable{
    PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
    [query whereKey:@"username" equalTo:[self getCurrentUser]];
    NSArray* res = [query findObjects];
    if (res.count == 1) {
        PFObject* obj = [res objectAtIndex:0];
        obj[@"cable"]=cable;
        [obj save];
    }
}
-(NSArray*)getFriends{
    PFUser* user = [PFUser currentUser];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"userFriends"];
    [query whereKey:@"username" equalTo:[user.username lowercaseString]];
    PFQuery* query2=[PFQuery queryWithClassName:@"userSettings"];
    [query2 whereKey:@"username" matchesKey:@"friend" inQuery:query];
    NSArray* res=[query2 findObjects];
    for ( PFObject* obj in res) {
        User* us= [[User alloc] initWithImage:obj[@"username"] image:obj[@"imageName"]];
        [array addObject:us];
    }
    return array;
}
-(NSArray*)getFriendsPrograms:(NSString*)fr{
        NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
    [query whereKey:@"username" equalTo:[fr lowercaseString]];
    PFQuery* query2=[PFQuery queryWithClassName:@"userPrograms"];
    [query2 whereKey:@"username" matchesKey:@"username" inQuery:query];
    NSArray* res=[query2 findObjects];
    for ( PFObject* obj in res) {
        Program* pr= [[Program alloc] init:obj[@"username"] withObjectId:obj.objectId programeName:obj[@"program"]];
        [array addObject:pr];
    }
    return array;
}
-(NSArray*)getPrograms{
    
    PFUser* user= [PFUser currentUser];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
    [query whereKey:@"username" equalTo:[user.username lowercaseString]];
    PFQuery* query2=[PFQuery queryWithClassName:@"Programs"];
    [query2 whereKey:@"cable" matchesKey:@"cable" inQuery:query];
    [query2 whereKey:@"cable" equalTo:@"national"];
    NSArray* res=[query2 findObjects];
    for ( PFObject* obj in res) {
       Program* pr = [[Program alloc] init:obj[@"name"] withObjectId:obj.objectId channel:obj[@"channel"] cable:obj[@"cable"] begin:obj[@"begin"] end:obj[@"end"]];
        [array addObject:pr];
    }
    return array;
}
-(NSArray*)getUserProgramsByHour:(NSString*)begin end:(NSString*)end{
    PFUser* user=[PFUser currentUser];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
    [query whereKey:@"username" equalTo:[user.username lowercaseString]];
    PFQuery* query2=[PFQuery queryWithClassName:@"Programs"];
    [query2 whereKey:@"cable" matchesKey:@"cable" inQuery:query];
    [query2 whereKey:@"begin" equalTo:begin];
    [query2  whereKey:@"end" equalTo:end];
    NSArray* res=[query2 findObjects];
    for ( PFObject* obj in res) {
       Program* pr = [[Program alloc] init:obj[@"name"] withObjectId:obj.objectId channel:obj[@"channel"] cable:obj[@"cable"] begin:obj[@"begin"] end:obj[@"end"]];
        [array addObject:pr];
    }
    PFQuery* query3= [PFQuery queryWithClassName:@"Programs"];
    [query3 whereKey:@"cable" equalTo:@"national"];
    [query3 whereKey:@"begin" equalTo:begin];
    [query3  whereKey:@"end" equalTo:end];
    NSArray* res3=[query3 findObjects];
    for ( PFObject* obj in res3) {
       Program* pr = [[Program alloc] init:obj[@"name"] withObjectId:obj.objectId channel:obj[@"channel"] cable:obj[@"cable"] begin:obj[@"begin"] end:obj[@"end"]];
        [array addObject:pr];
    }
    return array;
}
-(void)addProgramToUser:(NSString*)program{
    _checkValidUserProgram=NO;
    PFUser* user=[PFUser currentUser];
    PFObject* obj = [PFObject objectWithClassName:@"userPrograms"];
    PFQuery* query=[PFQuery queryWithClassName:@"userPrograms"];
    [query whereKey:@"username" equalTo:user.username];
    [query whereKey:@"program" equalTo:program];
    NSArray *res = [query findObjects];
    if(res.count == 0){
    obj[@"username"]=user.username;
    obj[@"program"]=program;
    _checkValidUserProgram=YES;
        [obj save];
    }
    
}

-(NSArray*)getUserPrograms{
    PFUser* user=[PFUser currentUser];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"userPrograms"];
    [query whereKey:@"username" equalTo:[user.username lowercaseString]];
   
    NSArray* res=[query findObjects];
    for (PFObject* obj in res) {
        Program* pr= [[Program alloc] init:user.username withObjectId:obj.objectId programeName:obj[@"program"]];
        [array addObject:pr];
    }
    PFQuery* query2 = [PFQuery queryWithClassName:@"userFriends"];
    [query2 whereKey:@"username" matchesKey:@"username" inQuery:query];
    PFQuery* query3 = [PFQuery queryWithClassName:@"userPrograms"];
    [query3 whereKey:@"username" matchesKey:@"friend" inQuery:query2];
    NSArray* res2=[query3 findObjects];
    for ( PFObject* obj2 in res2) {
        Program* pr2= [[Program alloc] init:obj2[@"username"] withObjectId:obj2.objectId programeName:obj2[@"program"]];
        [array addObject:pr2];
    }
    return array;
}

-(User*)parseUser{
    PFUser* parseUser = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
    [query whereKey:@"username" equalTo:parseUser.username];
    User *user = [[User alloc]init];
    user.userName = parseUser.username;
    NSArray *res = [query findObjects];
    PFObject *pfObj = res[0];
    if (pfObj[@"cable"]!=nil) {
        user.cable = pfObj[@"cable"];
    }
    if(pfObj[@"imageName"]!=nil){
        user.imageName = pfObj[@"imageName"];
    }
    if(pfObj[@"pic"]!=nil){
        
    }
    if(pfObj[@"programs"]!=nil){
        
    }
    return user;
}
-(NSArray*)getProgramsFromDate:(NSString*)date{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"Programs"];
    NSDate* dated = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    [query whereKey:@"updatedAt" greaterThanOrEqualTo:dated];
    NSArray* res = [query findObjects];
    for (PFObject* obj in res) {
        Program* pr = [[Program alloc] init:obj[@"name"] withObjectId:obj.objectId channel:obj[@"channel"] cable:obj[@"cable"] begin:obj[@"begin"] end:obj[@"end"]];
        [array addObject:pr];
    }
    return array;
}

-(NSArray*)getFriendsFromDate:(NSString*)date{
    PFUser* user = [PFUser currentUser];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"userFriends"];
    [query whereKey:@"username" equalTo:[user.username lowercaseString]];
    PFQuery* query2=[PFQuery queryWithClassName:@"userSettings"];
    [query2 whereKey:@"username" matchesKey:@"friend" inQuery:query];
    NSDate* dated = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    [query2 whereKey:@"updatedAt" greaterThanOrEqualTo:dated];
    NSArray* res=[query2 findObjects];
    for ( PFObject* obj in res) {
        User* us= [[User alloc] initWithImage:obj[@"username"] image:obj[@"image"]];
        [array addObject:us];
    }
     return array;
}
-(NSArray*)getUserProgramsFromDate:(NSString*)date{
    PFUser* user=[PFUser currentUser];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PFQuery* query = [PFQuery queryWithClassName:@"userPrograms"];
    [query whereKey:@"username" equalTo:[user.username lowercaseString]];
    NSDate* dated = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    [query whereKey:@"updatedAt" greaterThanOrEqualTo:dated];
    NSArray* res=[query findObjects];
    for ( PFObject* obj in res) {
        Program* pr= [[Program alloc] init:obj[@"program"]];
        [array addObject:pr];
    }
    return array;
}

-(void)addUserToDB{
    PFUser* user = [PFUser currentUser];
    PFQuery* query = [PFQuery queryWithClassName:@"userSettings"];
    [query whereKey:@"username" equalTo:user.username];
    NSArray *res = [query findObjects];
    if(res.count == 0){
        PFObject* fileObj = [PFObject objectWithClassName:@"userSettings"];
        fileObj[@"username"] = user.username;
        [fileObj save];
    }
}

-(NSDate*)getTableLastUpdateTime:(NSString*)tableName{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"%@",tableName]];
    [query orderByDescending:@"updatedAt"];
    //NSArray* object = [query findObjects];
    //PFObject* obj = [object lastObject];
    PFObject* obj = [query getFirstObject];
    return obj.updatedAt;
}

-(NSDate*)getUserLastUpdate:(NSString*)username{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"userSettings"]];
    [query whereKey:@"username" equalTo:username];
    PFObject* obj = [query getFirstObject];
    return obj.updatedAt;
}
-(BOOL)checkUserProgram{
    return (_checkValidUserProgram);
}
-(BOOL)checkUserFriend{
    return (_checkValidUserFriend);
}
@end
