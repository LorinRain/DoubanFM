//
//  ChannelCell.h
//  DoubanFM
//
//  Created by Lorin on 15/9/21.
//  Copyright © 2015年 LorinRain. All rights reserved.
//  频道列表样式

#import <UIKit/UIKit.h>

@class ChannelButton;
@class ChannelCell;

@protocol ChannelCellDeleagte <NSObject>

@optional
///按钮点击事件
- (void)channelCell:(ChannelCell *)cell buttonClicked:(ChannelButton *)button;

@end

@interface ChannelCell : UITableViewCell

@property(nonatomic, assign) id<ChannelCellDeleagte>delegate;

@property(nonatomic, strong) ChannelButton *leftChannelBtn;    // 左边的按钮
@property(nonatomic, strong) ChannelButton *rightChannelBtn;   // 右边的按钮

- (void)setItem:(NSArray *)array atIndex:(NSIndexPath *)index;

@end


///cell里面的频道按钮
@interface ChannelButton : UIButton

@property(nonatomic, strong) UIImageView *playingView;   // 正在播放的图标（动态）
@property(nonatomic) BOOL isPlaying;       // 频道是否正在播放音乐

@end