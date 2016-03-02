//
//  UserFriendsSql.m
//  Tva
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "UserFriendsSql.h"

@implementation UserFriendsSql
static NSString* USERFRIENDS_TABLE = @"USERFRIENDS";
static NSString* USERFRIENDS_USERNAME = @"USERNAME";
static NSString* USERFRIENDS_FRIEND = @"FRIEND";
static NSString* USERFRIENDS_IMAGE_NAME = @"IMAGE_NAME";

+(BOOL)createTable:(sqlite3*)database{
    char* errormsg;
    
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ , %@,%@, PRIMARY KEY(%@,%@))",USERFRIENDS_TABLE,USERFRIENDS_USERNAME,USERFRIENDS_FRIEND,USERFRIENDS_IMAGE_NAME,USERFRIENDS_USERNAME,USERFRIENDS_FRIEND];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errormsg);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating UserFriends table");
        return NO;
    }
    return YES;
}

+(NSString*)getLastUpdateDate:(sqlite3*)database{
    return [LastUpdateSql getLastUpdateDate:database forTable:USERFRIENDS_TABLE];
}

+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date{
    [LastUpdateSql setLastUpdateDate:database date:date forTable:USERFRIENDS_TABLE];
}

+(void)addFriend:(sqlite3*)database user:(NSString *)user friend:(NSString *)friendUserName image:(NSString*)image{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@,%@,%@) values (?,?,?);",USERFRIENDS_TABLE,USERFRIENDS_USERNAME,USERFRIENDS_FRIEND,USERFRIENDS_IMAGE_NAME];
   
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [[user lowercaseString] UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [[friendUserName lowercaseString] UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 3, [[image lowercaseString] UTF8String],-1,NULL);

        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    NSLog(@"ERROR: addFriend failed %s",sqlite3_errmsg(database));
}

+(NSArray*)getFriends:(sqlite3*)database user:user{
    NSMutableArray* data = [[NSMutableArray alloc] init];
    sqlite3_stmt *statment;
    
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?;",USERFRIENDS_TABLE, USERFRIENDS_USERNAME];
    if (sqlite3_prepare_v2(database,[query UTF8String], -1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [[user lowercaseString] UTF8String],-1,NULL);
        while(sqlite3_step(statment) == SQLITE_ROW){
            NSString* friend = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,1)];
            User* us = [[User alloc]initWithImage:[friend lowercaseString] image:[friend lowercaseString]];
            [data addObject:us];
        }
    }else{
        NSLog(@"ERROR: getFriends failed %s",sqlite3_errmsg(database));
        return nil;
    }
    
    return data;

}
+(void)updateUserFriends:(sqlite3*)database user:(NSString*)user friends:(NSArray*)friends{
    for (User* pr in friends) {
        [UserFriendsSql addFriend:database user:[user lowercaseString] friend:[pr.userName lowercaseString] image:[pr.imageName lowercaseString]];
    }
}


@end
