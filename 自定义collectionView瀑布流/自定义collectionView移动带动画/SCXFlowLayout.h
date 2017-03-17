//
//  SCXFlowLayout.h
//  自定义collectionView移动带动画
//
//  Created by 孙承秀 on 2017/2/26.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCX_FlowLayoutDelegete;
@interface SCXFlowLayout : UICollectionViewFlowLayout

/*************  存放最大值Y得字典 ***************/
@property ( nonatomic , strong )NSMutableDictionary *mutiMaxYDic;

/*************  行间 ***************/
@property ( nonatomic , assign )CGFloat rowMagrin;

/*************  列间 ***************/
@property ( nonatomic , assign )CGFloat colMagrin;

/*************  列数 ***************/
@property ( nonatomic , assign )NSInteger colCount;

/*************  偏移量 ***************/
@property ( nonatomic , assign )UIEdgeInsets sectionInsets;

/*************  代理 ***************/
@property ( nonatomic , weak )id <SCX_FlowLayoutDelegete> delegete;

/*************  frame数组 ***************/
@property ( nonatomic , strong )NSMutableArray *frameArr;
@end
@protocol SCX_FlowLayoutDelegete <NSObject>

-(CGFloat)collectionViewLayout:(SCXFlowLayout *)SCX_layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPach;

- (CGFloat)getClickViewCenter;

@end
