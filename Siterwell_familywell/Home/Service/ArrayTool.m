//
//  ArrayTool.m
//  sHome
//
//  Created by shaop on 2016/12/29.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "ArrayTool.h"
#import "ItemData.h"

@implementation ArrayTool

/**
 判断数组中的元素

 @param arr 数组
 @return 个数
 */
+ (int)numberOfArr:(NSMutableArray *)arr{
    
    int number = 0;
    
    for (int i = 0; i<arr.count; i++) {
        
        NSObject *obj = arr[i];
        if ([obj isKindOfClass:[NSArray class]]) {
            number += [self numberOfArr:(NSMutableArray *)obj];
        }else{
            number += 1;
        }
        
    }
    return number;
}


/**
 添加判断

 @param targetArr 目标数组
 @param updateArr 更新的数组
 @return 增加后的数组
 */
+ (NSMutableArray *)addJudgeArr:(NSMutableArray *)targetArr UpdateArr:(NSMutableArray *)updateArr{
    if (!targetArr) {
        targetArr = [[NSMutableArray alloc] init];
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<updateArr.count; i++) {
        
        ItemData *obj = updateArr[i];
        if (![self objectIsKindOfArray:targetArr withObject:obj]) {
            [array addObject:obj];
        }
        
    }
    for (ItemData *data in array) {
        [targetArr addObject:data];
    }
    
    return targetArr;
}


/**
 判断ItemData 是否与数组中的某个item相同

 @param array 目标数组
 @param object ItemData对象
 @return 是否有相同
 */
+ (BOOL)objectIsKindOfArray:(NSMutableArray *)array withObject:(ItemData *)object{
    
    for (int i = 0; i<array.count; i++) {
        
        NSObject *obj = array[i];
        if ([obj isKindOfClass:[NSArray class]]) {
            if ([self objectIsKindOfArray:(NSMutableArray *)obj withObject:object]) {
                return YES;
            }
        }else{
            ItemData *data = (ItemData *)obj;
            if ([data.device_ID integerValue]  == [object.device_ID integerValue] ) {
                return YES;
            }
        }
    }
    
    return NO;
}


/**
 删除判断
 
 @param targetArr 目标数组
 @param updateArr 更新数组
 @return 删除后的数组
 */
+ (NSMutableArray *)deletJundgeArr:(NSMutableArray *)targetArr UpdateArr:(NSMutableArray *)updateArr{
    
    NSMutableArray *array = [targetArr mutableCopy];
    
    for (int i = 0 ; i<targetArr.count; i++) {
        NSObject *obj = targetArr[i];
        if ([obj isKindOfClass:[NSArray class]]) {
            [self deletJundgeArr:(NSMutableArray *)obj UpdateArr:updateArr];
        }else{

            if ([self isShouldDelet:(ItemData *)obj withArray:updateArr]) {
                [array removeObject:obj];
            }
        }
    }
    
    return array;
    
}

/**
 是否需要删除

 @param targetData 目标Item
 @param updateArray 更新数组
 @return 是否需要删除
 */
+ (BOOL)isShouldDelet:(ItemData *)targetData withArray:(NSMutableArray *)updateArray{
    
    for (int j = 0; j<updateArray.count; j++) {
        ItemData *updateData = updateArray[j];
        if ([updateData.device_ID integerValue]  == [targetData.device_ID integerValue]) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSMutableArray *)updateJundgeArr:(NSMutableArray *)targetArr UpdateArr:(NSMutableArray *)updateArr{
    for (int i = 0 ; i<targetArr.count; i++) {
        NSObject *obj = targetArr[i];
        if ([obj isKindOfClass:[NSArray class]]) {
            [self updateJundgeArr:(NSMutableArray *)obj UpdateArr:updateArr];
        }else{
            ItemData *targetData = (ItemData *)obj;
            for (int j = 0; j<updateArr.count; j++) {
                ItemData *updateData = updateArr[j];
                if ([updateData.device_ID integerValue]  == [targetData.device_ID integerValue]) {
                    [targetArr replaceObjectAtIndex:i withObject:updateData];
                    break;
                }
            }
        }
    }
    
    return targetArr;
}

//+ (void)changeData:(ItemData *)targetData withArray:(NSMutableArray *)updateArray{
//    
//    for (int j = 0; j<updateArray.count; j++) {
//        ItemData *updateData = updateArray[j];
//        if ([updateData.devID isEqualToString:targetData.devID]) {
//            targetData = updateData;
//            break;
//        }
//    }
//}


@end
