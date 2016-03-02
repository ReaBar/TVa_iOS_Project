//
//  Model.m
//  Tva
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 Admin. All rights reserved.
//
////
#import "Model.h"
#import "ModelParse.h"

@interface Model(){
    NSMutableArray* programs;
}
@end

@implementation Model{
    ModelParse* parseModelImpl;
    ModelSql* sqlModelImpl;
    dispatch_queue_t myQueue;
}
static Model* instance=nil;
+(Model*) instance{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[Model alloc]init];
        }
    }
    return instance;
}

-(id) init{
    self=[super init];
    myQueue = dispatch_queue_create("myQueueName", NULL);
    if (self) {
         sqlModelImpl = [[ModelSql alloc] init];
         parseModelImpl=[[ModelParse alloc]init];
        _user= [[ModelParse alloc] getCurrentUser];
    }
    return self;
}

-(NSString*)getCurrentUser{
    return [parseModelImpl getCurrentUser];
}

//Block Asynch implementation
-(void)getFriendsAsynch:(void(^)(NSArray*))block{
    dispatch_async(myQueue, ^{
        //long operation
        NSMutableArray* data = (NSMutableArray*)[sqlModelImpl getFriends:[_user lowercaseString]];
        NSString* lastUpdate = [sqlModelImpl getUserFriendsLastUpdateDate];
        NSMutableArray* updatedData;
        if ((lastUpdate == nil && data.count==0) || (lastUpdate!=nil && data.count==0)){
            updatedData = (NSMutableArray*)[parseModelImpl getFriends];
        }else{
            updatedData = (NSMutableArray*)[sqlModelImpl getFriends:[_user lowercaseString]];
        }
        if (updatedData.count > 0) {
            [sqlModelImpl updateUserFriends:[_user lowercaseString] friends:updatedData];
            [sqlModelImpl setUserFriendsLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
            data = (NSMutableArray*)[sqlModelImpl getFriends:[_user lowercaseString]];
        } //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(data);
        });
    } );
}

-(void)getUserProgramsAsynch:(void(^)(NSArray*))block{
    dispatch_async(myQueue, ^{
        //long operation
        //NSArray* data = (NSMutableArray*)[sqlModelImpl getUserPrograms:[_user lowercaseString]];
        NSMutableArray* sortedData = [[NSMutableArray alloc]init];
        NSString* lastUpdate = [sqlModelImpl getUserProgramsLastUpdateDate];
        NSString* parseLastUpdate = [NSString stringWithFormat:@"%f",[parseModelImpl getTableLastUpdateTime:@"userPrograms"].timeIntervalSince1970];
        NSArray* updatedData = [sqlModelImpl getUserPrograms:_user];
        if (lastUpdate < parseLastUpdate || updatedData.count == 0) {
            updatedData = [parseModelImpl getUserPrograms];
            [sqlModelImpl updateUserPrograms:_user programs:updatedData];
            [sqlModelImpl setUserProgramsLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
        }
        /*else{
            updatedData = [sqlModelImpl getUserPrograms:[_user lowercaseString]];
        }*/
        
        for (Program* program in updatedData) {
            if([program.userName isEqualToString:_user]){
                [sortedData addObject:program];
            }
        }
        /*if (lastUpdate != nil){
            updatedData = (NSMutableArray*)[parseModelImpl getUserProgramsFromDate:lastUpdate];
        }else{
            updatedData = (NSMutableArray*)[parseModelImpl getUserPrograms];
        }
        if (updatedData.count > 0) {
            [sqlModelImpl updateUserPrograms:[_user lowercaseString] programs:updatedData];
            [sqlModelImpl setUserProgramsLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
            data = (NSMutableArray*)[sqlModelImpl getUserPrograms:[_user lowercaseString]];
        }*/
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(sortedData);
        });
    } );
}

