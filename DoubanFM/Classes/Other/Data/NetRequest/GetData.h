//
//  GetData.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@class ModelPro;

// 定义协议，异步请求完成后，将得到的数据返回
@protocol SendData <NSObject>

@optional

// 将播放列表送出的方法
-(void) sendData: (NSArray *) arry;

// 将歌曲图片送出
-(void) sendPictureData: (NSData *) picData;

// 将频道列表推出的方法
-(void) sendChannelData: (NSArray *) array;

// 请求出错时调用
-(void) sendError;

// 登录成功后，将所需的信息推出
-(void) senLoginInfo: (ModelPro *) model;

// 请求后，报告登录状态
-(void) sendLoginStatu: (BOOL) isLogin;

// 请求后，没有歌曲
- (void)sendNoSongs;

@end


@interface GetData : NSObject
{
    ASIFormDataRequest *requestChannel;
}

// 设置委托对象
@property (nonatomic, strong) id<SendData> delegate;  // 定义协议的delegate

@property (nonatomic, strong) NSMutableData *datas;  // 接收从服务器返回的数据
@property (nonatomic, strong) NSMutableArray *items; // 传给vc的数据

// 获取歌曲部分
@property (nonatomic, strong) NSMutableArray *playList;  // 播放列表
@property (nonatomic, strong) NSString *songPic;         // 全局变量，用于获取歌曲图片
@property (nonatomic, strong) NSString *songType;        // 发送请求时，传递参数
@property (nonatomic, strong) NSString *channelId;          // 发送请求时，传递频道id

// 登录部分
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *passWord;

// 登录请求部分
@property (nonatomic, strong) NSString *userId;       // 请求是时的参数
@property (nonatomic, strong) NSString *songSid;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *userExpire;

// 判断是否登录（登录状态不同，请求的数据不同）(定义此属性是为了不用每次都访问数据库)
//@property (nonatomic) BOOL isLogin;


-(void) getChannel;   // 获取频道信息
-(void) ASIGetChannel; // 用ASI请求
-(void) getSongs;      // 获取歌曲
-(void) getPicture;    // 获取歌曲图片
-(void) login;         // 登录
-(void) likeSong;      // 收藏歌曲
- (void)cancelRequest;  // 取消请求

@end
