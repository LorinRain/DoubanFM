//
//  UINavigationController+Lorin.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "UINavigationController+Lorin.h"

@implementation UINavigationController (Lorin)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.修改外观
    UINavigationBar *bar = self.navigationBar;
    
    // 2.设置导航栏背景
    [bar setBackgroundColor: kBGCOLOR];
    
    // 3.设置导航栏文字的主题
//    [bar setTitleTextAttributes: @{UITextAttributeTextColor: [UIColor blackColor],
//                                   UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset: UIOffsetZero]
//                                   }];
    
    // 4.设置导航栏图片
    UIImageView *logo = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ic_actionbar_logo.png"]];
    logo.frame = CGRectMake(2+15, 7, 30, 30);
    [bar addSubview: logo];
    
    // 5.设置导航栏标题标签
    UILabel *logoLabel = [[UILabel alloc] initWithFrame: CGRectMake(35+15, 8+5, 150, 20)];
    [logoLabel setTextColor: [UIColor blackColor]];
    logoLabel.text = @"";
    [logoLabel setTextAlignment: NSTextAlignmentLeft];
    logoLabel.backgroundColor = [UIColor clearColor];
    logoLabel.font = [UIFont systemFontOfSize: 16.f];
    [bar addSubview: logoLabel];
}


+ (void)navContro:(UINavigationController *)nav titleName:(NSString *)name
{
    UILabel *label = [nav.navigationBar.subviews objectAtIndex: 2];
    label.text = name;
}

+ (void)navContro:(UINavigationController *)nav menuButtonTarget:(id)target action:(SEL)action
{
    UIButton *btnMore = [UIButton buttonWithType: UIButtonTypeCustom];
    btnMore.frame = CGRectMake(nav.navigationBar.frame.size.width - 48, 0, 40, nav.navigationBar.frame.size.height);
    UIImageView *menuIcon = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ic_menu_normal.png"]];
    menuIcon.frame = CGRectMake(12, 10, 24, 24);
    
    //[_btnMore addTarget: self action: @selector(btnMoreAction) forControlEvents: UIControlEventTouchUpInside];
    [btnMore addTarget: target action:action forControlEvents: UIControlEventTouchUpInside];
    
    [btnMore addSubview: menuIcon];
    
    [nav.navigationBar addSubview: btnMore];
}

+ (void)navContro:(UINavigationController *)nav backButtonTarget:(id)target action:(SEL)action
{
    UIButton *btnBack = [UIButton buttonWithType: UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 17, nav.navigationBar.frame.size.height);
    
    UIImageView *backIcon = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ab_back_holo_light.png"]];
    backIcon.frame = CGRectMake(0, 15, 17, 15);
    [btnBack addSubview: backIcon];
    
    [btnBack addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    
    [nav.navigationBar addSubview: btnBack];
}

+ (void)navControl:(UINavigationController *)navRremoveBackBtn
{
    
}

@end
