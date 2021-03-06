//
//  CRCqueueHelp.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/30.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "CRCqueueHelp.h"

@implementation CRCqueueHelp



+(NSString *)getDeviceCRCContent:(NSMutableArray *)deviceArray{
    
    int maxId = 0;
    for (ItemData *data in deviceArray) {
        if ([data.device_ID intValue] > maxId) {
            maxId = [data.device_ID intValue];
        }
    }
    NSString *content = @"";
    content = [NSString stringWithFormat:@"%@",[BatterHelp gethexBybinary:(maxId*2 +2)]];
    int length = (int)content.length;
    
    for (int i = 0; i < 4 - length; i++) {
        content = [@"0" stringByAppendingString:content];
    }
    
    for (int i = 1 ; i<=maxId; i++) {
        bool hasDevice = NO;
        for (ItemData *data in deviceArray) {
            if ([data.device_ID intValue]  == i) {
                
                NSString *name = data.device_status;
                
                name = [BatterHelp getDeviceCRCCode:name];
                
                content = [content stringByAppendingString:name];
                hasDevice = YES;
                break;
            }
        }
        if (!hasDevice) {
            content = [content stringByAppendingString:@"0000"];
        }
    }
    
    return content;
}

+(NSString *)getSystemSceneCRCContent:(NSMutableArray *)slist withDevTid:(NSString *)devTid {
    NSString *getSceneGroupCRC=@"",*num=@"";
    
    if(slist.count>0){
        int codeLength = 2;
        NSMutableArray * sid = [[NSMutableArray alloc] init];
        for(SystemSceneModel *e in slist){
            [sid addObject:e.sence_group];
        }
        SystemSceneModel * dd = (SystemSceneModel *)[slist objectAtIndex:(slist.count-1)];
        for(int i = 0 ; i < [dd.sence_group integerValue]+1; i++) {//for here come with "0" , used slist.size()
            codeLength += 2;
            if ([sid containsObject:[NSNumber numberWithInt:i]]) {
           
                NSMutableArray<SceneRelationShip *>  *SceneRelationList = [[DBSceneReManager sharedInstanced] queryGS584RelationShip:[NSNumber numberWithInt:i] withDevTid:devTid];
                SystemSceneModel *sysModelBean = (SystemSceneModel *)[slist objectAtIndex:[sid indexOfObject:[NSNumber numberWithInt:i]]];
                NSString * name = sysModelBean.systemname;
                int length = 0;
                
                length = 0;
                length += 2;//the total num length
                
                NSNumber * id2 = sysModelBean.sence_group;
                length += 1;//the scene id
                
                NSString * btnNum = @"";
                NSMutableArray <GS584RelationShip *>* shortcutlist = [[DBGS584RelationShipManager sharedInstanced] queryAllGS584RelationShipwithDevTid:devTid withSid:[NSNumber numberWithInt:i]];
                
                if ([BatterHelp gethexBybinary:shortcutlist.count].length<2){  //new mid
                    btnNum = [@"0" stringByAppendingString:[BatterHelp gethexBybinary:shortcutlist.count]];
                }else{
                    btnNum =[BatterHelp gethexBybinary:shortcutlist.count];
                }
                length+=1;//button num
                
                NSString * shortcut = @"";
                
                for (int j = 0;j<shortcutlist.count;j++){
                    
                    
                    
                    NSString *eqid = @"";
                    NSString *dessid = @"";
                    if (  [BatterHelp gethexBybinary:[shortcutlist[j].sid intValue]].length<2){  //new mid
                        eqid = [@"000" stringByAppendingString:[BatterHelp gethexBybinary:[shortcutlist[j].sid intValue]]];
                    }else{
                        eqid =[@"00" stringByAppendingString:[BatterHelp gethexBybinary:[shortcutlist[j].sid intValue]]];
                    }
                    
                    if ([BatterHelp gethexBybinary:[shortcutlist[j].action intValue]].length<2){  //new mid
                        dessid =[NSString stringWithFormat:@"%@%@%@",@"0",[BatterHelp gethexBybinary:[shortcutlist[j].action intValue]],@"000000"];
                    }else{
                        dessid =[NSString stringWithFormat:@"%@%@",[BatterHelp gethexBybinary:[shortcutlist[j].action intValue]],@"000000"];
                    }
                    
                    shortcut= [NSString stringWithFormat:@"%@%@%@",eqid,dessid,@"00"];
                    length += 7;
                }
                
                NSString * color = sysModelBean.color;
                length+=1;
                //self-define scene num
                length += 1;
                int scene = 0;
                //scene id
                NSString * sceneCode = @"";
                for (int j = 0; j < SceneRelationList.count; j++) {
                    scene++;
                    length++;
                    NSString * singleCode = @"";
                    
                    if ( [BatterHelp gethexBybinary:[SceneRelationList[j].mid intValue]].length<2) {  //new mid
                        singleCode = [@"0" stringByAppendingString: [BatterHelp gethexBybinary:[SceneRelationList[j].mid intValue]]];
                    } else {
                        singleCode = [BatterHelp gethexBybinary:[SceneRelationList[j].mid intValue]];
                    }
                    sceneCode = [sceneCode stringByAppendingString: singleCode];
                }
                NSString * oooo = @"0";
                if ([BatterHelp gethexBybinary:(length + 32)].length < 4) {
                    for (int k = 0; k < 4 - [BatterHelp gethexBybinary:(length + 32)].length - 1; k++) {
                        oooo = [oooo stringByAppendingString:@"0"];
                    }
                    oooo = [oooo stringByAppendingString:[BatterHelp gethexBybinary:(length + 32)]];
                } else {
                    oooo = [BatterHelp gethexBybinary:(length + 32)];
                }
                
                NSString * oo = @"0";
                if ([BatterHelp gethexBybinary:(scene)].length < 2) {
                    oo = [oo stringByAppendingString:[BatterHelp gethexBybinary:(scene)]];
                } else {
                    oo = [BatterHelp gethexBybinary:(scene)];
                }
                NSString * ds = @"";
                if([id2 integerValue] <=2){
                    ds =     [NameHelper getASCIIFromName:@""];
                }else{
                    ds =     [NameHelper getASCIIFromName:name];
                }
                
                
                NSString * fullCode = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", oooo,@"0",id2,ds,btnNum,oo,shortcut,sceneCode,color ];
                getSceneGroupCRC = [getSceneGroupCRC stringByAppendingString:[SystemSceneModel getCRCFromContent:fullCode]];
                
            }else {
               getSceneGroupCRC = [getSceneGroupCRC stringByAppendingString:@"0000"];
            }
        }
        NSString *oooo = @"0";
        int totalLength = codeLength ;

        if ([BatterHelp gethexBybinary:(totalLength)].length < 4) {
            for (int i = 0; i < 4 - [BatterHelp gethexBybinary:(totalLength)].length-1; i++) {
                oooo = [oooo stringByAppendingString:@"0"];
            }
            num = [oooo stringByAppendingString: [BatterHelp gethexBybinary:(totalLength)]];
        } else {
            num = [BatterHelp gethexBybinary:(totalLength)];
        }
        return [num stringByAppendingString:getSceneGroupCRC];
    }else{
        return @"00040000";
    }
}

