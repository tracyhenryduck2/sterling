//
//  ItemDataHelp.m
//  sHome
//
//  Created by shaop on 2017/1/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ItemDataHelp.h"


@implementation ItemDataHelp
+(SceneListItemData *)ItemDataToSceneListItemData:(ItemData *)data{
    SceneListItemData *item = [[SceneListItemData alloc] init];
    item.eqid = data.device_ID;
    item.type = data.device_name;
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    NSDictionary *dic_name = [dic objectForKey:@"names"];
    NSDictionary *dic_pics = [dic objectForKey:@"pictures"];
    if([NSString isBlankString:data.customTitle ]){
        item.custmTitle = [NSString stringWithFormat:@"%@ %d",NSLocalizedString([dic_name objectForKey:data.device_name], nil) ,[data.device_ID intValue]];
        item.title = [dic_name objectForKey:data.device_name];
    }else{
        item.custmTitle = data.customTitle;
    }
        item.image = [NSString stringWithFormat:[dic_pics objectForKey:data.device_name],@"blue"];
    
    return item;
}


+ (NSString *)SceneContentWithOutputArray:(NSMutableArray *)outarray inputAraary:(NSMutableArray *)inarray type:(NSInteger)type name:(NSString *)name sceneid:(NSString *)sceneid withDevTid:(NSString *)devTid{
    int contentLength = 2;
    NSInteger new_mid;
    NSString *content;
    //自定义编号
    if (!sceneid) {
        NSMutableArray *array = [[DBSceneManager sharedInstanced] queryAllScenewithDevTid:devTid];
        [array sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
            return [((SceneModel *)obj1).scene_type intValue] > [((SceneModel *)obj2).scene_type intValue];
        }];

        if(array.count==0){
            new_mid = 1;
        }else if(array.count==1){
            if(  [((SceneModel *)array[0]).scene_type intValue] ==1){
               new_mid = 2;
            }else{
                new_mid = 1;
            }
        }else{
            int m = 0;
            for(int i=0;i<array.count-1;i++){
                
                
                if(i==0){
                    
                    int d = [((SceneModel *)array[i]).scene_type intValue];
                    if(d!=1){
                        m = 1;
                        break;
                    }
                    else {
                        if(([((SceneModel *)array[i]).scene_type intValue] + 1) < [((SceneModel *)array[i+1]).scene_type intValue]){
                            m = [((SceneModel *)array[i]).scene_type intValue]+1;
                            break;
                        }else{
                            m = [((SceneModel *)array[i]).scene_type intValue]+2;
                        }
                    }
                    
                    
                }else{
                    if(([((SceneModel *)array[i]).scene_type intValue] + 1) < [((SceneModel *)array[i+1]).scene_type intValue]){
                        m = [((SceneModel *)array[i]).scene_type intValue]+1;
                        break;
                    }else{
                        m = [((SceneModel *)array[i]).scene_type intValue]+2;
                    }
                    
                }
                
                
            }
            new_mid = m;
        }
        content = [NSString stringWithFormat:@"%ld",new_mid];
        
    }else{
        content = [BatterHelp gethexBybinary:[sceneid intValue]];
    }
    if (content.length<2) {
        content = [@"0" stringByAppendingString:content];
    }
    contentLength += 1;
    
    //情景名称
    name = [NameHelper getASCIIFromName:name];
    content = [content stringByAppendingString:name];
    contentLength += 32;
    
    //条件选择
    if (type == 0) {
        content = [content stringByAppendingString:@"00"];
    }else{
        content = [content stringByAppendingString:@"FF"];
    }
    contentLength += 1;
    
    //定时
    NSString *weekTime = @"00";
    NSString *hourTime = @"00";
    NSString *minuteTime = @"00";

    for (SceneListItemData *item in outarray) {
        if (item.week || item.hour || item.minute) {
            if (item.week) {
                weekTime = item.week;
                if (weekTime.length == 1) {
                    weekTime = [@"0" stringByAppendingString:weekTime];
                }
            }
            if (item.hour){
                hourTime = [BatterHelp gethexBybinary:[item.hour intValue]];
                if (hourTime.length == 1) {
                    hourTime = [@"0" stringByAppendingString:hourTime];
                }
            }
            if (item.minute){
                minuteTime = [BatterHelp gethexBybinary:[item.minute intValue]];
                if (minuteTime.length == 1) {
                    minuteTime = [@"0" stringByAppendingString:minuteTime];
                }
            }
        }
    }
    content =  [content stringByAppendingString:weekTime];
    content =  [content stringByAppendingString:hourTime];
    content =  [content stringByAppendingString:minuteTime];
    contentLength += 3;

    //点击执行
    if ([self isClickItem:outarray]) {
        content = [content stringByAppendingString:@"AB"];
    }else{
        content = [content stringByAppendingString:@"FF"];
    }
    contentLength += 1;
    
    //手机通知
    if ([self isPhoneItem:inarray]) {
        content = [content stringByAppendingString:@"AC"];
    }else{
        content = [content stringByAppendingString:@"FF"];
    }
    contentLength += 1;
    
    //输入设备个数
    NSString *outCount = [BatterHelp gethexBybinary:[self deviceNumbaer:outarray]];
    if (outCount.length < 2) {
        outCount = [@"0" stringByAppendingString:outCount];
    }
    content = [content stringByAppendingString:outCount];
    contentLength += 1;

    //输出设备个数
    NSString *inCount = [BatterHelp gethexBybinary:[self deviceNumbaer:inarray]];
    if (inCount.length < 2) {
        inCount = [@"0" stringByAppendingString:inCount];
    }
    content = [content stringByAppendingString:inCount];
    contentLength += 1;
    
    //输入设备内容
    for (SceneListItemData *item in outarray) {
        if (item.eqid>=0) {
            NSString *devieTanid = [BatterHelp gethexBybinary:[item.eqid intValue]];
            int length = (int)[devieTanid length];
            for (int i = length; i<4; i++) {
                devieTanid = [@"0" stringByAppendingString:devieTanid];
            }
            content = [content stringByAppendingString:devieTanid];
            content = [content stringByAppendingString:item.action];
            contentLength += 6;
        }
    }
    //输出设备内容
    for (int i = 0 ; i < inarray.count ;i++) {
        
        SceneListItemData *item = inarray[i];
        
        if (item.eqid >= 0) {
            
            if (i == 0) {
                content = [content stringByAppendingString:@"0000"];
            }else{
                SceneListItemData *lastItem = inarray[i-1];
                if ([lastItem.image isEqualToString:@"blue_ys_icon"]) {
                    NSString *second = @"00";
                    NSString *minute = @"00";
                    second = [BatterHelp gethexBybinary:[lastItem.second intValue]];
                    minute = [BatterHelp gethexBybinary:[lastItem.minute intValue]];
                    int length = (int)[second length];
                    for (int i = length; i<2; i++) {
                        second = [@"0" stringByAppendingString:second];
                    }
                    length = (int)[minute length];
                    for (int i = length; i<2; i++) {
                        minute = [@"0" stringByAppendingString:minute];
                    }
                    content = [content stringByAppendingString:minute];
                    content = [content stringByAppendingString:second];
                }else{
                    content = [content stringByAppendingString:@"0000"];
                }
            }
            contentLength += 2;
            
            NSString *devieTanid = [BatterHelp gethexBybinary:[item.eqid intValue]];
            int length = (int)[devieTanid length];
            for (int i = length; i<4; i++) {
                devieTanid = [@"0" stringByAppendingString:devieTanid];
            }
            content = [content stringByAppendingString:devieTanid];
            content = [content stringByAppendingString:item.action];
            contentLength += 6;
        }
    }
    
    //设置长度
    NSString *topString = [BatterHelp gethexBybinary:contentLength];
    if (topString.length < 4) {
        for (int i = 0; i < 4 - [BatterHelp gethexBybinary:contentLength].length; i++) {
            topString = [@"0" stringByAppendingString:topString];
        }
    }
    
    content = [topString stringByAppendingString:content];
    
    return content;
}


+ (BOOL)isAddSceneId:(int)sceneId withDevTid:(NSString *)devTid{
    NSMutableArray *array = [[DBSceneManager sharedInstanced] queryAllScenewithDevTid:devTid];
    for (SceneModel *model in array) {
        if ([model.scene_type integerValue] == sceneId) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isClickItem:(NSMutableArray *)array{
    for (SceneListItemData *item in array) {
        if ([item.type isEqualToString:@"click"]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isPhoneItem:(NSMutableArray *)array{
    for (SceneListItemData *item in array) {
        if ([item.type isEqualToString:@"phone"]) {
            return YES;
        }
    }
    return NO;
}


+ (int)deviceNumbaer:(NSMutableArray *)array{
    int number = 0;
    for (SceneListItemData *item in array) {
        if (item.eqid >= 0) {
            number ++;
        }
    }
    return number;
}

@end
