//
//  RootViewController.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "RootViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "ModelPro.h"
#import "MoreVC.h"

@implementation RootViewController

@synthesize songPicture = _songPicture;
@synthesize buttomChoosen = _buttomChoosen;
@synthesize likeIcon = _likeIcon;
@synthesize delIcon = _delIcon;
@synthesize nextIcon = _nextIcon;
@synthesize btnPause = _btnPause;
@synthesize songNmae = _songNmae;
@synthesize currentTime = _currentTime;
@synthesize songArtist = _songArtist;

@synthesize dataArray = _dataArray;
@synthesize songUrl = _songUrl;

@synthesize isChannelChanged;

@synthesize songSidR = _songSidR;

#pragma mark - 自定义视图
-(void)loadView
{
    // 初始化滚动视图
    UIScrollView *scView = [[UIScrollView alloc] init];
    scView.frame = [UIScreen mainScreen].applicationFrame;
    // 用户交互
    scView.userInteractionEnabled = YES;
    // 设置属性
    scView.backgroundColor = kBGCOLOR;
    scView.pagingEnabled = YES;
    scView.bounces = NO;   // 设置边界不回弹
    scView.showsHorizontalScrollIndicator = NO;   // 设置水平滚动指示不可见
    
    _scrollView = scView;
    self.view = _scrollView;
}


