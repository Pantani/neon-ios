//
//  DatabaseHandler.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseHandler : NSObject{
	sqlite3 *database;
}

+ (DatabaseHandler *)shared;

- (sqlite3_stmt*) runSQL:(NSString*) isql;
- (BOOL) open;
- (void) runScript:(NSString*)path;
- (int)returnLastInsertRowId;
- (void)copyDBToDocuments;

@end
