//
//  Services.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "Services.h"
#import "Util.h"
#import "Constants.h"
#import "User.h"
#import "Transaction.h"
#import "SVProgressHUD.h"

@implementation Services

#pragma mark - GenerateToken

+(void)generateTokenWithName:(NSString*)name andEmail:(NSString*)email andBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    if ([Util verifyConnection]){
        NSString *URLString = [NSString stringWithFormat:kServiceURL];
        URLString = [URLString stringByAppendingString:kService_GenerateToken];
        
        URLString = [URLString stringByAppendingFormat:@"?%@=%@",kPName,name];
        URLString = [URLString stringByAppendingFormat:@"&%@=%@",kPEmail,email];
        
        NSString* encodedUrl = [URLString stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:100.0];
        
        [request setHTTPMethod:@"GET"];
        
        __weak __typeof(&*name)weakName = name;
        __weak __typeof(&*email)weakEmail = email;
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (!error) {
                 NSString* token = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                 if (token) {
                     [User currentUser].name = weakName;
                     [User currentUser].email = weakEmail;
                     [User currentUser].token = [token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                     
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         completionBlock(YES,error);
                     }];
                 }else{
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         completionBlock(NO,error);
                     }];
                 }
             }else{
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     completionBlock(NO,error);
                 }];
             }
         }];
    }
}

#pragma mark - SendMoney

+(void)sendMoneyToClient:(NSString*)clientID
                   value:(double)value
               withBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    if ([Util verifyConnection]){
        NSString *URLString = [NSString stringWithFormat:kServiceURL];
        URLString = [URLString stringByAppendingString:kService_SendMoney];
        
        NSString *postString = [NSString stringWithFormat:@"%@=%@",kPClientID,clientID];
        postString = [postString stringByAppendingFormat:@"&%@=%@",kPToken,[User currentUser].token];
        postString = [postString stringByAppendingFormat:@"&%@=%f", kPValue,value];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:100.0];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (!error) {
                 NSString* result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                 if (result && [result isEqualToString:@"true"]) {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         completionBlock(result,error);
                     }];
                 }else{
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         completionBlock(nil,error);
                     }];
                 }
             }else{
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     completionBlock(nil,error);
                 }];
             }
         }];
    }
}

#pragma mark - GetTransfers

+(void)getTransfers:(void (^)(NSArray *result, NSError *error))completionBlock
{
    if ([Util verifyConnection]){
        NSString *URLString = [NSString stringWithFormat:kServiceURL];
        URLString = [URLString stringByAppendingString:kService_GetTransfers];
        URLString = [URLString stringByAppendingFormat:@"?%@=%@",kPToken,[User currentUser].token];
        
        NSString* encodedUrl = [URLString stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:100.0];
        
        [request setHTTPMethod:@"GET"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (!error) {
                 NSError *errorResult = nil;
                 NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorResult];
                 
                 if (!errorResult) {
                     
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     [formatter setDateFormat:kDateFormatter];
                     
                     NSMutableArray *transactions = [NSMutableArray array];
                     for (NSDictionary *dic in result) {
                         NSDate *date = [formatter dateFromString:dic[kResultDate]];
                         
                         Transaction *model = [[Transaction alloc] initWithTransactionID:dic[kResultID] clientId:dic[kResultClientID] value:[dic[kResultValue] doubleValue] token:dic[kResultToken] date:date];
                         [transactions addObject:model];
                     }
                     
                     NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
                     [transactions sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
                     
                     __typeof(transactions) __strong weakResult = transactions;
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         completionBlock(weakResult,error);
                     }];
                 }else{
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                         completionBlock(nil,error);
                     }];
                 }
             }else{
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     completionBlock(nil,error);
                 }];
             }
         }];
    }
}

@end
