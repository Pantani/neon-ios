//
//  DatabaseHandler.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "DatabaseHandler.h"
#import "Constants.h"

@implementation DatabaseHandler

static DatabaseHandler *_shared = nil;

+ (DatabaseHandler *)shared
{
	@synchronized([DatabaseHandler class])
    {
		if (!_shared)
        {
			_shared = [[self alloc] init];
		}
	}
    
	return _shared;
}

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        [self copyDBToDocuments];
    }
    
    return self;
}


-(sqlite3_stmt*) runSQL:(NSString*) isql{
    
	// alloc
	sqlite3_stmt *stmt;
	char *errmsg;
	const char *sql = [isql cStringUsingEncoding:NSUTF8StringEncoding];
	
	// prepare
    int sqlPrepare = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
	if (sqlPrepare != SQLITE_OK) {
		NSLog(@"SQL Warning: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		return nil;
	}
    
	// execute
	if(sqlite3_exec(database, sql, nil, &stmt, &errmsg) == SQLITE_OK){
		return stmt;
	}else {
		NSLog(@"SQL Warning: '%s'.", sqlite3_errmsg(database));
		return nil;
	}
    
    //    sqlite3_finalize(stmt);
    
}

-(NSString*) path
{
	return [NSHomeDirectory() stringByAppendingString:kCacheSQLPath];
}

- (void) runScript:(NSString*)path{
	NSError *err;
	NSString *script_path = [self resourcesFilePath:path] ;
	NSString *script = [[NSString alloc] initWithContentsOfFile:script_path encoding:NSUTF8StringEncoding error:&err];
	if(script != nil) [self runSQL:script];
	else NSLog(@"erro: %@", [err description]);
	
}

-(NSString*) resourcesFilePath:(NSString*) filename{
	return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
}

- (BOOL) open{
	const char *path = [[self path] cStringUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"Path Banco:%s",path);
    
    if ((sqlite3_open(path, &database) == SQLITE_OK)) {
        sqlite3_exec(database, "PRAGMA synchronous=OFF", NULL, NULL, NULL);
        sqlite3_exec(database, "PRAGMA synchronous=OFF", NULL, NULL, NULL);
        sqlite3_exec(database, "PRAGMA count_changes=OFF", NULL, NULL, NULL);
        sqlite3_exec(database, "PRAGMA journal_mode=MEMORY", NULL, NULL, NULL);
        sqlite3_exec(database, "PRAGMA temp_store=MEMORY", NULL, NULL, NULL);
        return YES;
    }else{
        return NO;
    }
    //	return (sqlite3_open(path, &database) == SQLITE_OK) ? YES	: NO ;
}

- (int)returnLastInsertRowId
{
    return (int) sqlite3_last_insert_rowid (database);
}

- (void)copyDBToDocuments
{
    NSString *pathDBBundle = [[NSBundle mainBundle] pathForResource:@"neondb" ofType:@"sqlite"];
    
    NSString *pathDBDocuments = [self path];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathDBDocuments])
    {
        [[NSFileManager defaultManager] copyItemAtPath:pathDBBundle toPath:pathDBDocuments error:nil];
        
    }
    [self open];
}

@end