#pragma mark - View lifeCycle视图声明周期
-(void) viewDidLoad
{
    [super viewDidLoad];
    
    // iOS设备版本判断
    if(DeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 调整导航栏
    [self.navigationController.navigationBar setTintColor: kBGCOLOR];
//    // 设置导航栏标题
//    [UINavigationController navContro: self.navigationController titleName: @"豆瓣FM"];
//    // 添加“菜单”按钮
//    [UINavigationController navContro: self.navigationController menuButtonTarget: self action: @selector(btnMoreAction)];
//    // 添加“返回”按钮
//    [UINavigationController navContro: self.navigationController backButtonTarget: self action: @selector(btnBackClick)];
    [self showNavi: @"豆瓣FM"];
    
    // 调整滚动视图的尺寸
    CGSize size = self.view.frame.size;
    CGFloat contentOffset = (250 / 320.0) *size.width;
    _scrollView.contentSize = CGSizeMake(size.width + contentOffset, 0);
    _scrollView.contentOffset = CGPointMake(contentOffset, 0);  // 初始偏移量（实现左划功能）
    _scrollView.delegate = self;
    
    // 添加底部的控制按钮
    // 初始化底部控制栏
    CGSize choosenSize = CGSizeMake(size.width, (110 / 460.0) * size.height);
    _buttomChoosen = [[UIView alloc] initWithFrame: CGRectMake(contentOffset, size.height - choosenSize.height, choosenSize.width, choosenSize.height)];
    
    _buttomChoosen.backgroundColor = [UIColor clearColor];
    
    // 将控制歌曲的三个按钮添加到底部控制栏上
    _likeIcon = [UIButton buttonWithType: UIButtonTypeCustom];
    _delIcon = [UIButton buttonWithType: UIButtonTypeCustom];
    _nextIcon = [UIButton buttonWithType: UIButtonTypeCustom];
    
    
    [_likeIcon setImage: [UIImage imageNamed: @"ic_player_fav.png"] forState: UIControlStateNormal];
    [_delIcon setImage: [UIImage imageNamed: @"ic_player_ban.png"] forState: UIControlStateNormal];
    [_nextIcon setImage: [UIImage imageNamed: @"ic_player_next.png"] forState: UIControlStateNormal];
    
    _likeIcon.frame = CGRectMake((60 / 320.0) * choosenSize.width, (10 / 110.0) * choosenSize.height, 48, 36);
    _delIcon.frame = CGRectMake((135 / 320.0) * choosenSize.width,  (10 / 110.0) * choosenSize.height, 48, 36);
    _nextIcon.frame = CGRectMake((205 / 320.0) * choosenSize.width, (10 / 110.0) * choosenSize.height, 48, 36);
    
    // 添加事件
    //    [_nextIcon addTarget: self action: @selector(btnClickNextSong) forControlEvents: UIControlEventTouchUpInside];
    //    [_likeIcon addTarget: self action: @selector(btnClickLike) forControlEvents: UIControlEventTouchUpInside];
    //    [_delIcon addTarget: self action: @selector(btnClickDel) forControlEvents: UIControlEventTouchUpInside];
    
    [_buttomChoosen addSubview: _likeIcon];
    [_buttomChoosen addSubview: _delIcon];
    [_buttomChoosen addSubview: _nextIcon];
    
    [_scrollView addSubview: _buttomChoosen];
    
    
    // 无论有没有网络，图片视图应该加载上去（没有网络时加载网络指示器）
    _songPicture = [[UIImageView alloc] init];
    //_songPicture.frame = CGRectMake(250, 0, 320, 280);
    _songPicture.frame = CGRectMake(contentOffset, 0, size.width, (280 / 460.0) * size.height);
    //_songPicture.frame = kSongPictureSize;
    _songPicture.image = [UIImage imageNamed: @"bg_player_cover_loading.png"];
    _songPicture.contentMode = UIViewContentModeCenter;
    //_songPicture.backgroundColor = [UIColor colorWithRed: 34/255.f green: 34/255.f blue: 34/255.f alpha: 1];
    _songPicture.backgroundColor = kSongBGCOLOR;
    
    [_scrollView addSubview: _songPicture];
    
    // 创建数据库
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/data.sqlite"];
    NSData *sqlData = [NSData dataWithContentsOfFile: filePath];
    
    // 判断是否是第一次启动应用
    
    sqliteData = [[DoubanFMData alloc] init];
    
    if(sqlData.length == 0) {
        NSLog(@"第一次进入应用");
        [sqliteData createUserTable];
        [sqliteData createChannelTable];  // 只需要第一次执行
    } else {
        NSLog(@"不是第一次进入应用");
    }
    
    
    // 判断网络环境
    [self networkJudge];
    
    if(reachStatu == 1) {  // 使用3G网
        // 弹出提示流量警告信息
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil message: @"当前使用3G网络，这将耗费流量，是否确定？" delegate: self cancelButtonTitle: @"取消" otherButtonTitles: @"确定", nil];
        alert.delegate = self;
        [alert show];
    }
    
    if(reachStatu == 2) {  // 使用wifi
        
        [self workOnWifi];
        
        // 设置后台
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory: AVAudioSessionCategoryPlayback error: nil];
        [session setActive: YES error: nil];
        
    }
    
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 离开页面时，停止导航栏的请求
    //[getData cancelRequest];
    
    // 要离开页面时，将导航栏上的视图清除
    [navView removeFromSuperview];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 进入页面时，导航栏应该随之改变
    // 拿到当前频道名称，再此回到页面时，显示频道
    NSString *temp = logoLabel.text;
    [self showNavi: temp];
    
    // 登录成功后，将用户名传回来显示在view上
    if(loginPage.isLoginSuccess) {
        channelView.userNameLabel.text = [sqliteData defaultUserInfo: @"userName"];
        [channelView relodTable];
    }
    
    // 重新加在页面时，刷新数据
    [channelView relodTable];
    
    // 不同页面，返回按钮也不同
    if(_scrollView.contentOffset.x == (250 / 320.0) * self.view.frame.size.width) {
        [self addBackButton];
    }
    
    
}



#pragma mark - songsAction对歌曲的操作

// 播放歌曲
-(void) playSong
{
    // 计时器置0
    [countDownTimer invalidate];
    countDownTimer = nil;
    
    // 播放器
    NSString *songUrl = [NSString stringWithFormat: @"%@",_songUrl];
    NSURL *url = [NSURL URLWithString: songUrl];
    
    // 设置后台
    //    NSError *error;
    //    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &error];
    
    player = [[AVPlayer alloc] initWithURL: url];
    
    // 设置后台
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    [session setCategory: AVAudioSessionCategoryPlayback error: nil];
    //    [session setActive: YES error: nil];
    
    [player play];
    
}

