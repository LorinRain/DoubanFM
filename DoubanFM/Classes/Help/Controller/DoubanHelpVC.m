//
//  DoubanHelpVC.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "DoubanHelpVC.h"

@interface DoubanHelpVC ()

@end

@implementation DoubanHelpVC


@synthesize urlString;
@synthesize navTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(DeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self viewWeb: urlString];
    
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
    logoLabel.text = navTitle;
    [logoLabel setTextColor: [UIColor blackColor]];
    [logoLabel setTextAlignment: NSTextAlignmentLeft];
    logoLabel.backgroundColor = [UIColor clearColor];
    logoLabel.font = [UIFont systemFontOfSize: 16.f];
    [navView addSubview: logoLabel];
    
    [self.navigationController.navigationBar addSubview: navView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [navView removeFromSuperview];
}

- (void)viewWeb: (NSString *) urlStr
{
    // 网页浏览器
    webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - 20)];
    
    [self.view addSubview: webView];
    
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    [webView loadRequest: request];
    
    webView.delegate = self;
}

-(void) btnBackAction
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - UIWebViewDelegate协议
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    hud = [[MBProgressHUD alloc] initWithView: self.view];
    [self.view addSubview: hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(100.f, 20.f);
    
    [hud showAnimated: YES whileExecutingBlock:^() {
        sleep(INT_MAX);
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud removeFromSuperview];
}


@end
