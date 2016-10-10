//
//  CacheDB.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "CacheDB.h"

@implementation CacheDB

#pragma mark - Querys

+(NSArray*)listUsers
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Users"];
    
    sqlite3_stmt *resultado = [[DatabaseHandler shared] runSQL:sql];
    
    while (sqlite3_step(resultado) == SQLITE_ROW)
    {
        const char *cUserID = (const char*) sqlite3_column_text(resultado, 0);
        NSString *userID = [NSString stringWithCString:cUserID encoding:NSUTF8StringEncoding];
        
        const char *cName = (const char*) sqlite3_column_text(resultado, 1);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        const char *cTel = (const char*) sqlite3_column_text(resultado, 2);
        NSString *tel = [NSString stringWithCString:cTel encoding:NSUTF8StringEncoding];
        
        const char *cPhoto = (const char*) sqlite3_column_text(resultado, 3);
        NSString *photo = [NSString stringWithCString:cPhoto encoding:NSUTF8StringEncoding];
        
        Contact *contact = [[Contact alloc] initWithClientID:userID name:name tel:tel img_photo:[UIImage imageNamed:photo]];
        
        [result addObject:contact];
    }
    
    sqlite3_finalize(resultado);
    
    return result;
}

+(Contact*)getUser:(NSString*)userID
{
    Contact *result = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Users WHERE user_id = '%@'",userID];
    
    sqlite3_stmt *resultado = [[DatabaseHandler shared] runSQL:sql];
    
    if (sqlite3_step(resultado) == SQLITE_ROW)
    {
        const char *cUserID = (const char*) sqlite3_column_text(resultado, 0);
        NSString *userID = [NSString stringWithCString:cUserID encoding:NSUTF8StringEncoding];
        
        const char *cName = (const char*) sqlite3_column_text(resultado, 1);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        const char *cTel = (const char*) sqlite3_column_text(resultado, 2);
        NSString *tel = [NSString stringWithCString:cTel encoding:NSUTF8StringEncoding];
        
        const char *cPhoto = (const char*) sqlite3_column_text(resultado, 3);
        NSString *photo = [NSString stringWithCString:cPhoto encoding:NSUTF8StringEncoding];
        
        result = [[Contact alloc] initWithClientID:userID name:name tel:tel img_photo:[UIImage imageNamed:photo]];
    }
    
    sqlite3_finalize(resultado);
    
    return result;
}

#pragma mark - Inserts

+(BOOL)insertWithName:(NSString*)name tel:(NSString*)tel photo:(NSString*)photo
{
    BOOL success = NO;
    @try{
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO Users (name, tel, photo) VALUES ('%@', '%@', %@)",
                         [name stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
                         [tel stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
                         [photo stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
        
        sqlite3_stmt *selectstmt = [[DatabaseHandler shared] runSQL:sql];
        
        if (selectstmt != nil) {
            success = YES;
        } else {
            success = NO;
        }
        sqlite3_finalize(selectstmt);
        
    }
    @catch(NSException *e){
        success = NO;
    }
    return success;
}

#pragma mark - Delete

+(BOOL)cleanDatabase{
    
    NSArray *arrayTables = [NSArray arrayWithObjects:
                            @"Users", nil];
    
    for(NSString *tableName in arrayTables){
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        
        [[DatabaseHandler shared] runSQL:sql];
    }
    
    return YES;
}

@end