// 显示歌曲信息
-(void) showSongInfo: (NSString *) name andPicture: (NSString *) picture andArtist: (NSString *) artist
{
    // 先显示中间图片
    _songPicture = [[UIImageView alloc] init];
    //_songPicture.frame = CGRectMake(250, 0, 320, 280);
    CGSize size = self.view.frame.size;
    _songPicture.frame = CGRectMake((250 / 320.0) * size.width, 0, size.width, (280 / 416.0) * size.height);
    //_songPicture.frame = kSongPictureSize;
    _songPicture.image = [UIImage imageNamed: @"bg_player_cover_default.png"];
    _songPicture.contentMode = UIViewContentModeCenter;
    //_songPicture.backgroundColor = [UIColor colorWithRed: 34/255.f green: 34/255.f blue: 34/255.f alpha: 1];
    _songPicture.backgroundColor = kSongBGCOLOR;
    
    [_scrollView addSubview: _songPicture];
    
    // 获取图片
    getData.songPic = picture;
    [getData getPicture];
    
    // 歌曲名
    // 先将之前的名称清空。因为在设置label背景图片为clearcolor时，更改名称会导致与上一次的名称重叠，所以先讲上一次清空，下面的几个控件的这句代码作用相同
    _songNmae.text = @"";
    //_songNmae = [[UILabel alloc] initWithFrame: CGRectMake(250+5, 308, 300, 20)];
    _songNmae = [[UILabel alloc] init];
    _songNmae.frame = CGRectMake((250 / 320.0) * size.width, (308 / 416.0) * size.height, size.width, (20 / 416.0) * size.height);
    //_songNmae = [[UILabel alloc] initWithFrame: kSongNameSize];
    _songNmae.backgroundColor = [UIColor clearColor];
    //[_songNmae setTextAlignment: UITextAlignmentCenter];
    [_songNmae setTextAlignment: NSTextAlignmentCenter];
    _songNmae.text = name;
    
    [_scrollView addSubview: _songNmae];
    
    // 时间
    _currentTime.text = @"";    // 作用上面有说明
    //_currentTime = [[UILabel alloc] initWithFrame: CGRectMake(250+70, 285, 100, 15)];
//    _currentTime = [[UILabel alloc] init];
//    _currentTime.frame = CGRectMake((320 / 320.0) * size.width, (285 / 416.0) * size.height, (100 / 320.0) * size.width, (15 / 416.0) * size.height);
//    //_currentTime = [[UILabel alloc] initWithFrame: kSongTimeSize];
//    _currentTime.backgroundColor = [UIColor clearColor];
    
    // 演唱者
    _songArtist.text = @"";     // 作用上面有说明
    //_songArtist = [[UILabel alloc] initWithFrame: CGRectMake(250+5, 330, 300, 20)];
    _songArtist = [[UILabel alloc] init];
    _songArtist.frame = CGRectMake((250 / 320.0) * size.width, (330 / 416.0) * size.height, size.width, (20 / 416.0) * size.height);
    //_songArtist = [[UILabel alloc] initWithFrame: kSongArtistSize];
    [_songArtist setTextAlignment: NSTextAlignmentCenter];
    _songArtist.text = artist;
    _songArtist.backgroundColor = [UIColor clearColor];
    [_songArtist setFont: [UIFont systemFontOfSize: 12.f]];
    
    [_scrollView addSubview: _songArtist];
    
}

// 倒计时显示剩余时间
-(void) showCurrentTime: (NSNumber *) num
{
    secondCountDown = [num intValue] + 3;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(countDownTimer) userInfo: nil repeats: YES];
}

// 暂停
-(void) pauseSong
{
    if(!pause) {
        // 将计时器暂停
        [countDownTimer setFireDate: [NSDate distantFuture]];
        [_btnPause setImage: [UIImage imageNamed: @"play_c.png"] forState: UIControlStateNormal];
        
        [player pause];
        pause = YES;
    } else {
        [countDownTimer setFireDate: [NSDate distantPast]];
        [_btnPause setImage: [UIImage imageNamed: @"pause_a.png"] forState: UIControlStateNormal];
        
        [player play];
        pause = NO;
    }
}

#pragma mark - SendDataDelegate实现自定义协议

