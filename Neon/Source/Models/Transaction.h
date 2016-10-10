//
//  Transaction.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface Transaction : NSObject

@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, assign) double value;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) Contact *contact;

- (id)initWithTransactionID:(NSString*)transactionID
                   clientId:(NSString*)clientId
                      value:(double)value
                      token:(NSString*)token
                       date:(NSDate*)date;

@end
