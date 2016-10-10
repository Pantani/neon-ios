//
//  Contact.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Contact : NSObject

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) UIImage *img_photo;

- (id)initWithClientID:(NSString*)clientID
                  name:(NSString*)name
                   tel:(NSString*)tel
             img_photo:(UIImage*)img_photo;

@end
