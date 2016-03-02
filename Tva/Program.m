//
//  Program.m
//  Tva
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "Program.h"

@implementation Program
-(id)init:(NSString*)name begin:(NSString*)begin end:(NSString*)end{
    self=[super init];
    if(self){
        _name=name;
        _begin=begin;
        _end=end;
    }
    return self;
}
-(id)init:(NSString*)name{
    self=[super init];
    if(self){
        _name=name;
           }
    return self;
}
-(id)init:(NSString*)name withObjectId:(NSString*)objectId channel:(NSString*)channel cable:(NSString*)cable begin:(NSString*)begin end:(NSString*)end{
    self=[super init];
    if(self){
        _name=name;
        _objectId=objectId;
        _channel=channel;
        _cable=cable;
        _begin=begin;
        _end=end;
    }
    return self;
}
-(id)init:(NSString*)username withObjectId:(NSString*)objectId programeName:(NSString*)name{
    self=[super init];
    if(self){
        _userName=username;
        _name=name;
        _objectId = objectId;
    }
    return self;
}
@end
