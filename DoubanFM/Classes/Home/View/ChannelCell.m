//
//  ChannelCell.m
//  DoubanFM
//
//  Created by Lorin on 15/9/21.
//  Copyright © 2015年 LorinRain. All rights reserved.
//

#import "ChannelCell.h"
#import "ModelPro.h"
#import "ChannelView.h"

///频道按钮
@implementation ChannelButton

///初始化
- (instancetype)init
{
    self = [super init];
    if(self) {
        // 设置自身属性
        self.backgroundColor = [UIColor colorWithRed: 73/255.f green: 152/255.f blue: 132/255.f alpha: 1];
        self.titleLabel.font = [UIFont systemFontOfSize: 14];
        self.titleLabel.numberOfLines = 0;
    }
    
    return self;
}

///调整按钮内部的标题位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 5;
    CGFloat titleY = 5;
    CGFloat titleWidth = contentRect.size.width - 5*4;
    CGFloat titleHeight = 40;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

///设置正在播放
- (void)setIsPlaying:(BOOL)isPlaying
{
    if(isPlaying) {
        // 如果设置成为正在播放，则加上正在播放的图标
        [self.playingView startAnimating];
        [self addSubview: self.playingView];
    } else {
        // 如果没有正在播放，则移除
        [self.playingView removeFromSuperview];
    }
}

///懒加载正在播放的按钮
- (UIImageView *)playingView
{
    if(!_playingView) {
        _playingView = [[UIImageView alloc] init];
        
        UIImage *img1 = [UIImage imageNamed: @"channel_nowplaying1.png"];
        UIImage *img2 = [UIImage imageNamed: @"channel_nowplaying2.png"];
        UIImage *img3 = [UIImage imageNamed: @"channel_nowplaying3.png"];
        UIImage *img4 = [UIImage imageNamed: @"channel_nowplaying4.png"];
        
        NSArray *imgs = [NSArray arrayWithObjects: img1, img2,img3, img4, nil];
        //    [btn setImage: img forState: UIControlStateNormal];
        //    [btn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 40, -100)];
        _playingView = [[UIImageView alloc] initWithImage: img1];
        _playingView.frame = CGRectMake(115-12-10, 10, 12, 12);
        _playingView.animationImages = imgs;
        _playingView.animationDuration = 0.6f;
    }
    
    return _playingView;
}

///设置标签
- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    if(tag == -3) {
        // 红心
        self.backgroundColor = [UIColor colorWithRed: 224/255.f green: 107/255.f blue: 89/255.f alpha: 1];
    }
}

@end


#pragma mark
//////////////////
@implementation ChannelCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        // 初始化控件
        self.leftChannelBtn = [[ChannelButton alloc] init];
        self.rightChannelBtn = [[ChannelButton alloc] init];
        
        // 添加事件
        [self.leftChannelBtn addTarget: self action: @selector(leftBtnAction:) forControlEvents: UIControlEventTouchUpInside];
        [self.rightChannelBtn addTarget: self action: @selector(rightBtnAction:) forControlEvents: UIControlEventTouchUpInside];
        
        // 设置cell属性
        self.contentView.backgroundColor = [UIColor colorWithRed: 42/255.f green: 42/255.f blue: 42/255.f alpha: 1];
    }
    
    return self;
}

- (void)setItem:(NSArray *)array atIndex:(NSIndexPath *)index
{
    // 左边的
    ModelPro *channel = array[index.row*2];
    [self.leftChannelBtn setTitle: channel.channelName forState: UIControlStateNormal];
    self.leftChannelBtn.tag = [channel.channelId intValue];
    
    // 判断，当前正在播放的频道加上正在播放的图标
    if(self.leftChannelBtn.tag == [[ChannelView currentPlayingChannel] intValue]) {
        [self.leftChannelBtn setIsPlaying: YES];
    }
    
    [self.contentView addSubview: self.leftChannelBtn];
    
    // 右边的
    if(index.row*2+1 < array.count) {
        ModelPro *channelRight = array[index.row*2+1];
        [self.rightChannelBtn setTitle: channelRight.channelName forState: UIControlStateNormal];
        self.rightChannelBtn.tag = [channelRight.channelId intValue];
        
        // 判断，当前正在播放的频道加上正在播放的图标
        if(self.rightChannelBtn.tag == [[ChannelView currentPlayingChannel] intValue]) {
            [self.rightChannelBtn setIsPlaying: YES];
        }
        
        [self.contentView addSubview: self.rightChannelBtn];
    }
}

- (void)layoutSubviews
{
    self.leftChannelBtn.frame = CGRectMake(5, 5, 115, 80);
    
    self.rightChannelBtn.frame = CGRectMake(130, 5, 115, 80);
}

///按钮点击事件
- (void)leftBtnAction:(ChannelButton *)button
{
    if([_delegate respondsToSelector: @selector(channelCell:buttonClicked:)]) {
        [_delegate channelCell: self buttonClicked: button];
    }
}

- (void)rightBtnAction:(ChannelButton *)button
{
    if([_delegate respondsToSelector: @selector(channelCell:buttonClicked:)]) {
        [_delegate channelCell: self buttonClicked: button];
    }
}

@end
