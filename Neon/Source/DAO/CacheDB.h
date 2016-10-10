//
//  CacheDB.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseHandler.h"
#import "User.h"
#import "Contact.h"

@interface CacheDB : NSObject

//Insert
+(BOOL)insertWithName:(NSString*)name tel:(NSString*)tel photo:(NSString*)photo;

//Select
+(NSArray*)listUsers;
+(Contact*)getUser:(NSString*)userID;

//Delete
+(BOOL)cleanDatabase;

@end
