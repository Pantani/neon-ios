//
//  AppDelegate.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright © 2016 Danilo Pantani. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _hostReach = [Reachability reachabilityWithHostName:kHost];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [_hostReach startNotifier];
    
    _rootViewController = [[RootViewController alloc] init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:_rootViewController];
    _rootViewController.view.backgroundColor = kColor;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navC;
    self.window.backgroundColor = kColor;

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setBarTintColor:kColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

-(void)reachabilityChanged:(NSNotification *)note {
    //    Reachability *reachability = [note object];
    //    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
}

@end
