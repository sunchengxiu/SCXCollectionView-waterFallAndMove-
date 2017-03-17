//
//  ViewController.h
//  自定义collectionView移动带动画
//
//  Created by 孙承秀 on 2017/2/26.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCXFlowLayout.h"
#import "SCXCollectionViewCell.h"
@interface ViewController : UIViewController<UICollectionViewDelegate , UICollectionViewDataSource , SCX_FlowLayoutDelegete>


/*************  model数组 ***************/
@property ( nonatomic , strong )NSMutableArray *modelArr;

/*************  collectionView ***************/
@property ( nonatomic , strong )UICollectionView *collectionView;

/*************  collectionViewLayout ***************/
@property ( nonatomic , strong )SCXFlowLayout *SCX_layout;

/*************  长按手势 ***************/
@property ( nonatomic , strong )UILongPressGestureRecognizer *longGesture;

/*************  原始点击的IndexPath ***************/
@property ( nonatomic , strong )NSIndexPath *originalIndexPath;

/*************  目的IndexPath ***************/
@property ( nonatomic , strong )NSIndexPath *aimIndexPath;

/*************  临时Item ***************/
@property ( nonatomic , strong )UIView *tempCell;

/*************  原始cell ***************/
@property ( nonatomic , strong )UICollectionViewCell *originalCell;

/*************  拖动的时候cell是否抖动 ***************/
@property ( nonatomic , assign )BOOL sharkWhenMove;

/*************  拖动到边缘是否滑动collectionView ***************/
@property ( nonatomic , assign )BOOL isScrollWhenEdge;

/*************  颤抖的幅度 ***************/
@property ( nonatomic , assign )CGFloat sharkeLevel;

/*************  定时器 ***************/
@property ( nonatomic , strong )CADisplayLink *timeLink;

/*************  原始最小触发长按时间 ***************/
@property ( nonatomic , assign )NSTimeInterval originalMinPresstimer;

@end

