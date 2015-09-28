//
//  ChannelView.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "ChannelView.h"
#import "Common.h"

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
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        return 3;
    } else {
        return _channelArray.count % 2 + _channelArray.count / 2;
    }
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        static NSString *CellIdentifier = @"cell";
        ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if(cell == nil) {
            cell = [[ChannelCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            cell.delegate = self;
            
            // 数据给数组
            if(!sectionOneArray) {
                sectionOneArray = [NSMutableArray array];
            }
            
            ModelPro *favoriteChannel = [[ModelPro alloc] init];
            favoriteChannel.channelName = @"红心";
            favoriteChannel.channelId = @"-3";
            
            [sectionOneArray addObject: _channelArray[0]];
            [sectionOneArray addObject: favoriteChannel];
        }
        
        // 清空视图
        for(UIView *temp in cell.contentView.subviews) {
            [temp removeFromSuperview];
            if([temp isKindOfClass: [ChannelButton class]]) {
                for(UIView *tempImage in temp.subviews) {
                    if([tempImage isKindOfClass: [UIImageView class]]) {
                        [tempImage removeFromSuperview];
                    }
                }
            }
        }
        
        // 设置数据
        [cell setItem: sectionOneArray atIndex: indexPath];
        
        return cell;
        
    } else if(indexPath.section == 1) {
        static NSString *CellIdentifier = @"sectionTwoCell";
        ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if(cell == nil) {
            cell = [[ChannelCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            cell.delegate = self;
            
            // 添加数据给数组
            if(!sectionTwoArray) {
                sectionTwoArray = [NSMutableArray array];
            }
            
            // 选6个频道作为推荐
            [sectionTwoArray addObject: _channelArray[9]];
            [sectionTwoArray addObject: _channelArray[10]];
            [sectionTwoArray addObject: _channelArray[12]];
            [sectionTwoArray addObject: _channelArray[19]];
            [sectionTwoArray addObject: _channelArray[35]];
            [sectionTwoArray addObject: _channelArray[21]];
            
        }
        
        // 清空数据
        for(UIView *temp in cell.contentView.subviews) {
            [temp removeFromSuperview];
            if([temp isKindOfClass: [ChannelButton class]]) {
                for(UIView *tempImage in temp.subviews) {
                    if([tempImage isKindOfClass: [UIImageView class]]) {
                        [tempImage removeFromSuperview];
                    }
                }
            }
        }
        
        // 设置数据
        [cell setItem: sectionTwoArray atIndex: indexPath];

        return cell;
        
    } else {
        static NSString *CellIdentifier = @"mainCell";
        ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if(cell == nil) {
            cell = [[ChannelCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
            cell.delegate = self;
        }
        
        // 清空cell
        for(UIView *temp in cell.contentView.subviews) {
            [temp removeFromSuperview];
            if([temp isKindOfClass: [ChannelButton class]]) {
                for(UIView *tempImage in temp.subviews) {
                    if([tempImage isKindOfClass: [UIImageView class]]) {
                        [tempImage removeFromSuperview];
                    }
                }
            }
        }
        
        // 设置cell
        [cell setItem: _channelArray atIndex: indexPath];
        
        return cell;
        
    }
}

#pragma mark - SendData Delegate接收请求完成后的数据

-(void) sendChannelData: (NSArray *) array
{
    _channelArray = [NSMutableArray arrayWithArray: array];
    //NSLog(@"channel is:%@",_channelArray);
    
    // 初始化表视图
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20 - 44) style: UITableViewStylePlain];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, _tableView.frame.size.height);
    
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed: 42/255.f green: 42/255.f blue: 42/255.f alpha: 1];
    
    // 设置代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_scrollView addSubview: _tableView];
    
    // 将列表设置为真
    isChannelShowed = YES;
}

#pragma mark - 按钮点击事件
- (void)channelCell:(ChannelCell *)cell buttonClicked:(ChannelButton *)button
{
    if((![sqliteDataV isLogin]) && button.tag == -3) {
        NSLog(@"current channel is:%@",_currentChannelV);
        [_delegate sendChannel: @"-10"];
    } else {
        // 先将其它按钮上的图标去掉
        [_tableView reloadData];
        
        // 将“正在播放”图标加在所选频道上
        [button setIsPlaying: YES];
        
        // 每次点击，都将此次点击的频道设置为默认频道
        //sqliteDataV = [[DoubanFMData alloc] init];
        
        // 切换频道
        [self changeToChannnel: [NSString stringWithFormat: @"%ld", (long)button.tag]];
        
    }
}

// 点击“未登录用户”后，推到登录页面
-(void) loginNowV
{
    [_delegate sendLogin];
}

// 刷新表格
-(void) relodTable
{
    [_tableView reloadData];
}

// 类方法，取得当前正在播放的频道
+ (NSString *)currentPlayingChannel
{
    DoubanFMData *data = [[DoubanFMData alloc] init];
    return [data defaultChannel];
}

// 切换频道
- (void)changeToChannnel:(NSString *)channel
{
    NSString *channelSend = channel;
    
    if([sqliteDataV isDefaultChannel]) {
        [sqliteDataV changeChannel: channelSend];
    } else {
        [sqliteDataV addChannel: channelSend];
    }
    
    [_delegate sendChannel: channelSend];
    
    _currentChannelV = channelSend;
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
