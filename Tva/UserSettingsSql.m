///
//  UserSettingsSql.m
//  Tva
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "UserSettingsSql.h"
#import "User.h"

@implementation UserSettingsSql
static NSString* USERSETTINGS_TABLE = @"USERSETTINGS";
static NSString* USERSETTINGS_USERNAME = @"USERNAME";
static NSString* USERSETTINGS_CABLE = @"CABLE";
static NSString* USERSETTINGS_IMAGE_NAME = @"IMAGE_NAME";
static NSString* USERSETTINGS_LAST_UPDATE = @"LAST_UPDATE";

+(BOOL)createTable:(sqlite3*)database{
    char* errormsg;
    
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT, %@ TEXT)",USERSETTINGS_TABLE,USERSETTINGS_USERNAME,USERSETTINGS_CABLE,USERSETTINGS_IMAGE_NAME,USERSETTINGS_LAST_UPDATE];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errormsg);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating USERSETTINGS table");
        return NO;
    }
    return YES;
}

+(NSString*)getLastUpdateDate:(sqlite3*)database withUserName:(NSString*)username{
    @synchronized(self) {
    sqlite3_stmt *statment;
    
    NSString* query = [NSString stringWithFormat:@"SELECT * from %@ where %@ = ?;",USERSETTINGS_TABLE,USERSETTINGS_USERNAME];
    
    if (sqlite3_prepare_v2(database,[query UTF8String], -1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [username UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_ROW){
            return [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,3)];
        }
        else{
           // NSLog(@"ERROR: getUserSettings failed %s",sqlite3_errmsg(database));
        }
    }
    return nil;
}
}

+(void)setLastUpdateDate:(sqlite3*)database withUserName:(NSString*)username withDate:(NSString*)date{
    @synchronized(self) {
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?;",USERSETTINGS_TABLE,USERSETTINGS_LAST_UPDATE,USERSETTINGS_USERNAME];
    
    if (sqlite3_prepare_v2(database,[query UTF8String], -1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [date UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [username UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
        NSLog(@"failed update last update date");
    }else{
        NSLog(@"ERROR: failed update last update date %s",sqlite3_errmsg(database));
    }
    }
}

+(void)addUserSettings:(sqlite3*)database withUserName:(NSString*)username withCableCompany:(NSString*)cableCompany withImageName:(NSString*)imageName{
    sqlite3_stmt *statment;
    @synchronized(self) {
    NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@,%@,%@) values (?,?,?);",USERSETTINGS_TABLE,USERSETTINGS_USERNAME,USERSETTINGS_CABLE,USERSETTINGS_IMAGE_NAME];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [[username lowercaseString] UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [cableCompany UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 3, [imageName UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    NSLog(@"ERROR: addUserSettings failed %s",sqlite3_errmsg(database));
    }
}

+(User*)getUserSettings:(sqlite3*)database withUserName:(NSString*)username{
    @synchronized(self) {

        sqlite3_stmt *statment;

        NSString* query = [NSString stringWithFormat:@"SELECT * from %@ where %@ = ?;",USERSETTINGS_TABLE,USERSETTINGS_USERNAME];
        if (sqlite3_prepare_v2(database,[query UTF8String], -1,&statment,nil) == SQLITE_OK){
                sqlite3_bind_text(statment, 1, [username UTF8String],-1,NULL);
            if(sqlite3_step(statment) == SQLITE_ROW){
                NSString* userName = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment,0)];
                NSString* cable = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 1)];
                NSString* image = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 2)];
                User* user = [[User alloc]initWithUserName:[userName lowercaseString] withCableCompany:cable withImageName:image];
                return user;
            }
        }
        else{
            NSLog(@"ERROR: getUserSettings failed %s",sqlite3_errmsg(database));
            return nil;
        }
        return nil;
    }
}
+(void)addCable:(sqlite3*)database user:(NSString*)user cable:(NSString*)cable{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?;",USERSETTINGS_TABLE,USERSETTINGS_CABLE,USERSETTINGS_USERNAME];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [cable UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [user UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    NSLog(@"ERROR: addCable failed %s",sqlite3_errmsg(database));
}

+(void)addImage:(sqlite3*)database user:(NSString*)user withImageName:(NSString*)imageName{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?;",USERSETTINGS_TABLE,USERSETTINGS_IMAGE_NAME,USERSETTINGS_USERNAME];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil) == SQLITE_OK){
        sqlite3_bind_text(statment, 1, [imageName UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [user UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    NSLog(@"ERROR: addImage failed %s",sqlite3_errmsg(database));
}

+(void)saveUserImage:(UIImage*)image withName:(NSString*)imageName{
    [self savingImageToFile:image fileName:imageName];
}

+(void)savingImageToFile:(UIImage*)image fileName:(NSString*)fileName{
    NSData *pngData = UIImagePNGRepresentation(image);
    [self saveToFile:pngData fileName:fileName];
}

+(UIImage*)readingImageFromFile:(NSString*)fileName{
    NSData* pngData = [self readFromFile:fileName];
    if (pngData == nil) return nil;
    return [UIImage imageWithData:pngData];
}

+(NSString*)getLocalFilePath:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+(void)saveToFile:(NSData*)data fileName:(NSString*)fileName{
    NSString* filePath = [self getLocalFilePath:fileName];
    [data writeToFile:filePath atomically:YES]; //Write the file
}

+(NSData*)readFromFile:(NSString*)fileName{
    NSString* filePath = [self getLocalFilePath:fileName];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    return pngData;
}

+(UIImage*)getUserImage:(NSString*)imageName{
    UIImage* image = [self readingImageFromFile:imageName];
    return image;
}

@end
