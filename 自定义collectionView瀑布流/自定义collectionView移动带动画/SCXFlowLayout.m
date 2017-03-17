//
//  SCXFlowLayout.m
//  自定义collectionView移动带动画
//
//  Created by 孙承秀 on 2017/2/26.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "SCXFlowLayout.h"

@implementation SCXFlowLayout

-(instancetype)init{

    if (self = [super init]) {
        self.colMagrin = 10;
        self.rowMagrin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.colCount = 3;
    }
    return self;

}

#pragma mark - layout
-(void)prepareLayout{

    [super prepareLayout];

}
-(CGSize)collectionViewContentSize
{

   
  
        __block NSString * maxCol = @"0";
        //找出最短的列
        [self.mutiMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
            if ([maxY floatValue]>[self.mutiMaxYDic[maxCol] floatValue]) {
                maxCol = column;
            }
        }];
        return CGSizeMake(0, [self.mutiMaxYDic[maxCol] floatValue]);
    
    

}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{

    return YES;

}

#pragma mark - 制定indexPath对应的属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    __block NSString *minCol = @"0";
    [self.mutiMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSNumber *obj, BOOL * _Nonnull stop) {
        
        if ([obj floatValue] < [self.mutiMaxYDic[minCol] floatValue]) {
            minCol = key;
        }
        
    }];
    
    CGFloat item_height = 100;
    CGFloat item_width = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - (self.colCount - 1) * self.colMagrin) / self.colCount;
    if ([self.delegete respondsToSelector:@selector(collectionViewLayout:heightForWidth:atIndexPath:)]) {
        item_height =  [self.delegete collectionViewLayout:self heightForWidth:item_width atIndexPath:indexPath];
    }
    CGFloat item_X = self.sectionInset.left + (item_width + self.colMagrin) * [minCol integerValue];
    CGFloat item_Y = [self.mutiMaxYDic[minCol] floatValue] + self.rowMagrin;
    self.mutiMaxYDic[minCol] = @(item_Y + item_height);
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame = CGRectMake(item_X, item_Y, item_width, item_height);
   
    attr.frame = CGRectMake(item_X, item_Y, item_width, item_height);
    return attr;

}
#pragma mark - 定制可视范围内cell的属性,先调用这个方法然后调用上面的方法
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    // 默认现将第一次的三列最小值都设置为0
    for (NSInteger i = 0; i < self.colCount; i ++) {
        NSString *col = [NSString stringWithFormat:@"%ld",i];
        self.mutiMaxYDic[col] = @(0);
    }
    NSMutableArray *arr= [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i ++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [arr addObject:attr];
    }
    return arr;

}
-(NSMutableDictionary *)mutiMaxYDic{

    if (!_mutiMaxYDic) {
        _mutiMaxYDic = [NSMutableDictionary dictionary];
    }
    return _mutiMaxYDic;

}





@end
