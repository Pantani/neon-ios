//
//  Services.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Services : NSObject <NSURLConnectionDelegate>

#pragma mark - Feed

+(void)generateTokenWithName:(NSString*)name andEmail:(NSString*)email andBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+(void)sendMoneyToClient:(NSString*)clientID
                   value:(double)value
               withBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+(void)getTransfers:(void (^)(NSArray *result, NSError *error))completionBlock;

@end
