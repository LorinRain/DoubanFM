//
//  MoreVC.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DoubanFMData.h"

@interface MoreVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *headerView;
    DoubanFMData *sqlData;
    UIImageView *check;   // 选中单选框的图片
    
    // 弹出视图相关
    UIView *logoutView;
    UIControl *contol;
    
    // 导航栏目
    UIView *navView;
}

@property (nonatomic, strong) NSString *loginInfo;   // 第一行显示的内容（未登录提示登录，以登录显示用户名）
@property (nonatomic, strong) NSString *loginDetail; // 同上
@property (nonatomic) BOOL isChecked;    // 是否勾选3G下收听


// 公用section头部视图
- (UIView *) headerView: (NSString *)headerTitle;

// 单击选中时加上“对号”的方法
- (void)checkIt: (UITableViewCell *) cellC;

// 单击选中时去掉“对号”的方法
- (void)unCheckIt;

// 弹出退出登录对话框
- (void)showLogoutView;

@end
