//
//  AppDelegate+Appearance.m
//  LeZai
//
//  Created by 颜超 on 14-2-12.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "AppDelegate+Appearance.h"


@implementation AppDelegate (Appearance)

- (void)customizeAppearance
{
	id appearance;
#pragma mark - UINavigationBar Appearance
	appearance = [UINavigationBar appearance];
	UIColor *color = [UIColor colorWithRed:1.0/255.0 green:156.0/255.0 blue:223.0/255.0 alpha:1.0];
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		[appearance setBarTintColor:color];
	} else {
		[appearance setBackgroundImage:[self imageFromColor:color] forBarMetrics:UIBarMetricsDefault];
	}
	[appearance setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
	
#pragma mark - UITabBarItem Appearance
	appearance = [UITabBarItem appearance];
	[appearance setTitleTextAttributes:@{UITextAttributeFont : [UIFont systemFontOfSize:12], UITextAttributeTextColor : [UIColor whiteColor]} forState:UIControlStateNormal];
	
//	UIImage *image = [UIImage imageNamed:@"bottom_bar"];
	appearance = [UITabBar appearance];
	[appearance setBackgroundImage:[self imageFromColor:color]];
	[appearance setSelectionIndicatorImage:[[UIImage alloc] init]];
    
	
#pragma mark - UIBarButtonItem Appearance
	appearance = [UIBarButtonItem appearance];
	[appearance setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]} forState:UIControlStateNormal];
}

- (UIImage *)imageFromColor:(UIColor *)color
{
	return [self imageFromSize:CGSizeMake(1, 1) block:^(CGContextRef context) {
		CGRect rect = CGRectMake(0, 0, 1, 1);
		CGContextSetFillColorWithColor(context, [color CGColor]);
		CGContextFillRect(context, rect);
	}];
}

- (UIImage *)imageFromSize:(CGSize)size block:(void(^)(CGContextRef))block
{
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	block(context);
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

@end