// 自定义的协议，用于在异步请求完成后接收得到的数据
-(void) sendData: (NSArray *) arry
{
    _dataArray = arry;
    
    //if([_dataArray count] != 0) {  // 连接wifi，但没有网络会出现此情况
    
    modelP = [[ModelPro alloc] init];
    modelP = [_dataArray objectAtIndex: currenSong];
    NSString *temp = modelP.songURL;
    _songUrl = temp;
    
    [self playSong];
    
    [self showSongInfo: modelP.songTitle andPicture: modelP.songPicture andArtist: modelP.songArtist];
    [self showCurrentTime: modelP.songLength];
    
    _songSidR = modelP.songSid;
    NSLog(@"songSid is:%@",_songSidR);
    
    if([modelP.songLiked intValue] == 0) {
        isLiked = NO;
    }
    
    if([modelP.songLiked intValue] == 1) {
        isLiked = YES;
    }
    
    [self songLiked];
    
    // 此处getChannel是为了取得当前频道，便于在导航栏显示
    // 优化：不用在每次点击下一曲或者跳到下一曲时都执行此方法（因为此方法还涉及到网络请求）
    if(isChannelChanged) {
        if([currentChannelId intValue] == -3) {
            [self showChannelName: @"红心"];
        } else {
            [self getChannelInfo];
        }
    }
    
}

-(void) sendPictureData: (NSData *) picData
{
    // 初始化歌曲封面显示视图
    UIImage *pic = [[UIImage alloc] initWithData: picData];
    _songPicture = [[UIImageView alloc] initWithImage: pic];
    //_songPicture.frame = CGRectMake(250, 0, 320, 280);
    CGSize size = self.view.frame.size;
    _songPicture.frame = CGRectMake((250 / 320.0) * size.width, 0, size.width, (280 / 416.0) * size.height);
    //_songPicture.frame = kSongPictureSize;
    //_songPicture.backgroundColor = [UIColor colorWithRed: 34/255.f green: 34/255.f blue: 34/255.f alpha: 1];
    _songPicture.backgroundColor = kSongBGCOLOR;
    
    [_scrollView addSubview: _songPicture];
    
}

