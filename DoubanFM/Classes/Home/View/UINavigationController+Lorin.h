//
//  UINavigationController+Lorin.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Lorin)

// 设置导航栏上的标题
+ (void)navContro:(UINavigationController *)nav titleName:(NSString *)name;

// 设置导航栏上的“菜单”按钮
+ (void)navContro:(UINavigationController *)nav menuButtonTarget:(id)target action:(SEL)action;

// 设置导航栏左边“返回”按钮
+ (void)navContro:(UINavigationController *)nav backButtonTarget:(id)target action:(SEL)action;

// 去处导航栏左边“返回”按钮
+ (void)navControl:(UINavigationController *)navRremoveBackBtn;

@end
