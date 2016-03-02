//
//  Users.h
//  Tva
//
//  Created by Admin on 12/26/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSString* userName;
@property NSString* password;
@property NSString* imageName;
@property NSString* friends;
@property NSString* cable;
-(id)initWithUserName:(NSString*)username withCableCompany:(NSString*)cableCompany withImageName:(NSString*)imageName;
-(id)init:(NSString*)userName password:(NSString*)password;
-(id)initWithImage:(NSString*)userName image:(NSString*)image;
-(id)init:(NSString*)userName password:(NSString*)password cable:(NSString*)cable imagename:(NSString*)imagename;
-(id)init:(NSString*)userName;

@end