-(void) sendError
{
    // 请求出错，则将isRequestSuccess设为false
    isRequestSuccess = NO;
    
    // MBProgressHUD的用法再上面也有用到
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
    [self.view addSubview: hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"网络错误，请检查网络连接后重试";
    
    // 指定距离中心点的x轴和y轴的偏移量
    hud.yOffset = 50.f;
    [hud showAnimated: YES whileExecutingBlock:^() {
        sleep(3);
    } completionBlock:^() {
        [hud removeFromSuperview];
    }];
    
    return;
}

-(void) sendChannelData: (NSArray *) array
{
    for(ModelPro *temp in array) {
        if([currentChannelId intValue] == [temp.channelId intValue]) {
            [self showChannelName: temp.channelName];
            isChannelChanged = NO;  // 程序启动时会调用此方法，调用后，设置为NO
            break;
        }
    }
}

- (void)sendNoSongs
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
    [self.view addSubview: hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"还没有任何歌曲";
    //hud.yOffset = 100.f;
    hud.minSize = CGSizeMake(100.f, 20.f);
    [hud setLabelFont: [UIFont systemFontOfSize: 13.f]];
    
    [hud showAnimated: YES whileExecutingBlock:^() {
        sleep(3);
    }];
    
    // 返回私人频道
    if(!channelView) {
        channelView = [[ChannelView alloc] init];
    }
    
    [channelView changeToChannnel: @"0"];
    
    // 刷新表格
    [channelView.tableView reloadData];
}


#pragma mark - timerAction定时器调用方法

-(void) nextSong
{
    //NSLog(@"array count is:%d",[_dataArray count]);
    if(currenSong < ([_dataArray count] - 1)) {  // 每次获取的播放列表只存放5首歌曲
        modelP = [_dataArray objectAtIndex: currenSong + 1];
        NSString *temp = modelP.songURL;
        _songUrl = temp;
        
        [self playSong];
        
        [self showSongInfo: modelP.songTitle andPicture: modelP.songPicture andArtist: modelP.songArtist];
        [self showCurrentTime: modelP.songLength];
        
        _songSidR = modelP.songSid;
        NSLog(@"songSid is haha in the next:%@",_songSidR);
        
        if([modelP.songLiked intValue] == 0) {
            isLiked = NO;
        }
        
        if([modelP.songLiked intValue] == 1) {
            isLiked = YES;
        }
        
        [self songLiked];
        
        currenSong = currenSong + 1;
        
    } else if(currenSong == ([_dataArray count] - 1)) {
        // 请求新的歌曲（5首）
        getData.songType = @"p";
        getData.songSid = _songSidR;
        getData.channelId = currentChannelId;
        [getData getSongs];
        currenSong = 0;
    }
    
}

-(void) countDownTimer
{
    secondCountDown--;
    if(secondCountDown == 0) {
        [countDownTimer invalidate];
        countDownTimer = nil;
        
        [self nextSong];
    }
    // 显示在主屏幕
    // 时间
    //_currentTime = [[UILabel alloc] initWithFrame: CGRectMake(70, 285, 100, 15)];
    [_currentTime setTextAlignment: NSTextAlignmentRight];
    int minutes = secondCountDown / 60;
    int seconds = secondCountDown % 60;
    NSString *temp;
    if(seconds < 10) {
        temp = [NSString stringWithFormat: @"%d:0%d",minutes,seconds];
    } else {
        temp = [NSString stringWithFormat: @"%d:%2d",minutes,seconds];
    }
    //NSString *temp = [NSString stringWithFormat: @"%d:%2d",minutes,seconds];
    _currentTime.text = temp;
    [_currentTime setTextColor: [UIColor lightGrayColor]];
    
    //[self.view addSubview: _currentTime];
    [_scrollView addSubview: _currentTime];
}


#pragma mark - buttonAction下面三个控制按钮方法

// 点击“下一曲”按钮
-(void) btnClickNextSong
{
    getData.songType = @"s";
    getData.songSid = _songSidR;
    getData.channelId = currentChannelId;
    [getData getSongs];
    currenSong = 0;
}

// 点击“喜欢”按钮
-(void) btnClickLike
{
    if(![sqliteData isLogin]) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview: hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录后可以收藏";
        hud.yOffset = 100.f;
        hud.minSize = CGSizeMake(100.f, 20.f);
        [hud setLabelFont: [UIFont systemFontOfSize: 13.f]];
        
        [hud showAnimated: YES whileExecutingBlock:^() {
            sleep(3);
        }];
        
    } else {
        
        if(isLiked) {
            NSLog(@"in the Del songSid is:%@",_songSidR);
            getData.songSid = _songSidR;
            getData.channelId = currentChannelId;
            getData.songType = @"u";   // 取消收藏
            [getData likeSong];
            
            isLiked = NO;
            [self songLiked];
        } else {
            
            NSLog(@"in the Del songSid is:%@",_songSidR);
            getData.songSid = _songSidR;
            getData.channelId = currentChannelId;
            getData.songType = @"r";
            [getData likeSong];
            
            isLiked = YES;
            [self songLiked];
        }
        
    }
}

