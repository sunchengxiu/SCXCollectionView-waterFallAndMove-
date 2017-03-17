//
//  SCXCollectionViewCell.m
//  自定义collectionView移动带动画
//
//  Created by 孙承秀 on 2017/2/26.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "SCXCollectionViewCell.h"

@implementation SCXCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES; //设置为yes，就可以使用圆角
        self.layer.cornerRadius= 3; //设置它的圆角大小
        [self p_setupView];
        
    }
    return self;
}

- (void)p_setupView
{
    [_labelTitle removeFromSuperview];
    _labelTitle = nil;
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    _labelTitle = [[UILabel alloc] init];
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:_labelTitle];
    
    _labelTitle.font = [UIFont boldSystemFontOfSize:15];
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _labelTitle.frame = CGRectMake(10, 10, self.frame.size.width-20, 20);
    
}

- (void)setTextColor:(UIColor *)color
{
    [_labelTitle setTextColor:color];
}

@end
