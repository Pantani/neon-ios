//
//  Util.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface Util : NSObject

#pragma mark - Validation
+(BOOL)verifyConnection;

#pragma mark - UI Methods
+(void) circleFilledWithOutline:(UIView*)circleView fillColor:(UIColor*)fillColor outlineColor:(UIColor*)outlinecolor;

@end
