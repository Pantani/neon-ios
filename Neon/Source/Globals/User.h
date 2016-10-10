//
//  User.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *token;

+(User*)currentUser;

-(void)generateTokenWithName:(NSString*)name andEmail:(NSString*)email andBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)logout;

-(void)getStandardDefaults;
-(void)saveStandardDefaults;

@end
