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

+(NSString *)getContentFromScene:(SceneModel *)sceneModel{
    return nil;
}

@end
