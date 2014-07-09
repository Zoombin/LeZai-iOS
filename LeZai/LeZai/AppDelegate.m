//
//  AppDelegate.m
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "AppDelegate.h"
#import "OrderViewController.h"
#import "CarpoolingViewController.h"
#import "DBViewController.h"
#import "AppDelegate+Appearance.h"
#import "LZService.h"
#import "APService.h"
#import "SelectRoleViewController.h"
#import "AllOrderListViewController.h"
#import "OrderingListViewController.h"
#import "LoginViewController.h"
#import "MobClick.h"

@implementation AppDelegate {
    NSString *downloadUrl;
}

- (void)test
{

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self test];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // Required
    [MobClick startWithAppkey:@"53a7e80556240bee0c066673" reportPolicy:SEND_INTERVAL   channelId:@"App Store"];
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    // Required
    [APService setupWithOption:launchOptions];
    
    [self customizeAppearance];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([[LZService shared] userRole]) {
        if ([[[LZService shared] userRole] isEqualToString:I_AM_DRIVER]) {
            [self addDirverTabBar];
        } else {
            [self addCustomerTabBar];
        }
    } else {
        [self changeRole];
    }
    return YES;
}

- (void)addDirverTabBar
{
    if ([[LZService shared] userToken]) {
         UINavigationController *allNavigationBar = [[UINavigationController alloc] initWithRootViewController:[AllOrderListViewController new]];
        
         UINavigationController *ingNavigationBar = [[UINavigationController alloc] initWithRootViewController:[OrderingListViewController new]];
        
        UINavigationController *dbNavigationBar = [[UINavigationController alloc] initWithRootViewController:[DBViewController new]];
        
        _tabBarController = [[UITabBarController alloc] init];
        [_tabBarController setViewControllers:@[allNavigationBar, ingNavigationBar, dbNavigationBar]];
        
        [self.window setRootViewController:_tabBarController];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
        [self.window setRootViewController:navigationController];
        [self.window makeKeyAndVisible];
    }
}

- (void)addCustomerTabBar
{
    UINavigationController *carpoolingNavigationBar = [[UINavigationController alloc] initWithRootViewController:[OrderViewController new]];
    UINavigationController *orderNavigationBar = [[UINavigationController alloc] initWithRootViewController:[CarpoolingViewController new]];
    
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:@[carpoolingNavigationBar, orderNavigationBar]];
    
    [self.window setRootViewController:_tabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)changeRole
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[SelectRoleViewController new]];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
}

- (void)addSignIn
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
}

//
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"%@", userInfo);
    if (userInfo) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送信息" message:userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)checkUpdate
{
    [[LZService shared] checkUpdateWithBlock:^(NSDictionary *result) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
           NSString *cversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            NSString *version = result[@"IosVerion"];
            downloadUrl = result[@"IosUrl"];
            if(version && [version compare:cversion] == NSOrderedDescending) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"有新版本更新！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id823497557"]];
    }
}

- (void)addTabBar
{
    UINavigationController *carpoolingNavigationBar = [[UINavigationController alloc] initWithRootViewController:[OrderViewController new]];
    UINavigationController *orderNavigationBar = [[UINavigationController alloc] initWithRootViewController:[CarpoolingViewController new]];
    UINavigationController *dbNavigationBar = [[UINavigationController alloc] initWithRootViewController:[DBViewController new]];
    
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:@[carpoolingNavigationBar, orderNavigationBar, dbNavigationBar]];
    
    [self.window setRootViewController:_tabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self checkUpdate];
    
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
