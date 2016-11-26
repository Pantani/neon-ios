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
+(void)drawBackgroundView:(UIView*)view;
+(void) circleFilledWithOutline:(UIView*)circleView fillColor:(UIColor*)fillColor outlineColor:(UIColor*)outlinecolor andLineWidth:(float)lineWidth;
+(void)circleGradientFilledWithOutline:(UIView*)circleView outlineColor:(UIColor*)outlinecolor gradientColor:(UIColor*)gradientColor;

#pragma mark - Mask Methods
+(BOOL)returnForShouldChangeCharactersInRange:(NSRange)range;
+(NSString*)currencyMaskWithText:(NSString*)text andRange:(NSRange)range;
+(NSString*)formatNumber:(double)value;

@end