-(void) btnClickDel
{
    
    getData.songSid = _songSidR;
    getData.channelId = currentChannelId;
    getData.songType = @"b";    // 不再播放
    [getData getSongs];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
    [self.view addSubview: hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"好，这首歌不会再播了";
    hud.yOffset = 100.f;
    hud.minSize = CGSizeMake(100.f, 20.f);
    [hud setLabelFont: [UIFont systemFontOfSize: 13.f]];
    
    [hud showAnimated: YES whileExecutingBlock:^() {
        sleep(2);
    }];
    
    NSLog(@"删除歌曲成功");
    
}

- (void)songLiked
{
    
    [_buttomChoosen removeFromSuperview];
    // 初始化底部控制栏
    CGSize sizeB = self.view.frame.size;
    _buttomChoosen = [[UIView alloc] initWithFrame: CGRectMake((250 / 320.0) * sizeB.width, ((460 - 110) / 416.0) * sizeB.height, sizeB.width, (110 / 416.0) * sizeB.height)];
    //_buttomChoosen = [[UIView alloc] initWithFrame: kButtom_Controll_View];
    
    _buttomChoosen.backgroundColor = [UIColor clearColor];
    
    // 将控制歌曲的三个按钮添加到底部控制栏上
    _likeIcon = [UIButton buttonWithType: UIButtonTypeCustom];
    _delIcon = [UIButton buttonWithType: UIButtonTypeCustom];
    _nextIcon = [UIButton buttonWithType: UIButtonTypeCustom];
    
    if(isLiked) {
        [_likeIcon setImage: [UIImage imageNamed: @"ic_player_fav_selected.png"] forState: UIControlStateNormal];
    } else {
        [_likeIcon setImage: [UIImage imageNamed: @"ic_player_fav.png"] forState: UIControlStateNormal];
    }
    [_delIcon setImage: [UIImage imageNamed: @"ic_player_ban.png"] forState: UIControlStateNormal];
    [_nextIcon setImage: [UIImage imageNamed: @"ic_player_next.png"] forState: UIControlStateNormal];
    
//    _likeIcon.frame = CGRectMake(60, 10, 30+18, 36);
//    _delIcon.frame = CGRectMake(135, 10, 40+8, 36);
//    _nextIcon.frame = CGRectMake(205, 10, 48, 36);
    
    CGSize size = self.view.frame.size;
    CGSize choosenSize = CGSizeMake(size.width, (110 / size.height) * size.height);
    _likeIcon.frame = CGRectMake((60 / 320.0) * choosenSize.width, (10 / 110.0) * choosenSize.height, 48, 36);
    _delIcon.frame = CGRectMake((135 / 320.0) * choosenSize.width,  (10 / 110.0) * choosenSize.height, 48, 36);
    _nextIcon.frame = CGRectMake((205 / 320.0) * choosenSize.width, (10 / 110.0) * choosenSize.height, 48, 36);
    
    // 添加事件
    [_nextIcon addTarget: self action: @selector(btnClickNextSong) forControlEvents: UIControlEventTouchUpInside];
    [_likeIcon addTarget: self action: @selector(btnClickLike) forControlEvents: UIControlEventTouchUpInside];
    [_delIcon addTarget: self action: @selector(btnClickDel) forControlEvents: UIControlEventTouchUpInside];
    
    [_buttomChoosen addSubview: _likeIcon];
    [_buttomChoosen addSubview: _delIcon];
    [_buttomChoosen addSubview: _nextIcon];
    
    [_scrollView addSubview: _buttomChoosen];
}


#pragma mark - 左边View协议部分

- (void) sendChannel: (NSString *) channel
{
    // 将isChannelChanged设为YES
    isChannelChanged = YES;
    
    if([channel intValue] == -10) {   // 未登录的时候点击“红心”频道
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview: hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录后可以收藏歌曲";
        //hud.yOffset = 100.f;
        hud.minSize = CGSizeMake(100.f, 20.f);
        [hud setLabelFont: [UIFont systemFontOfSize: 13.f]];
        
        [hud showAnimated: YES whileExecutingBlock:^() {
            sleep(2);
        }];
        
    } else {
        // 请求数据
        getData.channelId = channel;
        getData.songType = @"n";
        currentChannelId = getData.channelId;
        [getData getSongs];
        
        // 将视图滚出
        [_scrollView setContentOffset: CGPointMake((250 / 320.0) * self.view.frame.size.width, 0) animated: YES];
    }
}

-(void) sendLogin
{
    [self loginNow];
}

#pragma mark - 监听scrollView的滚动
// 优化部分，不在启动时候加载以及请求
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if(isRequestSuccess) {
    if(scrollView.contentOffset.x == 0 && channelView.isChannelShowed == NO) {
        channelView = [[ChannelView alloc] initWithFrame: CGRectMake(0, 0, (250 / 320.0) * self.view.frame.size.width, self.view.frame.size.height + 44 + 20)];
        channelView.delegate = self;
        [_scrollView addSubview: channelView];
        
        [channelView requstData];
        // 初始化时将频道值传过去
        channelView.currentChannelV = currentChannelId;
    }
    //    } else {
    //        return;
    //    }
    // 将导航栏“返回”按钮去掉
    if(scrollView.contentOffset.x == 0) {
        [self removeBackButton];
        btnBack.hidden = YES;
    }
    
    // 滚回来时将导航栏目“返回”按钮重新加回来
    if(scrollView.contentOffset.x == ((250 / 320.0) * self.view.frame.size.width) && [btnBack isHidden]) {
        [self addBackButton];
        btnBack.hidden = NO;
    }
}

#pragma mark - 导航栏表现
-(void) getChannelInfo
{
    [getData ASIGetChannel];
}

-(void) showNavi: (NSString *) navTitle
{
    // 先将已存在的视图移出去
    [navView removeFromSuperview];

    navView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];

    UIImageView *logo = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ic_actionbar_logo.png"]];
    logo.frame = CGRectMake(2+15, 7, 30, 30);
    [navView addSubview: logo];
    logo.userInteractionEnabled = YES;
    
    // 添加手势，使返回按钮点击区域更大
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] init];
    logoTap.numberOfTapsRequired = 1;
    [logoTap addTarget: self action: @selector(logoTapped:)];
    [logo addGestureRecognizer: logoTap];

    logoLabel = [[UILabel alloc] initWithFrame: CGRectMake(35+15, 8+5, 150, 20)];
    logoLabel.text = navTitle;
    [logoLabel setTextColor: [UIColor blackColor]];
    [logoLabel setTextAlignment: NSTextAlignmentLeft];
    logoLabel.backgroundColor = [UIColor clearColor];
    logoLabel.font = [UIFont systemFontOfSize: 16.f];
    [navView addSubview: logoLabel];

    UIButton *btnMore = [UIButton buttonWithType: UIButtonTypeCustom];
    btnMore.frame = CGRectMake(self.view.frame.size.width - 48, 0, 40, self.navigationController.navigationBar.frame.size.height);
    //btnMore.backgroundColor = [UIColor redColor];

    UIImageView *menuIcon = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ic_menu_normal.png"]];
    menuIcon.frame = CGRectMake(12, 10, 24, 24);

    [btnMore addTarget: self action: @selector(btnMoreAction) forControlEvents: UIControlEventTouchUpInside];

    [btnMore addSubview: menuIcon];

    [navView addSubview: btnMore];

    //[self addBackButton];

    [self.navigationController.navigationBar addSubview: navView];
}


