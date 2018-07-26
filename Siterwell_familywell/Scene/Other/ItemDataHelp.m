//
//  ItemDataHelp.m
//  sHome
//
//  Created by shaop on 2017/1/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ItemDataHelp.h"
#import "BatterHelp.h"
#import "SceneDataBase.h"

@implementation ItemDataHelp
+(SceneListItemData *)ItemDataToSceneListItemData:(ItemData *)data{
    SceneListItemData *item = [[SceneListItemData alloc] init];
    item.title = data.title;
    if([data.customTitle isEqualToString:@""]){
        item.custmTitle = [NSString stringWithFormat:@"%@ %ld",NSLocalizedString(data.title, nil) ,data.devID];
    }else{
        item.custmTitle = data.customTitle;
    }
    item.eqid = data.devID;
    if ([data.title isEqualToString:@"定时"]) {
        item.image = @"blue_clock_icon";
    }else if ([data.title isEqualToString:@"点击执行"]){
        item.image = @"blue_hand_icon";
    }else if ([data.title isEqualToString:@"SM报警器"]){
        item.image = @"blue_smbjq_icon";
    }else if ([data.title isEqualToString:@"PIR探测器"]){
        item.image = @"blue_pirtcq_icon";
    }else if ([data.title isEqualToString:@"CO报警器"]){
        item.image = @"blue_cobjq_icon";
    }else if ([data.title isEqualToString:@"水感报警器"]){
        item.image = @"blue_sgbjq_icon";
    }else if ([data.title isEqualToString:@"门磁"]){
        item.image = @"blue_mc_icon";
    }else if ([data.title isEqualToString:@"SOS按钮"]){
        item.image = @"blue_sosbtn_icon";
    }else if ([data.title isEqualToString:@"智能插座"]){
        item.image = @"blue_dtdzncz_icon";
    }else if ([data.title isEqualToString:@"网关灯"]){
        item.image = @"blue_wgjd_icon";
    }else if([data.title isEqualToString:@"复合型烟感"]){
        item.image = @"blue_smbjq_icon";
    }else if([data.title isEqualToString:@"热感报警器"]){
        item.image = @"blue_rg_icon";
    }else if([data.title isEqualToString:@"气体探测器"]){
        item.image = @"blue_qtjc_icon";
    }else if ([data.title isEqualToString:@"情景开关"]) {
        item.image = @"blue_btn_icon";
    }else if ([data.title isEqualToString:@"按键"]) {
        item.image = @"blue_switch_icon";
    }else if ([data.title isEqualToString:@"温湿度探测器"]) {
        item.image = @"blue_wsdjcy_icon";
    }else if ([data.title isEqualToString:@"门锁"]) {
        item.image = @"blue_fm_icon";
    }else if ([data.title isEqualToString:@"双路开关"]) {
        item.image = @"blue_dtdzncz_icon";
    }else if ([data.title isEqualToString:@"调光模块"]) {
        item.image = @"blue_jtbj_icon";
    }
    
    return item;
}


+ (NSString *)SceneContentWithOutputArray:(NSMutableArray *)outarray inputAraary:(NSMutableArray *)inarray type:(NSInteger)type name:(NSString *)name sceneid:(NSString *)sceneid{
    int contentLength = 2;

    NSString *content;
    //自定义编号
    if (!sceneid) {
        NSMutableArray *array = [[SceneDataBase sharedDataBase] selectScene];
//        SceneModel *model = [array objectAtIndex:array.count-1];
//        NSString *scene_id = [NSString stringWithFormat:@"%d",[model.scene_id intValue] + 1];
//        while (YES) {
//            if (![self isAddSceneId:scene_id]) {
//                scene_id = [NSString stringWithFormat:@"%d",[scene_id intValue] + 1];
//            }else{
//                break;
//            }
//        }
        
        
        int maxId = 1;
        
        for (SceneModel *model in array) {
            if ([model.scene_id intValue] > maxId) {
                maxId = [model.scene_id intValue];
            }
        }
        
        NSString *scene_id = [NSString stringWithFormat:@"%d",maxId + 1];
        
        for (int i = 1 ; i <= maxId; i ++ ) {
            if (![[SceneDataBase sharedDataBase] selectScene:[NSString stringWithFormat:@"%d",i]].scene_content) {
                scene_id = [NSString stringWithFormat:@"%d",i];
                break;
            }
        }
        
        NSLog(@"\n\n\n\n\n\n\n情景列表id %@\n\n\n\n\n\n\n",scene_id);
        
        if (array.count == 0) {
            content = [BatterHelp gethexBybinary:1];
        }else {
            content = [BatterHelp gethexBybinary:[scene_id intValue]];
        }
        
    }else{
        content = [BatterHelp gethexBybinary:[sceneid intValue]];
    }
    if (content.length<2) {
        content = [@"0" stringByAppendingString:content];
    }
    contentLength += 1;
    
    //情景名称
    NSString *nameString = @"";
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *namedata = [name dataUsingEncoding:enc];

    NSInteger countf = 15 - namedata.length;
    for(int i = 0 ; i < countf ; i++){
        nameString = [nameString stringByAppendingString:@"@"];
    }
    name = [NSString stringWithFormat:@"%@%@%@",nameString,name,@"$"];
    namedata = [name dataUsingEncoding:enc];
    name = [self convertDataToHexStr:namedata];
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
            NSString *devieTanid = [BatterHelp gethexBybinary:item.eqid];
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
            
            NSString *devieTanid = [BatterHelp gethexBybinary:item.eqid];
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


+ (BOOL)isAddSceneId:(NSString *)sceneId{
    NSMutableArray *array = [[SceneDataBase sharedDataBase] selectScene];
    for (SceneModel *model in array) {
        if ([model.scene_id isEqualToString:sceneId]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isClickItem:(NSMutableArray *)array{
    for (SceneListItemData *item in array) {
        if ([item.title isEqualToString:@"点击执行"]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isPhoneItem:(NSMutableArray *)array{
    for (SceneListItemData *item in array) {
        if ([item.title isEqualToString:@"通知手机"] ||[item.title isEqualToString:@"手机通知"]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+ (int)deviceNumbaer:(NSMutableArray *)array{
    int number = 0;
    for (SceneListItemData *item in array) {
        if (item.deviceId && [item.deviceId intValue] >= 0) {
            number ++;
        }
    }
    return number;
}

@end
