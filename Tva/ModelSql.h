//
//  ModelSql.h
//  Tva
//
//  Created by Admin on 1/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"
#import "LastUpdateSql.h"
#import "ProgramSql.h"
#import "UserFriendsSql.h"
#import "UserSettingsSql.h"
#import "UserProgramsSql.h"
@interface ModelSql : NSObject{
    sqlite3* database;
}

-(void)updatePrograms:(NSArray*)programs;
-(void)addUserSettings:(NSString*)username withCableCompany:(NSString*)cableCompany withImageName:(NSString*)imageName;
-(User*)getUserSettings:(NSString*)username;
-(void)addCable:(NSString*)user cable:(NSString*)cable;
-(NSArray*)getPrograms;
-(void)addProgramToUser:(NSString*)objectId withUsername:(NSString*)user program:(NSString*)program;
-(NSArray*)getUserPrograms:(NSString*)user;
-(NSArray*)getUserProgramsByHour:(NSString*)user begin:(NSString*)begin end:(NSString*)end;
-(void)addFriend:(NSString*)_user friend:(NSString *)friendUserName;
-(NSArray*)getFriends:(NSString*)user;
-(NSArray*)getFriendsPrograms:(NSString*)fr;
-(void)setProgramsLastUpdateDate:(NSString*)date;
-(NSString*)getProgramsLastUpdateDate;
-(NSString*)getUserLastUpdate:(NSString*)username;
-(void)setUserFriendsLastUpdateDate:(NSString*)date;
-(NSString*)getUserFriendsLastUpdateDate;
-(void)updateUserFriends:(NSString*)user friends:(NSArray*)friends;
-(void)updateUserPrograms:(NSString*)user programs:(NSArray*)programs;
-(NSString*)getUserProgramsLastUpdateDate;
-(void)setUserProgramsLastUpdateDate:(NSString*)date;
-(UIImage*)getUserImage:(NSString*)username;
-(void)saveUserImage:(UIImage*)image withUserName:(NSString*)username withImageName:(NSString*)imageName;
-(void)addUserToSql:(NSString*)username;
@end
