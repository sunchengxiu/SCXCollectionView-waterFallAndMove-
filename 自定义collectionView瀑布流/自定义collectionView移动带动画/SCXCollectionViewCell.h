//
//  SCXCollectionViewCell.h
//  自定义collectionView移动带动画
//
//  Created by 孙承秀 on 2017/2/26.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCXCollectionViewCell : UICollectionViewCell
@property (nonatomic , strong) UILabel * labelTitle;

/*************  imageView ***************/
@property ( nonatomic , strong )UIImageView *imageView;

- (void)setTextColor:(UIColor *)color;
@end
