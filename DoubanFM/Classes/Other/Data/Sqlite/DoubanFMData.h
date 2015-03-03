//
//  DoubanFMData.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DoubanFMData : NSObject

//-----------------创建用户表---------------
-(void) createUserTable;

//-----------------插入数据---------------
-(void) insertUser: (NSString *) uId andToken: (NSString *) uToken andExpire: (NSString *) uExpire andName: (NSString *) uName andEmail: (NSString *) uEmail;

//-----------------更新数据(更换用户)---------------
-(void) updateUser: (NSString *) uId andToken: (NSString *) uToken andExpire: (NSString *) uExpire andName: (NSString *) uName andEmail: (NSString *) uEmail;

//-----------------查询是否登录---------------
-(BOOL) isLogin;

//-----------------------取出登录信息--------------------------
-(NSString *) defaultUserInfo: (NSString *) infoNeeded;

//-----------------------退出登录-----------------
-(void) dropUser;


/*
 *
 *  频道表
 *
 */


// 创建频道表
-(void) createChannelTable;

//-----------------------选择默认频道（上一次退出频道，下次启动时继续收听）--------------------------
-(void) addChannel: (NSString *) channel;

//-----------------------更新数据（切换默认频道）--------------------------
-(void) changeChannel: (NSString *) channel;

//-----------------------查询是否有默认频道--------------------------
-(BOOL) isDefaultChannel;

//-----------------------取出默认频道--------------------------
-(NSString *) defaultChannel;



@end
