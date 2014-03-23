//
//  BBUAppDelegate.m
//  PuckMan
//
//  Created by Boris Bügling on 01.02.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "BBUAppDelegate.h"
#import "BBUViewController.h"

@implementation BBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [BBUViewController new];
    [self.window makeKeyAndVisible];
    
    [application setStatusBarHidden:YES];
    return YES;
}

@end
