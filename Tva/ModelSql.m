
#import "ModelSql.h"
#import "UserSettingsSql.h"
#import "UserFriendsSql.h"
#import "UserProgramsSql.h"
#import "LastUpdateSql.h"
#import "ProgramSql.h"
#import "AppDelegate.h"

@implementation ModelSql

-(id)init{
    self = [super init];
    if (self) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        NSArray* paths = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        
        NSURL* directoryUrl = [paths objectAtIndex:0];
        
        NSURL* fileUrl = [directoryUrl URLByAppendingPathComponent:@"database.db"];
        
        NSString* filePath = [fileUrl path];
        
        const char* cFilePath = [filePath UTF8String];
        
        int res = sqlite3_open(cFilePath,&database);
        
        if(res != SQLITE_OK){
            NSLog(@"ERROR: fail to open db");
            database = nil;
        }
        
        [UserProgramsSql createTable:database];
        [UserFriendsSql createTable:database];
        [UserSettingsSql createTable:database];
        [LastUpdateSql createTable:database];
        [ProgramSql createTable:database];

    }
    return self;
}

-(void)updatePrograms:(NSArray*)programs{
    [ProgramSql updatePrograms:database programs:programs];
}

-(NSArray*)getPrograms{
    return [ProgramSql getPrograms:database];
}
-(void)addFriend:(NSString*)_user friend:(NSString *)friendUserName{
    [UserFriendsSql addFriend:database user:_user friend:friendUserName image:friendUserName];
    [UserFriendsSql setLastUpdateDate:database date:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
}
-(NSArray*)getFriends:(NSString*)user{
    return [UserFriendsSql getFriends:database user:user];
    
}
-(void)updateUserFriends:(NSString*)user friends:(NSArray*)friends{
    [UserFriendsSql updateUserFriends:database user:user friends:friends];
    [UserFriendsSql setLastUpdateDate:database date:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
}
-(NSArray*)getFriendsPrograms:(NSString*)fr{
    return [UserProgramsSql getFriendsPrograms:database friend:fr];
    
}
-(NSArray*)getUserProgramsByHour:(NSString*)user begin:(NSString*)begin end:(NSString*)end{
    return [ProgramSql getUserProgramsByHour:database user:user begin:begin end:end];
}
-(void)addUserSettings:(NSString*)username withCableCompany:(NSString*)cableCompany withImageName:(NSString*)imageName{
    [UserSettingsSql addUserSettings:database withUserName:username withCableCompany:cableCompany withImageName:imageName];
    [UserSettingsSql setLastUpdateDate:database withUserName:username withDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
}
-(void)addProgramToUser:(NSString*)objectId withUsername:(NSString*)user program:(NSString*)program{
    [UserProgramsSql addProgramToUser:database withObjectId:objectId user:user program:program];
}
-(NSArray*)getUserPrograms:(NSString*)user{
    return [UserProgramsSql getUserPrograms:database user:user];
}
-(NSString*)getUserProgramsLastUpdateDate{
    return [UserProgramsSql getLastUpdateDate:database];
}
-(void)setUserProgramsLastUpdateDate:(NSString*)date{
    [UserProgramsSql setLastUpdateDate:database date:date];
}
-(void)updateUserPrograms:(NSString*)user programs:(NSArray*)programs{
    [UserProgramsSql updateUserPrograms:database user:user programs:programs];
}
-(void)addCable:(NSString*)user cable:(NSString*)cable{
    [UserSettingsSql addCable:database user:user cable:cable];
    [UserSettingsSql setLastUpdateDate:database withUserName:user withDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
}
-(void)setProgramsLastUpdateDate:(NSString*)date{
    [ProgramSql setLastUpdateDate:database date:date];
}

-(NSString*)getProgramsLastUpdateDate{
    return [ProgramSql getLastUpdateDate:database];
}

-(void)setUserFriendsLastUpdateDate:(NSString*)date{
    [UserFriendsSql setLastUpdateDate:database date:date];
}

-(void)saveUserImage:(UIImage*)image withUserName:(NSString*)username withImageName:(NSString*)imageName{    [UserSettingsSql saveUserImage:image withName:imageName];
    [UserSettingsSql addImage:database user:username withImageName:imageName];
    [UserSettingsSql setLastUpdateDate:database withUserName:username withDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
}

-(UIImage*)getUserImage:(NSString*)username{
    User* tempUser = [UserSettingsSql getUserSettings:database withUserName:username];
    return [UserSettingsSql getUserImage:tempUser.imageName];
}

-(NSString*)getUserFriendsLastUpdateDate{
    return [UserFriendsSql getLastUpdateDate:database];
}
-(User*)getUserSettings:(NSString*)username{
    return [UserSettingsSql getUserSettings:database withUserName:username];
}

-(void)addUserToSql:(NSString*)username{
    [UserSettingsSql addUserSettings:database withUserName:username withCableCompany:nil withImageName:nil];
}

-(NSString*)getUserLastUpdate:(NSString*)username{
    return [UserSettingsSql getLastUpdateDate:database withUserName:username];
}

@end
