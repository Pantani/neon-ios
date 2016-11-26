//
//  Util.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "Util.h"
#import "Reachability.h"
#import "UIColor+Additions.h"

@implementation Util

#pragma mark - Validation

+(BOOL)verifyConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    BOOL connection = !(networkStatus == NotReachable);
    
    if (!connection){
        [[[UIAlertView alloc] initWithTitle:LString(@"Attention") message:LString(@"no_connection") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    return connection;
}

#pragma mark - UI Methods

+(void)drawBackgroundView:(UIView*)view
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[UIColor neon_bgDarkColor].CGColor,
                        (id)[UIColor neon_bgLightColor].CGColor];
    gradient.locations = @[@(0.3),
                           @(0.7)];
    [view.layer  insertSublayer:gradient atIndex:0];
}

+(void)circleGradientFilledWithOutline:(UIView*)circleView outlineColor:(UIColor*)outlinecolor gradientColor:(UIColor*)gradientColor
{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    float width = circleView.frame.size.width;
    float height = circleView.frame.size.height;
    [circleLayer setBounds:CGRectMake(2.0f, 2.0f, width-2.0f, height-2.0f)];
    [circleLayer setPosition:CGPointMake(width/2, height/2)];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(2.0f, 2.0f, width-2.0f, height-2.0f)];
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:gradientColor.CGColor];
    [circleLayer setStrokeColor:outlinecolor.CGColor];
    [circleLayer setLineWidth:10];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = circleView.bounds;
    gradient.colors = @[(id)gradientColor.CGColor,
                        (id)outlinecolor.CGColor];    

    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);
    
    gradient.locations = @[@(0.2),
                           @(1.0)];
    [circleLayer setMask:gradient];
    [[circleView layer] addSublayer:circleLayer];
}

+(void)circleFilledWithOutline:(UIView*)circleView fillColor:(UIColor*)fillColor outlineColor:(UIColor*)outlinecolor andLineWidth:(float)lineWidth
{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    float width = circleView.frame.size.width;
    float height = circleView.frame.size.height;
    [circleLayer setBounds:CGRectMake(2.0f, 2.0f, width-2.0f, height-2.0f)];
    [circleLayer setPosition:CGPointMake(width/2, height/2)];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(2.0f, 2.0f, width-2.0f, height-2.0f)];
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:fillColor.CGColor];
    [circleLayer setStrokeColor:outlinecolor.CGColor];
    [circleLayer setLineWidth:lineWidth];
    [[circleView layer] addSublayer:circleLayer];
}

+(void)circleFilledWithOutline:(UIView*)circleView fillColor:(UIColor*)fillColor outlineColor:(UIColor*)outlinecolor lineEnd:(float)lineEnd{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float width = screenRect.size.width-20;
    float height = width;
    [circleLayer setBounds:CGRectMake(2.0f, 2.0f, width-2.0f, height-2.0f)];
    [circleLayer setPosition:CGPointMake(width/2, height/2)];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(2.0f, 22.0f, width-2.0f, height-2.0f)];
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:fillColor.CGColor];
    [circleLayer setStrokeColor:outlinecolor.CGColor];
    [circleLayer setLineWidth:2.0f];
    [[circleView layer] addSublayer:circleLayer];
    circleLayer.position = circleView.center;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    CGPoint line_start = CGPointMake(circleView.center.x, circleLayer.position.y+circleLayer.frame.size.height/2+21);
    [linePath moveToPoint:line_start];
    CGPoint line_end = CGPointMake(circleView.center.x, lineEnd);
    [linePath addLineToPoint:line_end];
    [lineLayer setPath:[linePath CGPath]];
    [lineLayer setFillColor:fillColor.CGColor];
    [lineLayer setStrokeColor:outlinecolor.CGColor];
    [lineLayer setLineWidth:2.0f];
    [[circleView layer] addSublayer:lineLayer];
}

#pragma mark - Mask Methods

/*
 MASKS
 
 No metodo de delegate do textField:
 -------------------------------------------------------------------
 -(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 textField.text=[textField.text stringByAppendingString:string];
 
 //implementação das mascaras
 textField.text = [MaskText CEPMaskWithText:textField.text andRange:range];
 
 //retorno do metodo
 return [MaskText returnForShouldChangeCharactersInRange:range];
 }
 -------------------------------------------------------------------
 */
+(BOOL)returnForShouldChangeCharactersInRange:(NSRange)range{
    if (range.length==1)
        return YES;
    else
        return NO;
}

+(NSString*)currencyMaskWithText:(NSString*)text andRange:(NSRange)range
{
    NSInteger charCount = [text length];
    
    NSString *charText = [text substringFromIndex:charCount-1];
    if ([charText isEqualToString:@"R"] || [charText isEqualToString:@"$"] || [charText isEqualToString:@","] || [charText isEqualToString:@" "])
        return [text substringToIndex:charCount-1];
    
    NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789R$, "];
    NSString *removeWord = [text stringByTrimmingCharactersInSet:numSet];
    
    if ([text rangeOfString:removeWord].location != NSNotFound)
        return [text substringToIndex:charCount-1];
    
    text = [text stringByReplacingOccurrencesOfString:@"R" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    charCount = [text length];
    
    if (range.length==1){
        if (charCount < 5){
            text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
            text = [NSString stringWithFormat:@"0,%@",text];
        }else {
            text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
            text = [NSString stringWithFormat:@"%@,%@",[text substringToIndex:text.length-3],[text substringFromIndex:text.length-3]];
        }
    } else{
        if (charCount == 1)
            text = [NSString stringWithFormat:@"0,%@",text];
        else{
            if (charCount==5 && [text hasPrefix:@"0"])
                text = [text substringFromIndex:1];
            text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
            text = [NSString stringWithFormat:@"%@,%@",[text substringToIndex:text.length-2],[text substringFromIndex:text.length-2]];
        }
    }
    
    return [NSString stringWithFormat:@"R$ %@",text];
}

+(NSString*)formatNumber:(double)value
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@"."];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@","];
    [numberFormatter setCurrencySymbol:@""];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:2];
    
    NSString *text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
    return text;
}

@end
