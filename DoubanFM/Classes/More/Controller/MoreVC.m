//
//  MoreVC.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "MoreVC.h"
#import "MorePageCell.h"
#import "LoginVC.h"
#import "DoubanHelpVC.h"
#import "AboutVC.h"

@interface MoreVC ()

@end

@implementation MoreVC

@synthesize loginInfo = _loginInfo;
@synthesize loginDetail = _loginDetail;
@synthesize isChecked;

- (void)loadView
{
    [super loadView];
    self.view.frame = [UIScreen mainScreen].applicationFrame;
}

#pragma mark - ViewLifeCycle
-(void) viewDidLoad
{
    [super viewDidLoad];
    
    if(DeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed: 232/255.f green: 238/255.f blue: 234/255.f alpha: 1];
    
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
    logoLabel.text = @"豆瓣FM";
    [logoLabel setTextColor: [UIColor blackColor]];
    [logoLabel setTextAlignment: NSTextAlignmentLeft];
    logoLabel.backgroundColor = [UIColor clearColor];
    logoLabel.font = [UIFont systemFontOfSize: 16.f];
    [navView addSubview: logoLabel];
    
    //[self.navigationController.navigationBar addSubview: navView];
    
    
    // 初始化表视图
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style: UITableViewStylePlain];
    _tableView.backgroundColor = self.view.backgroundColor;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview: _tableView];
    
    // 初始化数据库查询对象
    sqlData = [[DoubanFMData alloc] init];
    
    isChecked = NO;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 刷新表格
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [navView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview: navView];
}


#pragma mark - UITableViewDatasource数据源、协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRow;
    if(section == 0) {
        numOfRow = 1;
    }
    
    if(section == 1) {
        numOfRow = 1;
    }
    
    if(section == 2) {
        numOfRow = 3;
    }
    
    return numOfRow;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        [self headerView: @"账户"];
    }
    
    if(section == 1) {
        [self headerView: @"收听设置"];
    }
    
    if(section == 2) {
        [self headerView: @"其他"];
    }
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    MorePageCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if(cell == nil) {
        cell = [[MorePageCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
    }
    
    //cell.contentView.backgroundColor = [UIColor colorWithRed: 232/255.f green: 238/255.f blue: 234/255.f alpha: 1];
    
    // 设置点击表格时不显示蓝条
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0) {
        
        if([sqlData isLogin]) {
            _loginInfo = [sqlData defaultUserInfo: @"userName"];
            _loginDetail = @"豆瓣fm用户";
        } else {
            _loginInfo = @"登录豆瓣FM";
            _loginDetail = @"登陆后即可在全平台同步收听体验";
        }
        
        cell.textLabel.text = _loginInfo;
        cell.detailTextLabel.text = _loginDetail;
        cell.normalLabel.hidden = YES;
        cell.checkImg.hidden = YES;
        cell.cellImg.hidden = YES;
    }
    
    if(indexPath.section == 1) {
        cell.normalLabel.text = @"3G下在线收听";
        if(isChecked) {
            
            cell.checkImg.image = [UIImage imageNamed: @"ab_share_pack.png"];   // @"ab_share_pack.png"
            [self checkIt: cell];
            
        } else {
            cell.checkImg.image = [UIImage imageNamed: @"ab_share_pack.png"];
        }
        cell.cellImg.hidden = YES;
    }
    
    if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            cell.normalLabel.text = @"豆瓣应用推荐";
        }
        
        if(indexPath.row == 1) {
            cell.normalLabel.text = @"使用帮助";
        }
        
        if(indexPath.row == 2) {
            cell.normalLabel.text = @"关于豆瓣FM";
        }
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中行
    //_tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    if(indexPath.section == 0) {
        if(![sqlData isLogin]) {
            LoginVC *login = [[LoginVC alloc] init];
            [self.navigationController pushViewController: login animated: YES];
        } else {
            
            [self showLogoutView];
        }
    }
    
    if(indexPath.section == 1) {
        if(isChecked) {
            [self unCheckIt];
            isChecked = NO;
        } else {
            isChecked = YES;
            [_tableView reloadData];
        }
    }
    
    if(indexPath.section == 2) {
        
        if(indexPath.row == 0) {
            DoubanHelpVC *apps = [[DoubanHelpVC alloc] init];
            apps.urlString = @"https://itunes.apple.com/cn/artist/douban-inc./id353732575";
            apps.navTitle = @"豆瓣应用推荐";
            [self.navigationController pushViewController: apps animated: YES];
            
        } else if(indexPath.row == 1) {
            DoubanHelpVC *help = [[DoubanHelpVC alloc] init];
            help.urlString = @"http://douban.fm/support";
            help.navTitle = @"帮助";
            [self.navigationController pushViewController: help animated: YES];
            
        } else if(indexPath.row == 2) {
            AboutVC *about = [[AboutVC alloc] init];
            [self.navigationController pushViewController: about animated: YES];
        }
        
    }
}




