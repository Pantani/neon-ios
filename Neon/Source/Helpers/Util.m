//
//  Util.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "Util.h"
#import "Reachability.h"

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

+(void)circleFilledWithOutline:(UIView*)circleView fillColor:(UIColor*)fillColor outlineColor:(UIColor*)outlinecolor{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    float width = circleView.frame.size.width;
    float height = circleView.frame.size.height;
    [circleLayer setBounds:CGRectMake(2.0f, 2.0f, width-2.0f, height-2.0f)];
    [circleLayer setPosition:CGPointMake(width/2, height/2)];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(2.0f, 2.0f, width-2.0f, height-2.0f)];
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:fillColor.CGColor];
    [circleLayer setStrokeColor:outlinecolor.CGColor];
    [circleLayer setLineWidth:3.0f];
    [[circleView layer] addSublayer:circleLayer];
}

@end