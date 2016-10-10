//
//  Transaction.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "Transaction.h"
#import "Constants.h"
#import "CacheDB.h"

@implementation Transaction

@synthesize transactionID = _transactionID;
@synthesize clientId = _clientId;
@synthesize value = _value;
@synthesize token = _token;
@synthesize date = _date;
@synthesize contact = _contact;

- (id)initWithTransactionID:(NSString*)transactionID
             clientId:(NSString*)clientId
                value:(double)value
                token:(NSString*)token
                 date:(NSDate*)date
{
    NSAssert(transactionID != nil || transactionID.length==0, @"TransactionID is NULL");
    _transactionID = transactionID;
    
    NSAssert(clientId != nil || clientId.length==0, @"ClientId is NULL");
    _clientId = clientId;
    
    NSAssert(token != nil, @"Token is NULL");
    _token = token;
    
    NSAssert(value >= 0, @"Value is Invalid");
    _value = value;
    
    NSAssert(date != nil, @"Date is NULL");
    _date = date;
    
    _contact = [CacheDB getUser:clientId];
    
    return self;
}

- (NSString *)description
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormatter];
    
    return [NSString stringWithFormat:@"Transaction:\n transactionID=\"%@\"\n clientId=\"%@\"\n token=\"%@\"\n value=\"%f\"\n date=\"%@\"\n",
            _transactionID,
            _clientId,
            _token,
            _value,
            [formatter stringFromDate:_date]];
}

@end
