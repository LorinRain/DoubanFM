//
//  MorePageCell.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "MorePageCell.h"

@implementation MorePageCell

@synthesize normalLabel = _normalLabel;
@synthesize checkImg = _checkImg;
@synthesize cellImg = _cellImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = [UIColor colorWithRed: 232/255.f green: 238/255.f blue: 234/255.f alpha: 1];
        
        // 初始化
        _normalLabel = [[UILabel alloc] init];
        _checkImg = [[UIImageView alloc] init];
        _cellImg = [[UIImageView alloc] init];
        
        [self.contentView addSubview: _normalLabel];
        [self.contentView addSubview: _checkImg];
        [self.contentView addSubview: _cellImg];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(20, 0, self.contentView.frame.size.width - 20, 25);
    self.textLabel.backgroundColor = self.contentView.backgroundColor;
    [self.textLabel setFont: [UIFont systemFontOfSize: 19.f]];
    
    self.detailTextLabel.frame = CGRectMake(20, 25, self.contentView.frame.size.width - 20, 30);
    self.detailTextLabel.backgroundColor = self.contentView.backgroundColor;
    
    _normalLabel.frame = CGRectMake(20, (self.contentView.frame.size.height - 30) / 2 - 5, self.contentView.frame.size.width - 20 - 30 - 26, 30);
    [_normalLabel setFont: [UIFont systemFontOfSize: 16.f]];
    _normalLabel.backgroundColor = [UIColor clearColor];
    
    _checkImg.frame = CGRectMake(self.contentView.frame.size.width - 30 - 26, (self.contentView.frame.size.height - 30) / 2 - 5, 26, 30);
    
    _cellImg.frame = CGRectMake(10, self.contentView.frame.size.height - 5, self.contentView.frame.size.width - 20, 5);
    _cellImg.image = [UIImage imageNamed: @"line.png"];
    
}


@end
