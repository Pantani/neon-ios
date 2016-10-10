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

@end
