//
//  ModelPro.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPro : NSObject

// 获取到的频道属性
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *channelId;

// 歌曲属性
@property (nonatomic, strong) NSString *songPicture;
@property (nonatomic, strong) NSString *songArtist;
@property (nonatomic, strong) NSString *songURL;
@property (nonatomic, strong) NSString *songTitle;
@property (nonatomic, strong) NSNumber *songLength;
@property (nonatomic, strong) NSString *songSid;
@property (nonatomic, strong) NSNumber *songLiked;

// 登录
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *userExpire;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;

@end
