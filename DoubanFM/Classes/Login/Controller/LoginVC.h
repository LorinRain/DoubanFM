//
//  LoginVC.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetData.h"
#import "ModelPro.h"
#import "DoubanFMData.h"

@interface LoginVC : UIViewController<UITextFieldDelegate, SendData>
{
    UIView *navView;  // 导航栏上的view
    UIView *loginView;  // 登录显示相关的view
    UILabel *labelDouban; // @“用豆瓣帐号登录”
    
    GetData *loginData;
    DoubanFMData *sqliteData;
}

//----------------登录视图上的控件------------
@property (nonatomic, strong) UITextField *txtUserName;  // 输入用户名框
@property (nonatomic, strong) UITextField *txtPassword;  // 输入密码框

@property (nonatomic) BOOL isLoginSuccess;  // 判断是否登录成功


@end
