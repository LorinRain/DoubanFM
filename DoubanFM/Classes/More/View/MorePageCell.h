//
//  MorePageCell.h
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorePageCell : UITableViewCell

@property (nonatomic, strong) UILabel *normalLabel;   // 显示普通信息
@property (nonatomic, strong) UIImageView *checkImg;  // 勾选框

@property (nonatomic, strong) UIImageView *cellImg;   // 行与行之间的分隔线


@end