-(void)getProgramsAsynch:(void(^)(NSArray*))block{
    dispatch_async(myQueue, ^{
        //long operation
        NSArray* data; //= [sqlModelImpl getPrograms];
        NSString* lastUpdate = [sqlModelImpl getProgramsLastUpdateDate];
        NSString* parseLastUpdate = [NSString stringWithFormat:@"%f",[parseModelImpl getTableLastUpdateTime:@"Programs"].timeIntervalSince1970];
        NSArray* parseUpdatedData;
        //lastUpdate = nil;
        //NSLog(@"SQL last update: %lld",lastUpdate.longLongValue);
        //NSLog(@"Parse last update: %lld",parseLastUpdate.longLongValue);
        if(lastUpdate.longLongValue < parseLastUpdate.longLongValue){
            parseUpdatedData = [parseModelImpl getProgramsFromDate:lastUpdate];
            [sqlModelImpl updatePrograms:parseUpdatedData];
            [sqlModelImpl setProgramsLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
            data = [sqlModelImpl getPrograms];
        }
        
        else if (lastUpdate.longLongValue >= parseLastUpdate.longLongValue){
            data = [sqlModelImpl getPrograms];
        }
        /*if (lastUpdate != nil){
            parseUpdatedData = (NSMutableArray*)[parseModelImpl getProgramsFromDate:lastUpdate];
        }else{
            parseUpdatedData = (NSMutableArray*)[parseModelImpl getPrograms];
        }
        if (parseUpdatedData.count > 0) {
            [sqlModelImpl updatePrograms:parseUpdatedData];
            [sqlModelImpl setProgramsLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
            data = (NSMutableArray*)[sqlModelImpl getPrograms];
        }*/
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(data);
        });
    } );
}

-(void)login:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block{
    dispatch_async(myQueue, ^{
        //long operation
        
        BOOL res = [parseModelImpl login:[user lowercaseString]  pwd:pwd];
        
        if (res) {
            self.user = [user lowercaseString];
        }
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    } );
}
//Block Asynch implementation
-(void)logout:(void (^)(BOOL))block{
    dispatch_async(myQueue, ^{
        //long operation
        BOOL res = [parseModelImpl logout];
        if (res) {
            self.user = nil;
        }

        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    } );
}

-(void)signup:(NSString*)user pwd:(NSString*)pwd block:(void(^)(BOOL))block{
    dispatch_async(myQueue, ^{
        //long operation
        BOOL res = [parseModelImpl signup:user pwd:pwd];
        
        if (res) {
            [self addUserToDB];
            self.user = user;
        }
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    } );
}

-(void)getUsersAsynch:(void(^)(NSArray*))blockListener{
    dispatch_async(myQueue, ^{
     
        NSArray* data=[parseModelImpl getUsers];
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            blockListener(data);
        });
    } );
}