-(void) showChannelName: (NSString *) name
{
    name = [name stringByAppendingString: @"MHz"];
    //[UINavigationController navContro: self.navigationController titleName: name];
    
    [self showNavi: name];
    
    [self addBackButton];
    
}

- (void)addBackButton
{
    btnBack = [UIButton buttonWithType: UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 17, self.navigationController.navigationBar.frame.size.height);

    UIImageView *backIcon = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ab_back_holo_light.png"]];
    backIcon.frame = CGRectMake(0, 15, 17, 15);
    [btnBack addSubview: backIcon];

    [btnBack addTarget: self action: @selector(btnBackClick) forControlEvents: UIControlEventTouchUpInside];

    [navView addSubview: btnBack];

}

- (void)removeBackButton
{
    [btnBack removeFromSuperview];
}

#pragma mark - 导航栏按钮事件
-(void) btnMoreAction
{
    MoreVC *more = [[MoreVC alloc] init];
    [self.navigationController pushViewController: more animated: YES];
}

- (void)btnBackClick
{
    [_scrollView setContentOffset: CGPointMake(0, 0) animated: YES];
}

- (void)logoTapped:(UITapGestureRecognizer *)tap
{
    [self btnBackClick];
}

#pragma mark - 网络判断
-(void) networkJudge
{
    Reachability *reach = [Reachability reachabilityWithHostName: @"www.baidu.com"];
    if([reach currentReachabilityStatus] == NotReachable) {
        // 没有网络连接
        
        // 设置连接状态为0
        reachStatu = 0;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: self.view animated: YES];
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络不可用，请检查网络连接";
        hud.yOffset = 80.f;
        hud.xOffset = 250.f;
        hud.minSize = CGSizeMake(132.f, 50.f);
        [hud hide: YES afterDelay: 3];
        
        MBProgressHUD *hudLoad = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview: hudLoad];
        hudLoad.mode = MBProgressHUDModeIndeterminate;
        
        // 指定距离中心点的x轴和y轴的偏移量
        hudLoad.yOffset = -80.f;
        [hudLoad showAnimated: YES whileExecutingBlock:^() {
            sleep(INT_MAX);
        } completionBlock:^() {
            //[hud removeFromSuperview];
        }];
        
        NSLog(@"没有网络连接");
        
    } else if([reach currentReachabilityStatus] == ReachableViaWWAN) {
        // 使用3G网络
        
        // 设置连接状态为1
        reachStatu = 1;
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil message: @"当前使用3G网络，这将耗费流量，是否确定？" delegate: self cancelButtonTitle: @"取消" otherButtonTitles: @"确定", nil];
        //        [alert show];
        
        NSLog(@"正在使用3G网络");
        
    } else if([reach currentReachabilityStatus] == ReachableViaWiFi) {
        // 使用WIFI
        // 所有请求都是在有WIFI情况下进行的
        NSLog(@"正在使用WIFI连接");
        
        // 设置连接状态为2
        reachStatu = 2;
        
    }
}

