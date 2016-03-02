//
//  ProgramSql.m
//  Tva
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ProgramSql.h"
#import "LastUpdateSql.h"
@implementation ProgramSql
static NSString* PROGRAMS_TABLE = @"PROGRAMS";
static NSString* PROGRAMS_OBJECT_ID = @"OBJECTID";
static NSString* PROGRAMS_NAME = @"NAME";
static NSString* PROGRAMS_CHANNEL = @"CHANNEL";
static NSString* PROGRAMS_CABLE = @"CABLE";
static NSString* PROGRAMS_BEGIN = @"BEGIN";
static NSString* PROGRAMS_END = @"END";

+(BOOL)createTable:(sqlite3*)database{
    char* errormsg;
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT)",PROGRAMS_TABLE,PROGRAMS_OBJECT_ID,PROGRAMS_NAME,PROGRAMS_CHANNEL,PROGRAMS_CABLE,PROGRAMS_BEGIN,PROGRAMS_END];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errormsg);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating PROGRAMS table");
        return NO;
    }
    return YES;
}
+(NSString*)getLastUpdateDate:(sqlite3*)database{
    return [LastUpdateSql getLastUpdateDate:database forTable:PROGRAMS_TABLE];
}
+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date{
    [LastUpdateSql setLastUpdateDate:database date:date forTable:PROGRAMS_TABLE];
}
+(NSArray*)getPrograms:(sqlite3*)database{
    NSMutableArray* data = [[NSMutableArray alloc] init];
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(database,"SELECT * from PROGRAMS ORDER BY BEGIN ASC;", -1,&statment,nil) == SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            NSString* objectId = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,0)];
            NSString* name = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,1)];
            NSString* channel = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,2)];
            NSString* cable = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,3)];
            NSString* begin = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,4)];
             NSString* end = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,5)];
            
            Program* pr = [[Program alloc]init:name withObjectId:objectId channel:channel cable:(NSString*)cable begin:begin end:end];
            [data addObject:pr];
        }
    }else{
        NSLog(@"ERROR: getPROGRAMS failed %s",sqlite3_errmsg(database));
        return nil;
    }
    
    return data;
}
+(void)addProgram:(sqlite3*)database pr:(Program*)pr{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@,%@,%@,%@,%@,%@) values (?,?,?,?,?,?);",PROGRAMS_TABLE,PROGRAMS_OBJECT_ID,PROGRAMS_NAME,PROGRAMS_CHANNEL,PROGRAMS_CABLE,PROGRAMS_BEGIN,PROGRAMS_END];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [pr.objectId UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [pr.name UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 3, [pr.channel UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 4, [pr.cable UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 5, [pr.begin UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 6, [pr.end UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    
    NSLog(@"ERROR: addProgram failed %s",sqlite3_errmsg(database));
    
}
+(void)updatePrograms:(sqlite3*)database programs:(NSArray*)programs{
    for (Program* pr in programs) {
        [ProgramSql addProgram:database pr:pr];
    }
}

+(NSArray*)getUserProgramsByHour:(sqlite3*)database user:(NSString*)user begin:(NSString*)begin end:(NSString*)end{
    User* us = [UserSettingsSql getUserSettings:database withUserName:user];
    NSMutableArray* data = [[NSMutableArray alloc] init];
    sqlite3_stmt *statment;
        NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (%@ = ? OR %@ = ?) AND (%@ = ? AND %@ = ?);",PROGRAMS_TABLE,PROGRAMS_CABLE,PROGRAMS_CABLE,PROGRAMS_BEGIN,PROGRAMS_END];
    if (sqlite3_prepare_v2(database,[query UTF8String], -1,&statment,nil) == SQLITE_OK){
         sqlite3_bind_text(statment, 1, [us.cable UTF8String],-1,NULL);
         sqlite3_bind_text(statment, 2, [@"national" UTF8String],-1,NULL);
         sqlite3_bind_text(statment, 3, [begin UTF8String],-1,NULL);
         sqlite3_bind_text(statment, 4, [end UTF8String],-1,NULL);
        while(sqlite3_step(statment) == SQLITE_ROW){
            NSString* objectId = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,0)];
            NSString* name = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,1)];
            NSString* channel = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,2)];
            NSString* cable = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,3)];
            NSString* begin = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,4)];
            NSString* end = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,5)];
            
            Program* pr = [[Program alloc]init:name withObjectId:objectId channel:channel cable:(NSString*)cable begin:begin end:end];
            [data addObject:pr];
        }
    }else{
        NSLog(@"ERROR: getUserProgramsByHour failed %s",sqlite3_errmsg(database));
        return nil;
    }
    
    return data;
}

@end
