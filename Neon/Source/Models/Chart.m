//
//  Chart.m
//  Neon
//
//  Created by Danilo Pantani on 25/11/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "Chart.h"
#import "Constants.h"

@implementation Chart
@synthesize contact = _contact;
@synthesize value = _value;

- (id)initWithContact:(Contact*)contact
                value:(double)value
{
    NSAssert(contact != nil, @"contact is NULL");
    _contact = contact;
    
    NSAssert(value >= 0, @"Value is Invalid");
    _value = value;
    
    return self;
}

- (NSString *)description
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormatter];
    
    return [NSString stringWithFormat:@"Chart:\n contact=\"%@\"\n value=\"%f\"\n",
            _contact,
            _value];
}

@end
