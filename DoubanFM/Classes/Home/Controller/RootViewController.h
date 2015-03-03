//
//  RootViewController.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GetData.h"
#import "ModelPro.h"
#import "ChannelView.h"
#import "DoubanFMData.h"
#import "LoginVC.h"

@interface RootViewController : UIViewController<SendData, SendChannel, UIScrollViewDelegate, UIAlertViewDelegate>
{
    AVPlayer *player;
    GetData *getData;
    ModelPro *modelP;
    int currenSong;   // 当前正在播放的歌曲是播放列表的第几个
    BOOL isRequestSuccess; // 请求是否成功
    
    int secondCountDown;   // 倒计时时长
    NSTimer *countDownTimer; // 倒计时计时器
    BOOL pause;          // 是否处于暂停
    
    UIScrollView *_scrollView;  // 滚动视图
    
    NSString *currentChannelId;
    
    ChannelView *channelView;
    
    // 导航栏部分
    UIView *navView;      // 底视图
    UILabel *logoLabel;   // 显示豆瓣fm或频道名
    NSInteger reachStatu;  // 连接状态
    UIButton *btnBack;     // 返回按钮
    
    // 数据相关
    DoubanFMData *sqliteData;
    
    // 跳到的登录界面
    LoginVC *loginPage;
    
    // 歌曲首否收藏
    BOOL isLiked;
    
}

//-------------------界面显示-------------------
@property (nonatomic, strong) UIImageView *songPicture;   // 歌曲封面
@property (nonatomic, strong) UIView *buttomChoosen;      // 底部控制栏
@property (nonatomic, strong) UIButton *likeIcon;         // 喜欢按钮
@property (nonatomic, strong) UIButton *delIcon;          // 不再播放按钮
@property (nonatomic, strong) UIButton *nextIcon;         // 下一曲按钮
@property (nonatomic, strong) UIButton *btnPause;         // 暂停按钮
@property (nonatomic, strong) UILabel *songNmae;          // 显示当前正在播放的歌曲名
@property (nonatomic, strong) UILabel *currentTime;       // 显示播放进度
@property (nonatomic, strong) UILabel *songArtist;        // 显示演唱者

//-------------------数据相关-------------------
@property (nonatomic, strong) NSArray *dataArray;         // 接受请求得到的数据
@property (nonatomic, strong) NSString *songUrl;          // 得到的歌曲地址

//-------------------类似开关-------------------
@property (nonatomic) BOOL isChannelChanged;           // 进入程序后，在点击下一曲或自己播放到下一曲时，会再次请求频道，用这个开关优化

// 歌曲id，songSid
@property (nonatomic, strong) NSString *songSidR;


// 播放歌曲
-(void) playSong;

// 显示歌曲信息
-(void) showSongInfo: (NSString *) name andPicture: (NSString *) picture andArtist: (NSString *) artist;

// 倒计时
-(void) showCurrentTime: (NSNumber *) num;

// 导航栏显示频道
-(void) getChannelInfo;
-(void) showChannelName: (NSString *) name;

// 网络环境判断
-(void) networkJudge;

// 登录
-(void) loginNow;

// 导航栏在不同情景下的表现
-(void) showNavi: (NSString *) navTitle;
- (void)addBackButton;     // 添加“返回”按钮
- (void)removeBackButton;  // 去掉“返回”按钮

// 点击“红心”对按钮表现的方法
- (void)songLiked;

// wifi情境下实现网络请求，再3g情境下，由用户确定亦能触发
- (void)workOnWifi;




@end
