//
//  UserProgramsSql.m
//  Tva
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "UserProgramsSql.h"

@implementation UserProgramsSql
static NSString* USERPROGRAMS_TABLE = @"USERPROGRAMS";
static NSString* USERPROGRAMS_USERNAME = @"USERNAME";
static NSString* USERPROGRAMS_PROGRAM = @"PROGRAM";
static NSString* USERPROGRAMS_OBJECT_ID = @"OBJECTID";

+(BOOL)createTable:(sqlite3*)database{
    char* errormsg;
    
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT)",USERPROGRAMS_TABLE,USERPROGRAMS_OBJECT_ID,USERPROGRAMS_USERNAME,USERPROGRAMS_PROGRAM];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errormsg);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating UserPrograms table");
        return NO;
    }
    return YES;
}

+(NSString*)getLastUpdateDate:(sqlite3*)database{
    return [LastUpdateSql getLastUpdateDate:database forTable:USERPROGRAMS_TABLE];
}

+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date{
    [LastUpdateSql setLastUpdateDate:database date:date forTable:USERPROGRAMS_TABLE];
}
+(NSArray*)getUserPrograms:(sqlite3*)database{
    return nil;
}

+(NSArray*)getFriendsPrograms:(sqlite3*)database friend:(NSString*)fr{
    
    NSMutableArray* data = [[NSMutableArray alloc] init];
    sqlite3_stmt *statment;
     NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?;",USERPROGRAMS_TABLE,USERPROGRAMS_USERNAME];
    if (sqlite3_prepare_v2(database,[sql UTF8String], -1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [fr UTF8String],-1,NULL);
        
        while(sqlite3_step(statment) == SQLITE_ROW){
            NSString* programName = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,2)];
            Program* pr = [[Program alloc]init:programName];
            [data addObject:pr];
        }
    }else{
        NSLog(@"ERROR: getFriendsPrograms failed %s",sqlite3_errmsg(database));
        return nil;
    }
    return data;
}

+(void)addProgramToUser:(sqlite3*)database withObjectId:(NSString*)objectId user:(NSString*)user program:(NSString*)program{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@,%@,%@) values (?,?,?);",USERPROGRAMS_TABLE,USERPROGRAMS_OBJECT_ID,USERPROGRAMS_USERNAME,USERPROGRAMS_PROGRAM];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [objectId UTF8String],-1, NULL);
        sqlite3_bind_text(statment, 2, [user UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 3, [program UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    
    NSLog(@"ERROR: addProgramToUser failed %s",sqlite3_errmsg(database));
    
}
+(NSArray*)getUserPrograms:(sqlite3*)database user:(NSString*)user{
    NSMutableArray* data = [[NSMutableArray alloc] init];
    sqlite3_stmt *statment;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?;",USERPROGRAMS_TABLE,USERPROGRAMS_USERNAME];
    if (sqlite3_prepare_v2(database,[sql UTF8String], -1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [user UTF8String],-1,NULL);
        while(sqlite3_step(statment) == SQLITE_ROW){
            NSString* objectId = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 0)];
            NSString* programName = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,2)];
            Program* pr = [[Program alloc]init:user withObjectId:objectId programeName:programName];
            [data addObject:pr];
        }
    }else{
        NSLog(@"ERROR: getUserPrograms failed %s",sqlite3_errmsg(database));
        return nil;
    }
    return data;
}
+(void)updateUserPrograms:(sqlite3*)database user:(NSString*)user programs:(NSArray*)programs{
    for (Program* pr in programs) {
        [UserProgramsSql addProgramToUser:database withObjectId:pr.objectId user:pr.userName program:pr.name];
    }
}
@end
