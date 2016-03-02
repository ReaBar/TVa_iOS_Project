//
//  UserProgramsSql.h
//  Tva
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LastUpdateSql.h"
#import "UserSettingsSql.h"
#import <sqlite3.h>
#import "Program.h"
#import "User.h"
@interface UserProgramsSql : NSObject
+(BOOL)createTable:(sqlite3*)database;
+(NSArray*)getUserPrograms:(sqlite3*)database user:(NSString*)user;
+(NSString*)getLastUpdateDate:(sqlite3*)database;
+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date;
+(NSArray*)getFriendsPrograms:(sqlite3*)database friend:(NSString*)fr;
+(void)addProgramToUser:(sqlite3*)database withObjectId:(NSString*)objectId user:(NSString*)user program:(NSString*)program;
+(void)updateUserPrograms:(sqlite3*)database user:(NSString*)user programs:(NSArray*)programs;
@end
