//
//  Program.h
//  Tva
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 Admin. All rights reserved.
///

#import <Foundation/Foundation.h>

@interface Program : NSObject
@property NSString* objectId;
@property NSString* name;
@property NSString* channel;
@property NSString* cable;
@property NSString* end;
@property NSString* begin;
@property NSString* userName;
-(id)init:(NSString*)name begin:(NSString*)begin end:(NSString*)end;
-(id)init:(NSString*)name;
-(id)init:(NSString*)name withObjectId:(NSString*)objectId channel:(NSString*)channel cable:(NSString*)cable begin:(NSString*)begin end:(NSString*)end;
-(id)init:(NSString*)username withObjectId:(NSString*)objectId programeName:(NSString*)name;
@end
