//
//  User.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "User.h"
#import "Services.h"

@interface User ()

@end

@implementation User

@synthesize name = _name;
@synthesize email = _email;
@synthesize token = _token;

#pragma mark - LifeCycle

static User *_shared = nil;

+(User*)currentUser{
    @synchronized(self)
    {
        if (_shared == nil) {
            _shared = [[self alloc]init];
        }
        return _shared;
    }
}

-(id) init;
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

#pragma mark - Public Methods

-(void)generateTokenWithName:(NSString*)name andEmail:(NSString*)email andBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    [Services generateTokenWithName:name andEmail:email andBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error) {
            completionBlock(YES,error);
        }else{
            completionBlock(NO,error);
        }

    }];
}

#pragma mark - StandardDefaults Methods

-(void)saveStandardDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:_name forKey:kUserDefaults_Name];
    [standardUserDefaults setObject:_token forKey:kUserDefaults_Token];
    [standardUserDefaults setObject:_email forKey:kUserDefaults_Email];
    [standardUserDefaults synchronize];
}

-(void)getStandardDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    _token = [standardUserDefaults objectForKey:kUserDefaults_Token];
    _name = [standardUserDefaults objectForKey:kUserDefaults_Name];
    _email = [standardUserDefaults objectForKey:kUserDefaults_Email];
}

#pragma mark - Logout Methods

-(void)logout{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefaults objectForKey:kUserDefaults_Token])
        [standardUserDefaults removeObjectForKey:kUserDefaults_Token];
    if ([standardUserDefaults objectForKey:kUserDefaults_Name])
        [standardUserDefaults removeObjectForKey:kUserDefaults_Name];
    if ([standardUserDefaults objectForKey:kUserDefaults_Email])
        [standardUserDefaults removeObjectForKey:kUserDefaults_Email];
    
    [standardUserDefaults synchronize];
    
    _token = nil;
    _email = nil;
    _name = nil;
    
    [self deleteAllImages];
}

-(void)deleteAllImages
{
    NSString *folderPath = [NSHomeDirectory() stringByAppendingString:kCacheImagePath];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *directoryContent = [fileManager contentsOfDirectoryAtPath:folderPath error:NULL];
    
    NSError* error;
    NSString* fullFilePath = nil;
    
    for(NSString* fileName in directoryContent)
    {
        fullFilePath = [folderPath stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:fullFilePath error:&error];
        
        if(error)
        {
            NSLog(@"Error: %@",error);
        }
    }
}

@end
