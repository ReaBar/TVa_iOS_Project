//
//  ModelParse.h
//  Tva
//
//  Created by Admin on 12/26/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import <Parse/Parse.h>
#import "User.h"

@interface ModelParse : NSObject
-(BOOL)logout;
-(BOOL)login:(NSString*)user pwd:(NSString*)pwd;
-(BOOL)signup:(NSString*)user pwd:(NSString*)pwd;
-(NSString*)getCurrentUser;
-(void)addNewUser:(NSString*)userName withPassword:(NSString*)password;
-(void)addUser:(User*)userName;
-(void)deleteUser:(User*)userName;
-(User*)getUser:(NSString*)userName;
-(NSArray*)getUsers;
-(User*)getUserDetails:(NSString*)userName password:(NSString*)passWord;
-(void)addFriend:(NSString*)friendUserName;
-(void)addCable:(NSString*)cable;
-(void)saveImage:(UIImage*)image withName:(NSString*)imageName;
-(UIImage*)getImage:(NSString*)imageName;
-(NSArray*)getFriends;
-(User*)parseUser;
-(void)addUserToDB;
-(NSArray*)getFriendsPrograms:(NSString*)fr;
-(NSArray*)getUserPrograms;
-(NSArray*)getPrograms;
-(NSArray*)getUserProgramsByHour:(NSString*)begin end:(NSString*)end;
-(void)addProgramToUser:(NSString*)program;
-(NSArray*)getProgramsFromDate:(NSString*)date;
-(NSArray*)getFriendsFromDate:(NSString*)date;
-(NSArray*)getUserProgramsFromDate:(NSString*)date;
-(NSDate*)getTableLastUpdateTime:(NSString*)tableName;
-(NSDate*)getUserLastUpdate:(NSString*)username;
@property BOOL checkValidUserProgram;
-(BOOL)checkUserProgram;
-(BOOL)checkUserFriend;
@property BOOL checkValidUserFriend;
@end
