//
//  Users.m
//  Tva
//
//  Created by Admin on 12/26/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "User.h"

@implementation User
-(id)initWithUserName:(NSString*)username withCableCompany:(NSString*)cableCompany withImageName:(NSString*)imageName{
    self=[super init];
    if(self){
        _userName=username;
        _cable=cableCompany;
        _imageName=imageName;
    }
    return self;
}

-(id)init:(NSString*)userName password:(NSString*)password{
    self=[super init];
    if(self){
        _userName=userName;
        _password=password;
    }
    return self;
}
-(id)initWithImage:(NSString*)userName image:(NSString*)image{
    self=[super init];
    if(self){
        _userName=userName;
        _imageName=image;
    }
    return self;
}
-(id)init:(NSString*)userName password:(NSString*)password cable:(NSString*)cable imagename:(NSString*)imagename{
    
    self=[super init];
    if(self){
        _userName=userName;
        _password=password;
        _cable=cable;
        _imageName=imagename;
    }
    return self;
}
-(id)init:(NSString*)userName{
    
    self=[super init];
    if(self){
        _userName=userName;

    }
    return self;

}

@end
