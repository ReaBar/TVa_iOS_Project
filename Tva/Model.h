//
//  Model.h
//  Tva
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 Admin. All rights reserved.
//....

#import <Foundation/Foundation.h>
#import "Program.h"
#import "User.h"
#import <UIKit/UIKit.h>
#import "ModelSql.h"
/*@protocol ModelProtocol <NSObject>
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
@end
*/

@interface Model : NSObject
@property NSString* user;
+(Model*) instance;
-(NSString*)getCurrentUser;
-(void)getUsersAsynch:(void(^)(NSArray*))blockListener;
-(void)getUserAsynch:(NSString*)userName block:(void(^)(User*))block;
-(void)deleteUserAsynch:(User*)userName block:(void(^)(NSError*))block;
-(void)addNewUserAsynch:(NSString*)userName withPassword:(NSString*)password block:(void(^)(NSError*))block;
-(void)addCableAsynch:(NSString*)cable block:(void(^)(NSError*))block;
-(void)addFriendAsynch:(NSString*)friendUserName block:(void(^)(NSError*))block;
-(void)getUserDetailsAsynch:(NSString*)userName password:(NSString*)passWord block:(void(^)(User*))block;
-(void)addUserAsynch:(User*)userName block:(void(^)(NSError*))block;
-(NSArray*) getAllPrograms;
-(void)login:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block;
-(void)signup:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block;
-(void)logout:(void(^)(BOOL))block;
-(void)getFriendsAsynch:(void(^)(NSArray*))block;
-(void)saveUserImage:(UIImage*)image block:(void(^)(NSError*))block;
-(void)getUserImage:(NSString*)username block:(void(^)(UIImage*))block;
-(void)parseUserAsynch:(void(^)(User*))block;
-(void)addUserToDB;
-(void)getFriendProgramsAsynch:(NSString*)fr block:(void(^)(NSArray*))block ;
-(void)getUserProgramsAsynch:(void(^)(NSArray*))block;
-(void)getProgramsAsynch:(void(^)(NSArray*))block;
-(void)getUserProgramsByHourAsynch:(NSString*)begin end:(NSString*)end block:(void(^)(NSArray*))block;
-(void)addProgramToUserAsynch:(Program*)program block:(void(^)(NSError*))block;
@end
