//
//  DoubanHelpVC.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DoubanHelpVC : UIViewController<UIWebViewDelegate>
{
    UIView *navView;
    UIWebView *webView;
    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *navTitle;

- (void)viewWeb: (NSString *) urlStr;


@end
