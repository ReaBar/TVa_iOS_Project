//
//  LastUpdateSql.h
//  SqlDemo
//
//  Created by Admin on 12/30/15.
//  Copyright (c) 2015 menachi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LastUpdateSql : NSObject

+(BOOL)createTable:(sqlite3*)database;
+(NSString*)getLastUpdateDate:(sqlite3*)database forTable:(NSString*)table;
+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date forTable:(NSString*)table;

@end


