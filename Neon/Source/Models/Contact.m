//
//  Contact.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "Contact.h"
#import "Constants.h"

@implementation Contact

@synthesize name = _name;
@synthesize clientID = _clientID;
@synthesize tel = _tel;
@synthesize img_photo = _img_photo;

- (id)initWithClientID:(NSString*)clientID
                  name:(NSString*)name
                   tel:(NSString*)tel
             img_photo:(UIImage*)img_photo
{
    NSAssert(clientID != nil || clientID.length==0, @"Name is NULL");
    _clientID = clientID;
    
    NSAssert(name != nil || name.length==0, @"Name is NULL");
    _name = name;
    
    NSAssert(tel != nil  || tel.length==0, @"Tel is NULL");
    _tel = tel;
    
    NSAssert(img_photo != nil, @"Photo is NULL");
    _img_photo = img_photo;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Contact:\n name=\"%@\"\n clientID=\"%@\"\n tel=\"%@\"\n photo=\"%@\"\n",
            _name,
            _clientID,
            _tel,
            _img_photo];
}

@end