-(void)deleteUserAsynch:(User*)userName block:(void(^)(NSError*))block{
    dispatch_async(myQueue, ^{
       [parseModelImpl deleteUser:userName];
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

-(void)addNewUserAsynch:(NSString*)userName withPassword:(NSString*)password block:(void(^)(NSError*))block{
    dispatch_async(myQueue, ^{
        [parseModelImpl addNewUser:userName withPassword:password];
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

-(void)getUserAsynch:(NSString*)userName block:(void(^)(User*))block{
    dispatch_async(myQueue, ^{
        //long operation
        User* us = [parseModelImpl getUser:userName];
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(us);
        });
    } );
}

-(void)addCableAsynch:(NSString*)cable block:(void(^)(NSError*))block{
    dispatch_async(myQueue, ^{
        [parseModelImpl addCable:cable];
        [sqlModelImpl addCable:_user cable:cable];
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

-(void)addFriendAsynch:(NSString*)friendUserName block:(void(^)(NSError*))block{
    dispatch_async(myQueue, ^{
        [parseModelImpl addFriend:friendUserName];
         BOOL check=[parseModelImpl checkUserFriend];
        if(check){
            [sqlModelImpl addFriend:[_user lowercaseString] friend:friendUserName];
        }
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

-(void)getUserDetailsAsynch:(NSString*)userName password:(NSString*)passWord block:(void(^)(User*))block{
    dispatch_async(myQueue, ^{
        //long operation
        User* us = [parseModelImpl getUserDetails:userName password:passWord];
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(us);
        });
    } );
}
-(void)addUserAsynch:(User*)userName block:(void(^)(NSError*))block{
    dispatch_async(myQueue, ^{
        [parseModelImpl addUser:userName];
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

-(NSArray*) getAllPrograms{
    return  programs;
}

-(void)getUserImage:(NSString*)username block:(void(^)(UIImage*))block{
    dispatch_async(myQueue, ^{
        //first try to get the image from local file
        //NSString* username = user.userName;
        UIImage* image = [sqlModelImpl getUserImage:username];
        //if failed to get image from file try to get it from parse
        if(image == nil){
            image = [parseModelImpl getImage:username];
            if(image != nil){
                [sqlModelImpl saveUserImage:image withUserName:username withImageName:username];
            }
        }
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(image);
        });
    } );
}

-(void)saveUserImage:(UIImage*)image block:(void(^)(NSError*))block{
    dispatch_async(myQueue, ^{
        //save the image to parse & sql
        NSString* username = [self getCurrentUser];
        [sqlModelImpl saveUserImage:image withUserName:username withImageName:username];
        [parseModelImpl saveImage:image withName:username];
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

-(void)getFriendProgramsAsynch:(NSString*)fr block:(void(^)(NSArray*))block {
    dispatch_async(myQueue, ^{
        NSArray* data = [sqlModelImpl getFriendsPrograms:[fr lowercaseString]];
        NSString* lastUpdate = [sqlModelImpl getUserProgramsLastUpdateDate];
        NSString* parseLastUpdate = [NSString stringWithFormat:@"%f",[parseModelImpl getTableLastUpdateTime:@"userPrograms"].timeIntervalSince1970];
        if(data.count == 0 || lastUpdate.longLongValue < parseLastUpdate.longLongValue){
            data=[parseModelImpl getFriendsPrograms:fr];
            if(data.count != 0){
                [sqlModelImpl updateUserPrograms:[fr lowercaseString] programs:data];
                [sqlModelImpl setUserProgramsLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
            }
        }
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(data);
        });
    } );
}

-(void)getUserProgramsByHourAsynch:(NSString*)begin end:(NSString*)end block:(void(^)(NSArray*))block{
    dispatch_async(myQueue, ^{
         NSArray* data=[sqlModelImpl getUserProgramsByHour:_user begin:begin end:end];
        if(data.count==0){
            data=[parseModelImpl getUserProgramsByHour:begin end:end];
        }
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(data);
        });
    } );
}

-(void)addProgramToUserAsynch:(Program*)program block:(void(^)(NSError*))block{
    dispatch_async(myQueue, ^{
        [parseModelImpl addProgramToUser:program.name];
        BOOL check=[parseModelImpl checkUserProgram];
        if(check==YES){
            [sqlModelImpl addProgramToUser:program.objectId withUsername:[_user lowercaseString] program:program.name];
            [sqlModelImpl setUserProgramsLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]]];
        }
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    } );
}

-(void)parseUserAsynch:(void(^)(User*))block{
    dispatch_async(myQueue, ^{
        User* user;
        NSString* username = [self getCurrentUser];
        NSString* lastUpdate = [sqlModelImpl getUserLastUpdate:username];
        NSString* parseLastUpdate = [NSString stringWithFormat:@"%f",[parseModelImpl getUserLastUpdate:username].timeIntervalSince1970];
        if(lastUpdate.longLongValue < parseLastUpdate.longLongValue){
            user = [parseModelImpl parseUser];
            [sqlModelImpl addUserSettings:[user.userName lowercaseString] withCableCompany:user.cable withImageName:user.imageName];
        }
        else{
            user = [sqlModelImpl getUserSettings:username];
        }
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(user);
        });
    } );
}

-(void)addUserToDB{
    [parseModelImpl addUserToDB];
    [sqlModelImpl addUserToSql:[[self getCurrentUser] lowercaseString]];
}

@end