- (UIView *) headerView: (NSString *)headerTitle
{
    headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *headertLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 5, 100, 20)];
    headertLabel.text = headerTitle;
    headertLabel.backgroundColor = [UIColor clearColor];
    [headertLabel setFont: [UIFont boldSystemFontOfSize: 14.f]];   // 加粗显示
    
    UIImageView *headerSeper = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"line.png"]];
    headerSeper.frame = CGRectMake(10, 30, self.view.frame.size.width - 20, 10);
    
    headerView.backgroundColor = self.view.backgroundColor;
    
    [headerView addSubview: headertLabel];
    [headerView addSubview: headerSeper];
    
    
    return headerView;
}

- (void)checkIt: (UITableViewCell *) cellC
{
    check = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"ic_cab_done.png"]];
    check.frame = CGRectMake(320 - 30 - 26, (60 - 30) / 2 - 5, 25, 25);
    [cellC addSubview: check];
}

- (void)unCheckIt
{
    [check removeFromSuperview];
}

- (void)showLogoutView
{
    logoutView = [[UIView alloc] initWithFrame: CGRectMake(20, (self.view.frame.size.height - 120) / 2 - 30, self.view.frame.size.width - 40, 120)];
    
    logoutView.backgroundColor = [UIColor whiteColor];
    
    UILabel *logoutTips = [[UILabel alloc] initWithFrame: CGRectMake(10, 5, logoutView.frame.size.width - 30, 25)];
    logoutTips.text = @"退出登录？";
    [logoutTips setTextColor: [UIColor purpleColor]];
    [logoutTips setFont: [UIFont systemFontOfSize: 20.f]];
    
    [logoutView addSubview: logoutTips];
    
    UIImageView *seperateLine = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"line_blue.png"]];
    seperateLine.frame = CGRectMake(0, 45, logoutView.frame.size.width, 2);
    
    [logoutView addSubview: seperateLine];
    
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 50, logoutTips.frame.size.width, 20)];
    NSString *name = @"当前登录的帐号是：";
    name = [name stringByAppendingString: [sqlData defaultUserInfo: @"userName"]];
    userInfoLabel.text = name;
    [userInfoLabel setFont: [UIFont systemFontOfSize: 14.f]];
    
    [logoutView addSubview: userInfoLabel];
    
    UIImageView *btnLineHeng = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"line.png"]];
    btnLineHeng.frame = CGRectMake(0, 83, logoutView.frame.size.width, 2);
    
    [logoutView addSubview: btnLineHeng];
    
    UIImageView *btnLineShu = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"line_shu.png"]];
    btnLineShu.frame = CGRectMake(logoutView.frame.size.width / 2 - 1, 85, 2, 35);
    
    [logoutView addSubview: btnLineShu];
    
    UIButton *btnCancel = [UIButton buttonWithType: UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 85, logoutView.frame.size.width / 2 - 1, 35);
    [btnCancel setTitle: @"取消" forState: UIControlStateNormal];
    [btnCancel setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize: 14.f];
    [btnCancel setImage: [UIImage imageNamed: @"btnClicking.png"] forState: UIControlStateHighlighted];
    //btnCancel.backgroundColor = [UIColor redColor];
    [btnCancel addTarget: self action: @selector(backgroundTapped) forControlEvents: UIControlEventTouchUpInside];
    
    [logoutView addSubview: btnCancel];
    
    UIButton *btnSure = [UIButton buttonWithType: UIButtonTypeCustom];
    btnSure.frame = CGRectMake(logoutView.frame.size.width / 2, 85, logoutView.frame.size.width / 2 - 1, 35);
    [btnSure setTitle: @"确定" forState: UIControlStateNormal];
    [btnSure setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    btnSure.titleLabel.font = [UIFont systemFontOfSize: 14.f];
    [btnSure setImage: [UIImage imageNamed: @"btnClicking.png"] forState: UIControlStateHighlighted];
    //btnSure.backgroundColor = [UIColor yellowColor];
    [btnSure addTarget: self action: @selector(sureToLogout) forControlEvents: UIControlEventTouchUpInside];
    
    [logoutView addSubview: btnSure];
    
    contol = [[UIControl alloc] init];
    contol.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    // 点击空白处关闭view
    [contol addTarget: self action: @selector(backgroundTapped) forControlEvents: UIControlEventTouchUpInside];
    
    [contol setBackgroundColor: [UIColor colorWithWhite: 0 alpha: 0.7]];
    
    [self.view addSubview: contol];
    
    [contol addSubview: logoutView];
    
    // 动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    
    animation.type = kCATransitionFade;
    
    [self.view.layer addAnimation: animation forKey: @"test"];
    
    //[logoutView becomeFirstResponder];
    
}

- (void)backgroundTapped
{
    [logoutView removeFromSuperview];
    [contol removeFromSuperview];
}

- (void)sureToLogout
{
    [sqlData dropUser];
    [logoutView removeFromSuperview];
    [contol removeFromSuperview];
    [_tableView reloadData];
}

-(void) btnBackAction
{
    [self.navigationController popViewControllerAnimated: YES];
}


/*
 ** 屏幕旋转
 //- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
 //{
 //    NSLog(@"x = %f, y = %f, width = %f, height = %f",self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
 //    return YES;
 //}
 //
 //- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
 //{
 //    [super willAnimateRotationToInterfaceOrientation: toInterfaceOrientation duration: duration];
 //    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
 //        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
 //    }
 //}
 **
 */


@end