+(NSString *)getSceneCRCContent:(NSMutableArray *)sceneList {
    

    if(sceneList != nil && sceneList.count>0) {
        
        NSString * oooo = @"0", *num = @"";
        int codeLength = 2;

        int listLength = [((SceneModel *)[sceneList objectAtIndex:(sceneList.count-1)]).scene_type intValue];
        NSMutableArray <NSNumber *>* eqid = [[NSMutableArray alloc] init];
        for (SceneModel *e in sceneList) {
            [eqid addObject:e.scene_type];
        }
        NSString * sceneCRC = @"";
        for (int i = 1; i <= listLength; i++) {
            codeLength += 2;
            if ([eqid containsObject:[NSNumber numberWithInt:i]]) {

                NSString *ds =  ((SceneModel *)[sceneList objectAtIndex:[eqid indexOfObject:[NSNumber numberWithInt:i]]]).scene_content;
                
                NSString * crc = [SceneModel getCRCFromContent:ds];
                sceneCRC = [sceneCRC stringByAppendingString: crc];
            } else {
               sceneCRC = [sceneCRC stringByAppendingString: @"0000"];
            }
        }

        
        int totalLength = codeLength ;

        if ([BatterHelp gethexBybinary:totalLength].length< 4) {
            for (int i = 0; i < 4 - [BatterHelp gethexBybinary:totalLength].length-1; i++) {
                oooo = [oooo stringByAppendingString:@"0"];
            }
            num =[oooo stringByAppendingString:[BatterHelp gethexBybinary:totalLength]];
        } else {
            num = [BatterHelp gethexBybinary:totalLength];
        }
        return [num stringByAppendingString:sceneCRC];
    }else {
        return @"00040000";
    }
    
    return nil;
}

+(NSString *)getTimerCRCS:(NSMutableArray <TimerModel *>*)slist withDevTid:(NSString *)devTid{
    NSString *getSceneGroupCRC=@"",*num = @"";
    if(slist.count>0) {
        int codeLength = 2;
        NSMutableArray<NSNumber *> *tid = [[NSMutableArray alloc] init];
        for (TimerModel * e in slist) {
            [tid addObject:e.timerid];
        }
        
        
        for (int i = 0; i <[[slist objectAtIndex:(slist.count - 1)].timerid intValue]+1; i++) {//for here come with "0" , used slist.size()
            codeLength += 2;
            BOOL flag = NO;
            for(NSNumber *d in tid){
                if([d intValue] == i){
                    flag = YES;
                    TimerModel *mo = [[DBTimerManager sharedInstanced] queryTimer:[NSNumber numberWithInt:i] withDevTid:devTid];
                    NSString *timecotent =[ContentHepler getContentFromTimer:mo];
                    getSceneGroupCRC = [getSceneGroupCRC stringByAppendingString:[BatterHelp getTimerSceneCRCCode:timecotent]];
                    break;
                }
            }
            if(flag == NO){
                getSceneGroupCRC = [getSceneGroupCRC stringByAppendingString:@"0000"];
            }
        }
        
        
        NSString *oooo = @"0";
        
        NSString *lengthhex = [BatterHelp gethexBybinary:codeLength];
        
        if (lengthhex.length < 4) {
            for (int i = 0; i < 4 - lengthhex.length - 1; i++) {
               oooo = [oooo stringByAppendingString:@"0"];
            }
            num = [NSString stringWithFormat:@"%@%@",oooo,lengthhex ];
        } else {
            num = lengthhex;
        }
        return [NSString stringWithFormat:@"%@%@",num,getSceneGroupCRC ];
    }else {
        return @"0000";
    }
}
@end
