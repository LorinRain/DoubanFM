//
//  ChannelView.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "ChannelView.h"

@implementation ChannelView

@synthesize delegate = _delegate;

@synthesize channelArray = _channelArray;

@synthesize isChannelShowed;
@synthesize currentChannelV = _currentChannelV;

@synthesize uName = _uName;

//@synthesize isLogin;

//@synthesize userNameText = _userNameText;

@synthesize userNameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 初始化scrollview
        _scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        [self addSubview: _scrollView];
        
        _scrollView.backgroundColor = [UIColor colorWithRed: 42/255.f green: 42/255.f blue: 42/255.f alpha: 1];
        
        NSLog(@"Enter the View");
        
        // 初始化的时候将这个键设为no，在左右滚动时，只有当这个值为no时才请求数据
        isChannelShowed = NO;
        
        // 初始化数组
        btnAll = [[NSMutableArray alloc] init];
        btnClicked = NO;
        
    }
    return self;
}

-(void) requstData
{
    // 请求频道
    getData = [[GetData alloc] init];
    getData.delegate = self;
    [getData ASIGetChannel];
    
    // 请求登录信息
    sqliteDataV = [[DoubanFMData alloc] init];
    
}

#pragma mark - UITableView Delegate数据源协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if(section == 0) {
        height = 35;
    } else {
        height = 30;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    if(section == 0) {
        
        UIImageView *login = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"login_icon.png"]];
        login.frame = CGRectMake(5, 8, 16, 16);
        
        //if() // 在此判断是否登录
        if([sqliteDataV isLogin]){
            userNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(30, 8, 150, 20)];
            userNameLabel.text = [sqliteDataV defaultUserInfo: @"userName"];
            [userNameLabel setTextColor: [UIColor colorWithRed: 152/255.f green: 156/255.f blue: 158/255.f alpha: 1]];
            [userNameLabel setFont: [UIFont systemFontOfSize: 14.f]];
            userNameLabel.backgroundColor = [UIColor clearColor];
            
            [headerView addSubview: userNameLabel];
            
        } else {
            
            UIButton *btnLogin = [UIButton buttonWithType: UIButtonTypeCustom];
            btnLogin.frame = CGRectMake(25, 8, 100, 20);
            [btnLogin setTitle: @"未登录用户" forState: UIControlStateNormal];
            [btnLogin setTitleColor: [UIColor colorWithRed: 152/255.f green: 156/255.f blue: 158/255.f alpha: 1] forState: UIControlStateNormal];
            btnLogin.titleLabel.font = [UIFont systemFontOfSize: 15.f];
            
            [btnLogin addTarget: self action: @selector(loginNowV) forControlEvents: UIControlEventTouchUpInside];
            
            //headerView.backgroundColor = [UIColor colorWithRed: 42/255.f green: 42/255.f blue: 42/255.f alpha: 1];
            
            [headerView addSubview: btnLogin];
            
        }
        
        headerView.backgroundColor = [UIColor colorWithRed: 42/255.f green: 42/255.f blue: 42/255.f alpha: 1];
        [headerView addSubview: login];
        
    } else if(section == 1) {
        
        UILabel *recommanChannel = [[UILabel alloc] initWithFrame: CGRectMake(10, 5, 200, 20)];
        [recommanChannel setTextAlignment: NSTextAlignmentLeft];
        recommanChannel.text = @"推荐兆赫";
        [recommanChannel setTextColor: [UIColor colorWithRed: 152/255.f green: 156/255.f blue: 158/255.f alpha: 1]];
        recommanChannel.backgroundColor = [UIColor clearColor];
        [recommanChannel setFont: [UIFont systemFontOfSize: 15.f]];
        
        headerView.backgroundColor = [UIColor colorWithRed: 42/255.f green: 42/255.f blue: 42/255.f alpha: 1];
        
        [headerView addSubview: recommanChannel];
        
    } else if(section == 2) {
        
        UILabel *hotChannel = [[UILabel alloc] initWithFrame: CGRectMake(10, 5, 200, 20)];
        [hotChannel setTextAlignment: NSTextAlignmentLeft];
        hotChannel.text = @"所有兆赫";
        [hotChannel setTextColor: [UIColor colorWithRed: 152/255.f green: 156/255.f blue: 158/255.f alpha: 1]];
        hotChannel.backgroundColor = [UIColor clearColor];
        [hotChannel setFont: [UIFont systemFontOfSize: 15.f]];
        
        headerView.backgroundColor = [UIColor colorWithRed: 42/255.f green: 42/255.f blue: 42/255.f alpha: 1];
        
        [headerView addSubview: hotChannel];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    if(indexPath.section == 0) {
        rowHeight = 100;
    } else if(indexPath.section == 1) {
        rowHeight = 280;
    } else if(indexPath.section == 2) {
        //rowHeight = 200;
        CGFloat temp = ([_channelArray count] / 2) * 80 + (([_channelArray count] / 2) - 1) * 10 + 15;
        //CGFloat temp = ([_channelArray count] - 7) * 80 + (([_channelArray count] - 7) - 1) * 10 + 15;
        rowHeight = temp;
    }
    
    return rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithRed: 42/255.f green: 42/255.f blue: 42/255.f alpha: 1];
    
    if(indexPath.section == 0) {
        
        //---------------------Button样式-------------------------
        UIButton *btnPersonal = [UIButton buttonWithType: UIButtonTypeCustom];
        btnPersonal.frame = CGRectMake(5, 5, 115, 80);
        btnPersonal.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
        [btnPersonal setTitle: @"私人" forState: UIControlStateNormal];   // 频道号0
        btnPersonal.titleLabel.font = [UIFont systemFontOfSize: 14.f];
        [btnPersonal setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 40, 60)];
        [cell addSubview: btnPersonal];
        btnPersonal.tag = 0;
        
        // 下面这个if方法用于修复点击了一个按钮图片已经加载上去了，但在将tableview上下滚动时，再回到这个按钮，图片会消失的bug。因为tableview每次滚动都会进来调用，所以再这里设置一个判断点，让tableview回来时图标依然在。下面的类似此判断语句作用相同
        if(btnPersonal.tag == btnTag && btnClicked == YES) {
            [self setPlayingIcon: btnPersonal];
        }
        
        // 下面这个if语句用于修复：退出时设置了按钮对应频道为默认频道（自动设置），再次进入应用时，该按钮能正确显示正在播放图标，但是再换其它频道后，该按钮上的图标没有清除。的bug。下面类似此判断的语句作用相同
        if((btnPersonal.tag == [_currentChannelV intValue]) && btnClicked == NO) {
            [self setPlayingIcon: btnPersonal];
        }
        
        [btnPersonal addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
        
        //channels = [[ModelPro alloc] init];
        //channels = [_channelArray objectAtIndex: 0];
        
        [btnAll addObject: btnPersonal];
        
        //[btnPersonal addTarget: self action: @selector(btnClick) forControlEvents: UIControlEventTouchUpInside];
        
        UIButton *btnLike = [UIButton buttonWithType: UIButtonTypeCustom];
        btnLike.frame = CGRectMake(130, 5, 115, 80);
        btnLike.backgroundColor = [UIColor colorWithRed: 224/255.f green: 107/255.f blue: 89/255.f alpha: 1];
        [btnLike setTitle: @"红心" forState: UIControlStateNormal];
        btnLike.titleLabel.font = [UIFont systemFontOfSize: 14.f];
        [btnLike setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 40, 60)];
        [cell addSubview: btnLike];
        
        btnLike.tag = -3;
        if(btnLike.tag == btnTag && btnClicked == YES) {
            [self setPlayingIcon: btnLike];
        }
        
        if(btnLike.tag == [_currentChannelV intValue] && btnClicked == NO) {
            [self setPlayingIcon: btnLike];
        }
        
        [btnLike addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
        
        [btnAll addObject: btnLike];
        
    } else if(indexPath.section == 1) {
        
        // 固定6个按钮
        
        ModelPro *commChannel1 = [[ModelPro alloc] init];
        commChannel1 = [_channelArray objectAtIndex: 9];
        
        UIButton *btnComm1 = [UIButton buttonWithType: UIButtonTypeCustom];
        btnComm1.frame = CGRectMake(5, 5, 115, 80);
        btnComm1.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
        [btnComm1 setTitle: commChannel1.channelName forState: UIControlStateNormal];   // 频道号9
        btnComm1.titleLabel.font = [UIFont systemFontOfSize: 14.f];
        [btnComm1 setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 40, 60)];
        [cell addSubview: btnComm1];
        btnComm1.tag = [commChannel1.channelId intValue];
        
        if(btnComm1.tag == btnTag && btnClicked == YES) {
            [self setPlayingIcon: btnComm1];
        }
        
        if((btnComm1.tag == [_currentChannelV intValue]) && btnClicked == NO) {
            [self setPlayingIcon: btnComm1];
        }
        
        [btnComm1 addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
        
        
        ModelPro *commChannel2 = [[ModelPro alloc] init];
        commChannel2 = [_channelArray objectAtIndex: 10];
        
        UIButton *btnComm2 = [UIButton buttonWithType: UIButtonTypeCustom];
        btnComm2.frame = CGRectMake(130, 5, 115, 80);
        btnComm2.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
        [btnComm2 setTitle: commChannel2.channelName forState: UIControlStateNormal];     // 频道号10
        btnComm2.titleLabel.font = [UIFont systemFontOfSize: 14.f];
        [btnComm2 setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 40, 60)];
        [cell addSubview: btnComm2];
        btnComm2.tag = [commChannel2.channelId intValue];
        
        if(btnComm2.tag == btnTag && btnClicked == YES) {
            [self setPlayingIcon: btnComm2];
        }
        
        if((btnComm2.tag == [_currentChannelV intValue]) && btnClicked == NO) {
            [self setPlayingIcon: btnComm2];
        }
        
        [btnComm2 addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
        
        ModelPro *commChannel3 = [[ModelPro alloc] init];
        commChannel3 = [_channelArray objectAtIndex: 12];  // 在数组中的位置与频道号不一定相同
        
        UIButton *btnComm3 = [UIButton buttonWithType: UIButtonTypeCustom];
        btnComm3.frame = CGRectMake(5, 95, 115, 80);
        btnComm3.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
        [btnComm3 setTitle: commChannel3.channelName forState: UIControlStateNormal];     //  频道号14
        btnComm3.titleLabel.font = [UIFont systemFontOfSize: 14.f];
        [btnComm3 setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 40, 60)];
        [cell addSubview: btnComm3];
        btnComm3.tag = [commChannel3.channelId intValue];
        
        if(btnComm3.tag == btnTag && btnClicked == YES) {
            [self setPlayingIcon: btnComm3];
        }
        
        if((btnComm3.tag == [_currentChannelV intValue]) && btnClicked == NO) {
            [self setPlayingIcon: btnComm3];
        }
        
        [btnComm3 addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
        
        ModelPro *commChannel4 = [[ModelPro alloc] init];
        commChannel4 = [_channelArray objectAtIndex: 19];
        
        UIButton *btnComm4 = [UIButton buttonWithType: UIButtonTypeCustom];
        btnComm4.frame = CGRectMake(130, 95, 115, 80);
        btnComm4.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
        [btnComm4 setTitle: commChannel4.channelName forState: UIControlStateNormal];     // 频道号27
        btnComm4.titleLabel.font = [UIFont systemFontOfSize: 14.f];
        [btnComm4 setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 40, 60)];
        [cell addSubview: btnComm4];
        btnComm4.tag = [commChannel4.channelId intValue];
        
        if(btnComm4.tag == btnTag && btnClicked == YES) {
            [self setPlayingIcon: btnComm4];
        }
        
        if((btnComm4.tag == [_currentChannelV intValue]) && btnClicked == NO) {
            [self setPlayingIcon: btnComm4];
        }
        
        [btnComm4 addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
        
        ModelPro *commChannel5 = [[ModelPro alloc] init];
        commChannel5 = [_channelArray objectAtIndex: 35];
        
        UIButton *btnComm5 = [UIButton buttonWithType: UIButtonTypeCustom];
        btnComm5.frame = CGRectMake(5, 185, 115, 80);
        btnComm5.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
        [btnComm5 setTitle: commChannel5.channelName forState: UIControlStateNormal];     // 频道号76
        btnComm5.titleLabel.font = [UIFont systemFontOfSize: 14.f];
        [btnComm5 setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 40, 60)];
        [cell addSubview: btnComm5];
        btnComm5.tag = [commChannel5.channelId intValue];
        
        if(btnComm5.tag == btnTag && btnClicked == YES) {
            [self setPlayingIcon: btnComm5];
        }
        
        if((btnComm5.tag == [_currentChannelV intValue]) && btnClicked == NO) {
            [self setPlayingIcon: btnComm5];
        }
        
        [btnComm5 addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
        
        ModelPro *commChannel6 = [[ModelPro alloc] init];
        commChannel6 = [_channelArray objectAtIndex: 21];
        
        UIButton *btnComm6 = [UIButton buttonWithType: UIButtonTypeCustom];
        btnComm6.frame = CGRectMake(130, 185, 115, 80);
        btnComm6.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
        [btnComm6 setTitle: commChannel6.channelName forState: UIControlStateNormal];    // 频道号32
        btnComm6.titleLabel.font = [UIFont systemFontOfSize: 14.f];
        [btnComm6 setTitleEdgeInsets: UIEdgeInsetsMake(0, 0, 40, 60)];
        [cell addSubview: btnComm6];
        btnComm6.tag = [commChannel6.channelId intValue];
        
        if(btnComm6.tag == btnTag && btnClicked == YES) {
            [self setPlayingIcon: btnComm6];
        }
        
        if((btnComm6.tag == [_currentChannelV intValue]) && btnClicked == NO) {
            [self setPlayingIcon: btnComm6];
        }
        
        [btnComm6 addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
        
        [btnAll addObject: btnComm1];
        [btnAll addObject: btnComm2];
        [btnAll addObject: btnComm3];
        [btnAll addObject: btnComm4];
        [btnAll addObject: btnComm5];
        [btnAll addObject: btnComm6];
        
    } else if(indexPath.section == 2) {
        // 动态加载按钮
        
        int j = 0;
        int m = 0;
        
        // 加载左边的按钮
        for(int i = 0; i < [_channelArray count] && i % 2 == 0; i = i + 2) {
            UIButton *btnAllLeft = [UIButton buttonWithType: UIButtonTypeCustom];
            
            channels = [[ModelPro alloc] init];
            if(i == [_channelArray count] - 1) {
                return cell;
            } else {
                channels = [_channelArray objectAtIndex: i+1];
            }
            
            NSString *btnNameLeft = channels.channelName;
            
            btnAllLeft.frame = CGRectMake(5, 5 + j*90, 115, 80);
            btnAllLeft.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
            
            UILabel *btnLeftTitlte = [[UILabel alloc] initWithFrame: CGRectMake(5, 0, 80, 40)];
            btnLeftTitlte.numberOfLines = 0;
            btnLeftTitlte.text = btnNameLeft;
            [btnLeftTitlte setFont: [UIFont systemFontOfSize: 14.f]];
            btnLeftTitlte.backgroundColor = [UIColor clearColor];
            btnLeftTitlte.textColor = [UIColor whiteColor];
            [btnAllLeft addSubview: btnLeftTitlte];
            
            btnAllLeft.tag = [channels.channelId intValue];
            
            if(btnAllLeft.tag == btnTag && btnClicked == YES) {
                [self setPlayingIcon: btnAllLeft];
            }
            
            if((btnAllLeft.tag == [_currentChannelV intValue]) && btnClicked == NO) {
                [self setPlayingIcon: btnAllLeft];
            }
            
            [cell addSubview: btnAllLeft];
            j++;
            
            [btnAllLeft addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
            
            [btnAll addObject: btnAllLeft];
            
            if(i == [_channelArray count] - 2) {
                // 加载右边的按钮
                for(int j = 1; j < [_channelArray count] && j % 2 == 1; j = j + 2) {
                    UIButton *btnAllRight = [UIButton buttonWithType: UIButtonTypeCustom];
                    
                    channels = [[ModelPro alloc] init];
                    if(j == [_channelArray count] - 1) {
                        return cell;
                    } else {
                        channels = [_channelArray objectAtIndex: j+1];
                    }
                    
                    NSString *btnNmaeRight = channels.channelName;
                    
                    btnAllRight.frame = CGRectMake(130, 5 + m*90, 115, 80);
                    btnAllRight.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
                    
                    UILabel *btnRightTitlte = [[UILabel alloc] initWithFrame: CGRectMake(5, 0, 80, 40)];
                    btnRightTitlte.numberOfLines = 0;
                    btnRightTitlte.text = btnNmaeRight;
                    [btnRightTitlte setFont: [UIFont systemFontOfSize: 14.f]];
                    btnRightTitlte.backgroundColor = [UIColor clearColor];
                    btnRightTitlte.textColor = [UIColor whiteColor];
                    [btnAllRight addSubview: btnRightTitlte];
                    
                    btnAllRight.tag = [channels.channelId intValue];
                    
                    if(btnAllRight.tag == btnTag && btnClicked == YES) {
                        [self setPlayingIcon: btnAllRight];
                    }
                    
                    if((btnAllRight.tag == [_currentChannelV intValue]) && btnClicked == NO) {
                        [self setPlayingIcon: btnAllRight];
                    }
                    
                    [cell addSubview: btnAllRight];
                    m++;
                    
                    [btnAllRight addTarget: self action: @selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
                    
                    [btnAll addObject: btnAllRight];
                    
                }
            }
            
        }
        
        
    }
    
    return cell;
}

#pragma mark - SendData Delegate接收请求完成后的数据

-(void) sendChannelData: (NSArray *) array
{
    _channelArray = array;
    //NSLog(@"channel is:%@",_channelArray);
    
    // 初始化表视图
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20 - 44) style: UITableViewStylePlain];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, _tableView.frame.size.height);
    
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    
    // 设置代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_scrollView addSubview: _tableView];
    
    // 将列表设置为真
    isChannelShowed = YES;
}

