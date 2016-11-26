//
//  Chart.h
//  Neon
//
//  Created by Danilo Pantani on 25/11/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface Chart : NSObject

@property (nonatomic, assign) double value;
@property (nonatomic, strong) Contact *contact;

- (id)initWithContact:(Contact*)contact
                value:(double)value;

@end
