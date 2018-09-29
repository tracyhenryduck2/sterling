//
//  ContentHepler.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/8/26.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ContentHepler.h"


@implementation ContentHepler

+(NSString *)getContentFromSystem:(SystemSceneModel *)systemModel withSceneRelationShip:(NSMutableArray *)scenerelationships withGS584Relations:(NSMutableArray *)gs584relationships{
    NSString * name = @"";
    if([systemModel.sence_group integerValue]>2){
        name = systemModel.systemname;
    }else{
        name = @"";
    }
    
    int  length = 0;
    length+=2;//the total num length
    
    NSNumber * id2 = systemModel.sence_group;
    length += 1;//the scene id
    
    NSString * btnNum = @"";
    
    if (gs584relationships.count <16){  //new mid
        btnNum = [@"0" stringByAppendingString:[BatterHelp gethexBybinary:gs584relationships.count]];
    }else{
        btnNum =[BatterHelp gethexBybinary:gs584relationships.count];
    }
    length+=1;//button num
    
    NSString * shortcut = @"";
    
    for (int i = 0;i<gs584relationships.count;i++){
        
        
        
        NSString * eqid = @"";
        NSString * dessid = @"";
        if ([((GS584RelationShip *)[gs584relationships objectAtIndex:i]).eqid integerValue] < 16){  //new mid
            eqid = [@"000" stringByAppendingString:[BatterHelp gethexBybinary:[((GS584RelationShip *)[gs584relationships objectAtIndex:i]).eqid integerValue]]];
        }else{
            eqid =[@"00" stringByAppendingString:[BatterHelp gethexBybinary:[((GS584RelationShip *)[gs584relationships objectAtIndex:i]).eqid integerValue]]];
        }
        
        if ([((GS584RelationShip *)[gs584relationships objectAtIndex:i]).action integerValue] < 16){  //new mid
            dessid = [NSString stringWithFormat:@"%@%@%@",@"0",((GS584RelationShip *)[gs584relationships objectAtIndex:i]).action,@"000000"];
        }else{
            dessid =[NSString stringWithFormat:@"%@%@",((GS584RelationShip *)[gs584relationships objectAtIndex:i]).action,@"000000"];
        }
        
        shortcut = [shortcut stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",eqid,dessid,@"00"]];
        length += 7;
    }
    
    //self-define scene num
    length+=1;
    int scene =0;
    //scene id
    NSString *sceneCode =@"";
    if(scenerelationships.count>0){
        for(int i = 0; i<scenerelationships.count;i++){
                    scene++;
                    length++;
                    NSString *singleCode =@"";
                    if ([([scenerelationships objectAtIndex:i]) integerValue] < 16){  //new mid
                        singleCode = [@"0" stringByAppendingString:[BatterHelp gethexBybinary:[[scenerelationships objectAtIndex:i] integerValue]]];
                    }else{
                        singleCode =[BatterHelp gethexBybinary:[[scenerelationships objectAtIndex:i] integerValue]];
                    }
                    sceneCode = [sceneCode stringByAppendingString:singleCode];
                

        }
    }else {
        sceneCode = @"";
    }
    //增加了颜色的定制
    length+=1;
    
    NSString *oooo =@"0";
    NSString *coc = [BatterHelp gethexBybinary:(length+32)];
    for (int i = 0 ; i<4-coc.length-1;i++ ){
            oooo = [oooo stringByAppendingString:@"0"];
    }
    oooo = [oooo stringByAppendingString:coc];
    
    NSString *oo = @"0";
    if(scene < 16){
        oo = [oo stringByAppendingString:[BatterHelp gethexBybinary:scene]];
    }else{
        oo = [BatterHelp gethexBybinary:scene];
    }
    
    NSString *ds;
    if([systemModel.sence_group integerValue] <=2){
        ds =     [NameHelper getASCIIFromName:@""];
    }else{
        ds =     [NameHelper getASCIIFromName:systemModel.systemname];
    }

    
    
    NSString *fullCode = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",oooo,@"0",id2,ds,btnNum,oo,shortcut,sceneCode,systemModel.color];
    return fullCode;
}

+(NSString *)getContentFromTimer:(TimerModel *)timerModel{
    NSString *time = @"";
    
        time = [BatterHelp gethexBybinary:[timerModel.timerid intValue]];
    if (time.length == 1) {
        time = [@"0" stringByAppendingString:time];
    }
    
    //使能
    time = [time stringByAppendingString:[NSString stringWithFormat:@"%02d",[timerModel.enable intValue]]];
    
    //情景模式
    time = [time stringByAppendingString:[NSString stringWithFormat:@"%02d",[timerModel.sid intValue]]];
    
    //周次
    time = [time stringByAppendingString:[timerModel.week length] < 2 ? [NSString stringWithFormat:@"0%@", timerModel.week]: timerModel.week];
    
    //时间
    NSString *Hhex = [BatterHelp gethexBybinary:[timerModel.hour intValue]];
    NSString *Mhex = [BatterHelp gethexBybinary:[timerModel.min intValue]];
    NSString *hm = [NSString stringWithFormat:@"%@%@",[Hhex length] < 2?[NSString stringWithFormat:@"0%@",Hhex]:Hhex,[Mhex length] < 2?[NSString stringWithFormat:@"0%@",Mhex]:Mhex];
    time = [time stringByAppendingString:hm];
    

    return time;
}


+ (NSString *)getContentFromScene:(NSMutableArray *)outarray inputAraary:(NSMutableArray *)inarray type:(NSString *)type name:(NSString *)name sceneid:(NSNumber *)sceneid{
    int contentLength = 2;
    
    NSString *content;
    //自定义编号

    content = [BatterHelp gethexBybinary:[sceneid intValue]];

    if (content.length<2) {
        content = [@"0" stringByAppendingString:content];
    }
    contentLength += 1;
    
    //情景名称
    content = [content stringByAppendingString:[NameHelper getASCIIFromName:name]];
    contentLength += 32;
    
    //条件选择
    content = [content stringByAppendingString:type];

    contentLength += 1;
    
    //定时
    NSString *weekTime = @"00";
    NSString *hourTime = @"00";
    NSString *minuteTime = @"00";
    
    for (SceneListItemData *item in inarray) {
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
    if ([self isClickItem:inarray]) {
        content = [content stringByAppendingString:@"AB"];
    }else{
        content = [content stringByAppendingString:@"FF"];
    }
    contentLength += 1;
    
    //手机通知
    if ([self isPhoneItem:outarray]) {
        content = [content stringByAppendingString:@"AC"];
    }else{
        content = [content stringByAppendingString:@"FF"];
    }
    contentLength += 1;
    
    //输入设备个数
    NSString *inCount = [BatterHelp gethexBybinary:[self deviceNumbaer:inarray]];
    if (inCount.length < 2) {
        inCount = [@"0" stringByAppendingString:inCount];
    }
    content = [content stringByAppendingString:inCount];
    contentLength += 1;
    
    //输出设备个数
    NSString *outCount = [BatterHelp gethexBybinary:[self deviceNumbaer:outarray]];
    if (outCount.length < 2) {
        outCount = [@"0" stringByAppendingString:outCount];
    }
    content = [content stringByAppendingString:outCount];
    contentLength += 1;
    
    //输入设备内容
    for (SceneListItemData *item in inarray) {
        if (item.eqid) {
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
    for (int i = 0 ; i < outarray.count ;i++) {
        
        SceneListItemData *item = outarray[i];
        
        if (item.eqid && [item.eqid intValue] >= 0 && (![item.type isEqualToString:@"delay"])&& (![item.type isEqualToString:@"phone"]) && (![item.type isEqualToString:@"add"])) {
            
            if (i == 0) {
                content = [content stringByAppendingString:@"0000"];
            }else{
                SceneListItemData *lastItem = outarray[i-1];
                if ([lastItem.type isEqualToString:@"delay"]) {
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
        if ([item.type isEqualToString:@"phone"] ) {
            return YES;
        }
    }
    return NO;
}

+ (int)deviceNumbaer:(NSMutableArray *)array{
    int number = 0;
    for (SceneListItemData *item in array) {
        if (item.eqid && [item.eqid intValue] >= 0 && ![item.type isEqualToString:@"delay"]) {
            number ++;
        }
    }
    return number;
}
@end
