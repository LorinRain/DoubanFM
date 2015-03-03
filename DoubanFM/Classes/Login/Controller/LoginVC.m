//
//  LoginVC.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "LoginVC.h"
#import "MBProgressHUD.h"

@interface LoginVC ()

@end

@implementation LoginVC

@synthesize txtUserName = _txtUserName;
@synthesize txtPassword = _txtPassword;

@synthesize isLoginSuccess;

#pragma mark - ViewLifeCycle视图生命周期
-(void) viewDidLoad
{
    [super viewDidLoad];
    
    if(DeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 导航栏设置
    self.navigationItem.hidesBackButton = YES;
    
    navView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 100, 30)];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ic_actionbar_logo.png"]];
    logo.frame = CGRectMake(2+15, 7, 30, 30);
    [navView addSubview: logo];
    
    UIButton *btnBack = [UIButton buttonWithType: UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 17, self.navigationController.navigationBar.frame.size.height);
    //[btnBack setImage: [UIImage imageNamed: @"ab_back_holo_light.png"] forState: UIControlStateNormal];
    //btnBack.backgroundColor = [UIColor redColor];
    [navView addSubview: btnBack];
    
    UIImageView *backIcon = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ab_back_holo_light.png"]];
    backIcon.frame = CGRectMake(0, 15, 17, 15);
    [btnBack addSubview: backIcon];
    
    [btnBack addTarget: self action: @selector(btnBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame: CGRectMake(35+15, 8+5, 150, 20)];
    logoLabel.text = @"豆瓣FM登录";
    [logoLabel setTextColor: [UIColor blackColor]];
    [logoLabel setTextAlignment: NSTextAlignmentLeft];
    logoLabel.backgroundColor = [UIColor clearColor];
    logoLabel.font = [UIFont systemFontOfSize: 16.f];
    [navView addSubview: logoLabel];
    
    [self.navigationController.navigationBar addSubview: navView];
    
    // 界面
    self.view.backgroundColor = [UIColor colorWithRed: 232/255.f green: 238/255.f blue: 234/255.f alpha: 1];
    
    // 登录的界面（底视图）
    loginView = [[UIView alloc] initWithFrame: CGRectMake(0, 10, self.view.frame.size.width, 150)];
    
    loginView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview: loginView];
    
    // 登录的控件，加载到底视图上
    labelDouban = [[UILabel alloc] initWithFrame: CGRectMake(20, 10, 100, 15)];
    labelDouban.text = @"用豆瓣帐号登录";
    [labelDouban setFont: [UIFont systemFontOfSize: 12.f]];
    labelDouban.backgroundColor = [UIColor clearColor];
    
    [loginView addSubview: labelDouban];
    
    // 用户名输入框
    _txtUserName = [[UITextField alloc] initWithFrame: CGRectMake(20, 35, 280, 30+5)];
    _txtUserName.backgroundColor = [UIColor whiteColor];
    _txtUserName.placeholder = @"Email/用户名";
    _txtUserName.text = @"";
    [_txtUserName setClearButtonMode: UITextFieldViewModeAlways];
    _txtUserName.delegate = self;
    _txtUserName.highlighted = YES;
    
    [loginView addSubview: _txtUserName];
    
    // 密码输入框
    _txtPassword = [[UITextField alloc] initWithFrame: CGRectMake(20, 70+5, 280, 30+5)];
    _txtPassword.backgroundColor = [UIColor whiteColor];
    _txtPassword.placeholder = @"密码";
    _txtPassword.text = @"";
    [_txtPassword setSecureTextEntry: YES];    // 密文输入
    [_txtPassword setClearButtonMode: UITextFieldViewModeAlways];    // 设置在输入时，后面有一个清除按钮
    [_txtPassword setClearsOnBeginEditing: YES];    // 开始输入时先清空
    _txtPassword.delegate = self;
    
    [loginView addSubview: _txtPassword];
    
    // 登录按钮
    UIButton *btnLogin = [UIButton buttonWithType: UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(20, 110+10, _txtPassword.frame.size.width, _txtPassword.frame.size.height);
    btnLogin.backgroundColor = [UIColor colorWithRed: 75/255.f green: 147/255.f blue: 128/255.f alpha: 1];
    [btnLogin setTitle: @"登录" forState: UIControlStateNormal];
    [btnLogin setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    
    // 添加事件
    [btnLogin addTarget: self action: @selector(btnLoginClick) forControlEvents: UIControlEventTouchUpInside];
    
    [loginView addSubview: btnLogin];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 将导航栏视图移除
    [navView removeFromSuperview];
}

#pragma mark - ButtonAction按钮事件
-(void) btnBackAction
{
    [self.navigationController popViewControllerAnimated: YES];
}

-(void) btnLoginClick
{
    // 用户没有输入用户名的情况
    if([_txtUserName.text isEqualToString: @""]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview: hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入你的Email/用户名";
        hud.frame = CGRectMake((self.view.frame.size.width - 100) / 2, self.view.frame.size.height - 360, 100, 20);
        [hud setLabelFont: [UIFont systemFontOfSize: 12.f]];
        // 取消输入框的第一响应者的身份，因为键盘会挡住弹出的提示框
        [_txtUserName resignFirstResponder];
        [_txtPassword resignFirstResponder];
        
        [hud showAnimated: YES whileExecutingBlock:^() {
            sleep(2);
        }];
        
        return;
    }
    
    // 用户没有输入密码的情况
    if(![_txtUserName.text isEqualToString: @""] && [_txtPassword.text isEqualToString: @""]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview: hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入你在豆瓣的注册密码";
        hud.frame = CGRectMake((self.view.frame.size.width - 100) / 2, self.view.frame.size.height - 360, 100, 20);
        [hud setLabelFont: [UIFont systemFontOfSize: 12.f]];
        [_txtPassword resignFirstResponder];
        [_txtUserName resignFirstResponder];
        
        [hud showAnimated: YES whileExecutingBlock:^() {
            sleep(2);
        }];
        
        return;
    }
    
    // 用户名和密码都有输入，开始请求
    NSLog(@"qingqiuqleej");
    loginData  = [[GetData alloc] init];
    loginData.delegate = self;
    loginData.userName = _txtUserName.text;
    loginData.passWord = _txtPassword.text;
    [loginData login];
    
}

#pragma mrak - UITextField Delegate关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mrak - SendData在请求数据类里面自定义协议
// 登录成功后，将所需的信息推出
-(void) senLoginInfo: (ModelPro *) model
{
    // 这个方法，只会在登录成功才调用
    NSLog(@"登录成功调用");
    
    // 登录成功，将用户信息写入数据库
    sqliteData = [[DoubanFMData alloc] init];
    if([sqliteData isLogin]) {    // 如果已经登录，则更新
        [sqliteData updateUser: model.userId andToken: model.userToken andExpire: model.userExpire andName: model.userName andEmail: model.userEmail];
    } else {   // 没有登录，则插入
        [sqliteData insertUser: model.userId andToken: model.userToken andExpire: model.userExpire andName: model.userName andEmail: model.userEmail];
    }
    
    // 返回登录成功信息
    //    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
    //    [self.view addSubview: hud];
    //    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = @"登录成功";
    //    hud.frame = CGRectMake((self.view.frame.size.width - 100) / 2, self.view.frame.size.height - 360, 50, 20);
    //    [hud setLabelFont: [UIFont systemFontOfSize: 12.f]];
    //    [_txtPassword resignFirstResponder];
    //    [_txtUserName resignFirstResponder];
    //
    //    [hud showAnimated: YES whileExecutingBlock:^() {
    //        sleep(3);
    //    }];
    
    isLoginSuccess = YES;
    
    // 页面跳转
    // 延迟跳转
    //[NSTimer scheduledTimerWithTimeInterval: 2 target: self selector: @selector(popToPre) userInfo: nil repeats: NO];
    [self.navigationController popViewControllerAnimated: YES];
    
}

// 请求后，报告登录状态
-(void) sendLoginStatu:(BOOL *)isLogin
{
    // 请求登录后，这个方法一定会调用
    NSLog(@"登录状态报告。。。");
    if(!isLogin) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview: hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录失败，请检查你的输入是否正确";
        hud.frame = CGRectMake((self.view.frame.size.width - 100) / 2, self.view.frame.size.height - 360, 100, 20);
        [hud setLabelFont: [UIFont systemFontOfSize: 12.f]];
        [_txtPassword resignFirstResponder];
        [_txtUserName resignFirstResponder];
        
        [hud showAnimated: YES whileExecutingBlock:^() {
            sleep(3);
        }];
        
        isLoginSuccess = NO;
        
        return;
    }
}

-(void) popToPre
{
    [self.navigationController popViewControllerAnimated: YES];
}


@end