#pragma mark - 按钮点击事件
-(void) btnClick: (UIButton *) button
{
    // 设置按钮为点击
    btnClicked = YES;
    
    NSLog(@"tag is:%d",button.tag);
    
    if((![sqliteDataV isLogin]) && button.tag == -3) {
        btnTag = [_currentChannelV intValue];
        
        NSLog(@"current channel is:%@",_currentChannelV);
        [_delegate sendChannel: @"-10"];
    } else {
        // 先将其它按钮上的图标去掉
        [self cleanOtherIcon: button];
        btnTag = button.tag;
        
        // 将“正在播放”图标加在所选频道上
        [self setPlayingIcon: button];
        
        // 每次点击，都将此次点击的频道设置为默认频道
        //sqliteDataV = [[DoubanFMData alloc] init];
        
        NSString *channelSend = [NSString stringWithFormat: @"%d",button.tag];
        
        if([sqliteDataV isDefaultChannel]) {
            [sqliteDataV changeChannel: channelSend];
        } else {
            [sqliteDataV addChannel: channelSend];
        }
        
        [_delegate sendChannel: channelSend];
        
        _currentChannelV = channelSend;
    }
    
}

// 点击“未登录用户”后，推到登录页面
-(void) loginNowV
{
    [_delegate sendLogin];
}


