//
//  UserFriendsSql.h
//  Tva
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ModelParse.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "LastUpdateSql.h"
#import "UserFriendsSql.h"
#import "User.h"
#import "UserSettingsSql.h"
@interface UserFriendsSql : NSObject
+(BOOL)createTable:(sqlite3*)database;
+(NSString*)getLastUpdateDate:(sqlite3*)database;
+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date;
+(void)addFriend:(sqlite3*)database user:(NSString*)user friend:(NSString*)friendUserName image:(NSString*)image;
+(NSArray*)getFriends:(sqlite3*)database user:(NSString*)user;
+(void)updateUserFriends:(sqlite3*)database user:(NSString*)user friends:(NSArray*)friends;
@end
