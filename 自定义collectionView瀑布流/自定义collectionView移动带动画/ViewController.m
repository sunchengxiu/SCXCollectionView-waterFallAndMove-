//
//  ViewController.m
//  自定义collectionView移动带动画
//
//  Created by 孙承秀 on 2017/2/26.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "ViewController.h"
#import "SCXModel.h"
#import "UIColor+Hex.h"
#import "SCXShopModel.h"
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#define RotationAngle(X) ((X) / 180.0 * M_PI)
#define CollectionCellID @"CollectionCellID"
#define MinLongPreTime 0.5
@interface ViewController ()
{

    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"自定义collectionView移动";
    
    [self configData];
    
    [self configGesture];
    
    [self.view addSubview:self.collectionView];
    
    
}

#pragma mark - 配置数据
- (void)configData{
/*
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dateAll" ofType:@"txt"];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dic in arr) {
        
        SCXModel *model = [[SCXModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        [self.modelArr addObject:model];
    }
 */
    
    NSArray *shopArr = [SCXShopModel mj_objectArrayWithFilename:@"1.plist"];
    [self.modelArr addObjectsFromArray:shopArr];
    
    
}



#pragma mark - 配置手势
- (void)configGesture{
    
    _longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGestureAction:)];
    
    _longGesture.minimumPressDuration = MinLongPreTime;
    
    [self.collectionView addGestureRecognizer:_longGesture];

}

#pragma mark - collectionView代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SCXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
    SCXShopModel * model = nil;
    model = self.modelArr[indexPath.row];
    [cell setTextColor:[UIColor whiteColor]];
    cell.labelTitle.text = model.price;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{



}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.modelArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

#pragma mark - 手势点击方法
/*
 beginInteractiveMovementForItemAtIndexPath(indexPath: NSIndexPath)?开始在特定的索引路径上对cell（单元）进行Interactive Movement（交互式移动工作）。
 updateInteractiveMovementTargetPosition(targetPosition: CGPoint)?在手势作用期间更新交互移动的目标位置。】
 endInteractiveMovement()?在完成手势动作后，结束交互式移动
 cancelInteractiveMovement()?取消Interactive Movement。
 */
