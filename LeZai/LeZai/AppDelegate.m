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

@implementation AppDelegate {
    NSString *downloadUrl;
}

- (void)test
{
    UIImage *image = [UIImage imageNamed:@"widget_dropdown_155_n"];
//    [[LZService shared] uploadImageWithType:YES orderId:@"ca00521b-bfad-484b-bcb8-3b53eb1d3ba7" image:image orderNo:@"1406092000016" withBlock:^(NSDictionary *result, NSError *error) {
//        NSLog(@"%@", result);
//    }];
//    [[LZService shared] orderListPage:1 count:10 WithBlock:^(NSDictionary *result, NSError *error) {
//        NSLog(@"%@", result);
//    }];
//    [[LZService shared] orderInfo:@"05a27f7b-7dcc-463f-b121-53366be3a86e" withBlock:^(NSDictionary *result, NSError *error) {
//        NSLog(@"%@", result);
//    }];
//    [[LZService shared] addOrder:@"1704b8b6-bc0c-4ff8-923b-b6788f4fc5b8" price:@"100" withBlock:^(NSDictionary *result, NSError *error) {
//        NSLog(@"%@", result); //用Oid
//    }];
//    [[LZService shared] loginOrRegister:@"13862090556" password:@"123456" withBlock:^(NSDictionary *result, NSError *error) {
//        NSLog(@"%@", result);
//    }];
    
//    [[LZService shared] OrderedListWithBlock:^(NSDictionary *result, NSError *error) {
//        NSLog(@"%@", result);
//    }];
    //Test Token: adcc88e110544b9596ef2fda67403a66 13862090556 123456
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self test];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // Required
//    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                   UIRemoteNotificationTypeSound |
//                                                   UIRemoteNotificationTypeAlert)];
//    // Required
//    [APService setupWithOption:launchOptions];
    
    [self customizeAppearance];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self addTabBar];
    return YES;
}

//
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    // Required
//    [APService registerDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    // Required
//    [APService handleRemoteNotification:userInfo];
//}

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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
