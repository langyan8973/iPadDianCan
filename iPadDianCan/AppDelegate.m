//
//  AppDelegate.m
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "AFRestAPIClient.h"
#import "LoginViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *udid=[ud objectForKey:@"udid"];
    if (udid==nil) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = [NSString stringWithFormat:@"%@", uuidString ];
        CFRelease(puuid);
        CFRelease(uuidString);
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                result, @"udid",
                                @"2", @"ptype",
                                nil];
        [[AFRestAPIClient sharedClient] postPath:@"device" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dn=(NSDictionary *)responseObject;
            NSString *string=[dn objectForKey:@"deviceid"];
            [ud setValue:string forKey:@"udid"];
            [ud synchronize];
            [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:string];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"错误: %@", error);
        }];
    }
    else{
        [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:udid];
    }
    
    LoginViewController *loginCon= [[LoginViewController alloc] init];
    UINavigationController *logNavCon = [[UINavigationController alloc] initWithRootViewController:loginCon];
    [logNavCon.navigationBar setBackgroundImage:[UIImage imageNamed:@"CustomizedNavBarBg"] forBarMetrics:UIBarMetricsDefault];
    self.window.rootViewController=logNavCon;    
    [loginCon release];
    [logNavCon release];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)handleSwipeFromRight:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
