//
//  ChannelView.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetData.h"
#import "ModelPro.h"
#import "DoubanFMData.h"

@protocol SendChannel <NSObject>

@optional
- (void) sendChannel: (NSString *) channel;

-(void) sendLogin;   // 点击“未登录用户”后，推到登录页面

@end

@interface ChannelView : UIView<UITableViewDataSource, UITableViewDelegate, SendData>
{
    UIScrollView *_scrollView;  // 作为根视图
    UITableView *_tableView;
    
    GetData *getData;
    ModelPro *channels;
    
    NSMutableArray *btnAll;     // 定义数组，存放所有的按钮
    //NSMutableArray *btnRight;
    
    NSInteger btnTag;    // 全局变量，取得按钮的tag值，让table在滚动时，不会把图标抹去
    BOOL btnClicked;     // 按钮是否被按
    
    DoubanFMData *sqliteDataV;
    
    UIImageView *imgView;   // 正在播放图标
    
}

@property (nonatomic, assign) id<SendChannel> delegate;

//-------------------数据相关-------------------
@property (nonatomic, strong) NSArray *channelArray;  // 接收频道列表

@property (nonatomic) BOOL isChannelShowed;    // 判断是否已经有列表了
@property (nonatomic, strong) NSString *currentChannelV;

@property (nonatomic, strong) NSString *uName;   // 显示已登录用户用户名

// 判断是否已经登录
//@property (nonatomic) BOOL isLogin;

// 登录成功，返回的用户名
//@property (nonatomic, strong) NSString *userNameText;

// 登录时，页面间跳转，改变登录用户名
@property (nonatomic, strong) UILabel *userNameLabel;

-(void) requstData;      // 请求数据方法，将它分离，在init的时候就不必进行网络请求
-(void) setPlayingIcon: (UIButton *) btn;   // 将“正在播放”图标加在所点击的按钮上
-(void) cleanOtherIcon: (UIButton *) btn;   // 将非点击按钮上的“正在播放”按钮清除

// 刷新表格
-(void) relodTable;

@end

