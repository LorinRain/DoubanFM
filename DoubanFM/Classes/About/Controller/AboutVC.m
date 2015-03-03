//
//  AboutVC.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad
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
    logoLabel.text = @"关于";
    [logoLabel setTextColor: [UIColor blackColor]];
    [logoLabel setTextAlignment: NSTextAlignmentLeft];
    logoLabel.backgroundColor = [UIColor clearColor];
    logoLabel.font = [UIFont systemFontOfSize: 16.f];
    [navView addSubview: logoLabel];
    
    //[self.navigationController.navigationBar addSubview: navView];
    
    self.view.backgroundColor = [UIColor colorWithRed: 238/255.f green: 238/255.f blue: 238/255.f alpha: 1];
    
    // 图片
    UIImageView *img = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"splash_screen_logo"]];
    img.frame = CGRectMake(70, 30, 150+30, 55+11);
    
    [self.view addSubview: img];
    
    // 应用名称信息
    UILabel *labelName = [[UILabel alloc] initWithFrame: CGRectMake(10, 30+66+25, 300, 20)];
    labelName.text = @"豆瓣FM";
    [labelName setTextAlignment: NSTextAlignmentCenter];
    labelName.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview: labelName];
    
    // 作者信息
    UILabel *labelOwner = [[UILabel alloc] initWithFrame: CGRectMake(10, 50+66+25+15, 300, 15)];
    labelOwner.text = @"@2014 Lorin Rain";
    labelOwner.textColor = [UIColor grayColor];
    labelOwner.font = [UIFont systemFontOfSize: 15.f];
    [labelOwner setTextAlignment: NSTextAlignmentCenter];
    labelOwner.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview: labelOwner];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview: navView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [navView removeFromSuperview];
}

-(void) btnBackAction
{
    [self.navigationController popViewControllerAnimated: YES];
}



@end
