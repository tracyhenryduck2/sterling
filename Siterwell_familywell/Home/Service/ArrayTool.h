//
//  ArrayTool.h
//  sHome
//
//  Created by shaop on 2016/12/29.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayTool : NSObject

+(int) numberOfArr:(NSMutableArray *)arr;

+ (NSMutableArray *)addJudgeArr:(NSMutableArray *)targetArr UpdateArr:(NSMutableArray *)updateArr;

+ (NSMutableArray *)deletJundgeArr:(NSMutableArray *)targetArr UpdateArr:(NSMutableArray *)updateArr;

+ (NSMutableArray *)updateJundgeArr:(NSMutableArray *)targetArr UpdateArr:(NSMutableArray *)updateArr;
@end