#pragma mark - 登录相关
-(void) loginNow
{
    loginPage = [[LoginVC alloc] init];
    [self.navigationController pushViewController: loginPage animated: YES];
}

#pragma mark - 实现UIAlertViewDelegate
// 3G情况下，会弹出流量警告框，点击“确定”所实现的方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {  // 确定按钮
        reachStatu = 2;
        [self workOnWifi];
    }
}

#pragma mark - wifi情境下实现网络请求，再3g情境下，由用户确定亦能触发
- (void)workOnWifi
{
    // 频道判断
    if([sqliteData isDefaultChannel]) {   // 有默认频道
        currentChannelId = [sqliteData defaultChannel];
    } else {
        currentChannelId = @"0";
    }
    
    // 数据请求
    getData = [[GetData alloc] init];
    getData.songType = @"n";
    getData.songSid = @"0";
    getData.channelId = currentChannelId;
    getData.delegate = self;
    [getData getSongs];
    
//    // 暂停图标
//    _btnPause = [UIButton buttonWithType: UIButtonTypeCustom];
//    //_btnPause.frame = CGRectMake(180, 285, 15, 15);
//    //_btnPause.frame = CGRectMake(250+180, 285, 15, 15);
//    CGSize size = self.view.frame.size;
//    _btnPause.frame = CGRectMake(((250 + 180) / 320.0) * size.width, _currentTime.frame.origin.y, 15, (15 / 460.0) * size.height);
//    [_btnPause setImage: [UIImage imageNamed: @"pause_a.png"] forState: UIControlStateNormal];
//    [_btnPause addTarget: self action: @selector(pauseSong) forControlEvents: UIControlEventTouchUpInside];
//    pause = NO;
//    
//    //[self.view addSubview: _btnPause];
//    [_scrollView addSubview: _btnPause];
    
    // 时间
    _currentTime.text = @"";    // 作用上面有说明
    //_currentTime = [[UILabel alloc] initWithFrame: CGRectMake(250+70, 285, 100, 15)];
    CGSize size = self.view.frame.size;
    _currentTime = [[UILabel alloc] init];
    _currentTime.frame = CGRectMake((320 / 320.0) * size.width, (285 / 460.0) * size.height, (100 / 320.0) * size.width, (15 / 460.0) * size.height);
    //_currentTime = [[UILabel alloc] initWithFrame: kSongTimeSize];
    _currentTime.backgroundColor = [UIColor clearColor];
    
    // 暂停图标
    _btnPause = [UIButton buttonWithType: UIButtonTypeCustom];
    //_btnPause.frame = CGRectMake(180, 285, 15, 15);
    //_btnPause.frame = CGRectMake(250+180, 285, 15, 15);
    _btnPause.frame = CGRectMake(((250 + 180) / 320.0) * size.width, _currentTime.frame.origin.y, 15, (15 / 460.0) * size.height);
    [_btnPause setImage: [UIImage imageNamed: @"pause_a.png"] forState: UIControlStateNormal];
    [_btnPause addTarget: self action: @selector(pauseSong) forControlEvents: UIControlEventTouchUpInside];
    pause = NO;
    
    //[self.view addSubview: _btnPause];
    [_scrollView addSubview: _btnPause];
    
    // 将isRequestSuccess的值设为true
    isRequestSuccess = YES;
    
    // 将isChannelChanged设为true
    isChannelChanged = YES;
    
}











#pragma mark - 手势部分（未启用）
/*
 -(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 NSLog(@"touch moved");
 UITouch *touch = [touches anyObject];
 }
 
 -(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 NSLog(@"touch begin");
 }
 
 -(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 NSLog(@"touch end");
 }
 
 -(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
 {
 NSLog(@"touch cancel");
 }
 */


@end