-(void) setPlayingIcon: (UIButton *) btn
{
    UIImage *img1 = [UIImage imageNamed: @"channel_nowplaying1.png"];
    UIImage *img2 = [UIImage imageNamed: @"channel_nowplaying2.png"];
    UIImage *img3 = [UIImage imageNamed: @"channel_nowplaying3.png"];
    UIImage *img4 = [UIImage imageNamed: @"channel_nowplaying4.png"];
    
    NSArray *imgs = [NSArray arrayWithObjects: img1, img2,img3, img4, nil];
    //    [btn setImage: img forState: UIControlStateNormal];
    //    [btn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 40, -100)];
    imgView = [[UIImageView alloc] initWithImage: img1];
    imgView.frame = CGRectMake(115-12-10, 10, 12, 12);
    imgView.animationImages = imgs;
    imgView.animationDuration = 0.6f;
    [imgView startAnimating];
    [btn addSubview: imgView];
    [btnAll addObject: btn];
}

-(void) cleanOtherIcon: (UIButton *) btn
{
    for(int i = 0; i < [btnAll count]; i++) {
        btn = [btnAll objectAtIndex: i];
        //[btn setImage: nil forState: UIControlStateNormal];
        [imgView removeFromSuperview];
    }
    
}

// 刷新表格
-(void) relodTable
{
    [_tableView reloadData];
}








/*
 * 关于登录
 * 目的：更好的发现用户的喜好，支持“喜欢”和“删除”功能，另外“删除”功能仅在“私人兆赫”有效。非登录用户同样可以体验app的核心功能，并提供所有电台
 * 验证过程：在进入频道界面时，检查是否已经登录（数据库）
 * 视图表现：如果未登录，表头显示”未登录用户“，并且可以点击，点击进入登录界面。如果已登录，表头显示用户的昵称”userName“，不能点击。并且第一个section显示除两个固定的频道外，还显示用户对应收藏的频道（接口？）（由于接口未开放，暂不能完成收藏功能）
 * 登录过程：未登录用户在进入登录界面后，接收用户输入的用户名和密码，发出网络请求。如果验证成功，则将用户的一些信息写入数据库，在请求歌曲的时候，将这些参数带入。如果验证不成功，返回错误信息。
 *
 *
 */





/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
