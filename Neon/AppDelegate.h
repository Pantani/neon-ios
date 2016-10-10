//
//  AppDelegate.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright © 2016 Danilo Pantani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) Reachability *hostReach;

@end
