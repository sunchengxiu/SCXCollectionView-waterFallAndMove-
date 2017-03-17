//
//  SCXModel.m
//  自定义collectionView移动带动画
//
//  Created by 孙承秀 on 2017/2/26.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "SCXModel.h"

@implementation SCXModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.Did = value;
    }

}
@end
