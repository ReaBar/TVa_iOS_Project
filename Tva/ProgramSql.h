//
//  ProgramSql.h
//  Tva
///
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Program.h"
#import "User.h"
#import "UserSettingsSql.h"
#import <sqlite3.h>
@interface ProgramSql : NSObject
+(BOOL)createTable:(sqlite3*)database;
+(void)addProgram:(sqlite3*)database pr:(Program*)pr;
+(NSArray*)getPrograms:(sqlite3*)database;
+(NSString*)getLastUpdateDate:(sqlite3*)database;
+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date;
+(void)updatePrograms:(sqlite3*)database programs:(NSArray*)programs;
+(NSArray*)getUserProgramsByHour:(sqlite3*)database user:(NSString*)user begin:(NSString*)begin end:(NSString*)end;
@end
