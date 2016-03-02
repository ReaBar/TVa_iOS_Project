//
//  UserSettingsSql.h
//  Tva
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"
#import "LastUpdateSql.h"
#import <UIKit/UIKit.h>

@interface UserSettingsSql : NSObject

+(BOOL)createTable:(sqlite3*)database;
+(NSString*)getLastUpdateDate:(sqlite3*)database withUserName:(NSString*)username;
+(void)setLastUpdateDate:(sqlite3*)database withUserName:(NSString*)username withDate:(NSString*)date;
+(void)addUserSettings:(sqlite3*)database withUserName:(NSString*)username withCableCompany:(NSString*)cableCompany withImageName:(NSString*)imageName;
+(User*)getUserSettings:(sqlite3*)database withUserName:(NSString*)username;
+(void)addCable:(sqlite3*)database user:(NSString*)user cable:(NSString*)cable;
+(UIImage*)getUserImage:(NSString*)imageName;
+(void)saveUserImage:(UIImage*)image withName:(NSString*)imageName;
+(void)addImage:(sqlite3*)database user:(NSString*)user withImageName:(NSString*)imageName;

@end
