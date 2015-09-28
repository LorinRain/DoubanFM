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
#import "ChannelCell.h"

@protocol SendChannel <NSObject>

@optional
- (void) sendChannel: (NSString *) channel;

-(void) sendLogin;   // 点击“未登录用户”后，推到登录页面

@end

@interface ChannelView : UIView<UITableViewDataSource, UITableViewDelegate, SendData, ChannelCellDeleagte>
{
    UIScrollView *_scrollView;  // 作为根视图
    
    GetData *getData;
    ModelPro *channels;
    
    DoubanFMData *sqliteDataV;
    
    NSMutableArray *sectionOneArray;  // 第一个section的数据数组（只显示私人和红心）
    NSMutableArray *sectionTwoArray;  // 第二个section的数据数组（显示推荐频道）
    
}

@property (nonatomic, assign) id<SendChannel> delegate;

@property(nonatomic, strong) UITableView *tableView;

//-------------------数据相关-------------------
@property (nonatomic, strong) NSMutableArray *channelArray;  // 接收频道列表

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

// 刷新表格
-(void) relodTable;

// 切换频道
- (void)changeToChannnel:(NSString *)channel;

// 获取当前正在播放的频道
+ (NSString *)currentPlayingChannel;

@end