- (void)longGestureAction:(UILongPressGestureRecognizer *)longPress{

    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"长按手势开始");
            // 获取原始点击的indexPath和cell
            _originalIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationOfTouch:0 inView:longPress.view]];
            _originalCell = [self.collectionView cellForItemAtIndexPath:_originalIndexPath];
            // 开始交互式移动操作
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:_originalIndexPath];
            
            // 创建一个临时的cell，目的是为了长安的时候会出现一个额外的突出的一个cell效果，是一个假试图不是cell
            _tempCell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _originalCell.frame.size.width + 10, _originalCell.frame.size.height + 10)];
            _tempCell.backgroundColor = _originalCell.backgroundColor;
            _tempCell.layer.masksToBounds = YES;
            _tempCell.layer.cornerRadius = 3;
            _tempCell.center = _originalCell.center;
            [_tempCell addSubview:_originalCell.contentView];
            [self.collectionView addSubview:_tempCell];
            [self cellSharkAnimation:_tempCell];
            _originalCell.alpha = 0.3;
            
            // 一些参数配置
            // 移动的时候是否颤抖
            _sharkWhenMove = YES;
            // 滑动到边缘的时候是否滑动collectionView
            _isScrollWhenEdge = YES;
            // 颤抖的幅度
            _sharkeLevel = 2;
            
            [self beginEdgeTime];
            // 长按的时候开启所有cell颤抖动画
            [self startShark];
            
            
        }
            break;
            case UIGestureRecognizerStateChanged:
        {
           
            // 手势改变的时候,让tempCell的位置跟着手势的位置来改变
            _tempCell.center = [longPress locationOfTouch:0 inView:longPress.view];
            [self moveItemIfNeed];
        }
            break;
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"长按手势取消");
            [self stopTimer];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            NSLog(@"长按手势结束");
            [self stopTimer];
            [self endSharkAnimation];
            [self.collectionView endInteractiveMovement];
            [_tempCell removeFromSuperview];
            _tempCell = nil;
            _originalCell.hidden = NO;
            _originalCell.alpha = 1;
            [_originalCell addSubview:_originalCell.contentView];
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationOfTouch:0 inView:longPress.view]];
            // 交换一下位置
            NSIndexPath *originalIndexPath = _originalIndexPath;
            SCXModel *originalModel = [self.modelArr objectAtIndex:originalIndexPath.row];
            SCXModel *currentModel = [self.modelArr objectAtIndex:currentIndexPath.row];
            [self.modelArr replaceObjectAtIndex:currentIndexPath.row withObject:originalModel];
            [self.modelArr replaceObjectAtIndex:originalIndexPath.row withObject:currentModel];
            [self.collectionView reloadData];
            
        }
            break;
        default:
            break;
    }
    

}
#pragma mark - 交换位置
- (void)moveItemIfNeed{

    NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[_longGesture locationOfTouch:0 inView:self.collectionView]];
    
    // 防止崩溃和重复抖动
    if (_originalIndexPath == nil || currentIndexPath == nil || _aimIndexPath == currentIndexPath  ) {
        return;
    }
    _aimIndexPath = currentIndexPath;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:currentIndexPath];
    cell.alpha = 0.3;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveItemAtIndexPath:_originalIndexPath toIndexPath:currentIndexPath];
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{

    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;

}
-(UICollectionView *)collectionView{

    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.SCX_layout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        
        _collectionView.dataSource = self;
        
        
        [_collectionView registerClass:[SCXCollectionViewCell class] forCellWithReuseIdentifier:CollectionCellID];
    }
    return _collectionView;

}
-(SCXFlowLayout *)SCX_layout{

    if (!_SCX_layout) {
        
        _SCX_layout = [[SCXFlowLayout alloc]init];
        
        _SCX_layout.delegete = self;
        
//        _SCX_layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        
//        _SCX_layout.minimumLineSpacing = 10;
//        
//        _SCX_layout.minimumInteritemSpacing = 10;
      
        
    }
    return _SCX_layout;
}
#pragma mark - 抖动动画
- (void)startShark{

    _originalMinPresstimer = _longGesture.minimumPressDuration;
    if (_sharkWhenMove) {
        [self beginSharkeAnimation];
    }

}

#pragma mark - 开始颤抖动画
- (void)beginSharkeAnimation{

    //
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.values = @[@(RotationAngle(-_sharkeLevel)) , @(RotationAngle(_sharkeLevel)) , @(RotationAngle(-_sharkeLevel))];
    
    animation.duration = 0.2f;
    animation.repeatCount = MAXFLOAT;
    NSArray *arr = [self.collectionView visibleCells];
    // cell添加颤抖动画，添加过得就不需要再次添加了
    for (UICollectionViewCell *cell  in arr) {
        if (![cell.layer animationForKey:@"shark"]) {
            [cell.layer addAnimation:animation forKey:@"shark"];
        }
    }
    if (![_tempCell.layer animationForKey:@"shake"]) {
        [_tempCell.layer addAnimation:animation forKey:@"shake"];
    }
    
}
#pragma mark - 结束颤抖动画
- (void)endSharkAnimation{

    if (!_sharkWhenMove) {
        return;
    }
    NSArray *arr= [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in arr) {
        [cell.layer removeAllAnimations];
    }
    [_tempCell.layer removeAllAnimations];
}
#pragma mark - 停止timer
- (void)stopTimer{

    if (_timeLink) {
        [_timeLink invalidate];
        _timeLink = nil;
    }
}

#pragma mark-开启边缘滚动定时器
- (void)beginEdgeTime{

    if (!_timeLink && _isScrollWhenEdge) {
        _timeLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginScrollCollection)];
        [_timeLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }

}
#pragma mark - 开始滚动列表
- (void)beginScrollCollection{
    
}
#pragma mark - 点击时候cell放大动画
- (void)cellSharkAnimation:(UIView *)view{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.15];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    [view.layer addAnimation:animation forKey:nil];

}
-(CGFloat)collectionViewLayout:(SCXFlowLayout *)SCX_layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPach{

    SCXShopModel *model = self.modelArr[indexPach.row];
    
    return model.h / model.w * width;

}
-(CGFloat)getClickViewCenter{

    return _tempCell.frame.origin.y + _tempCell.frame.size.height;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
