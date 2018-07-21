//
//  siterwellsdk.h
//  siterwellsdk
//
//  Created by TracyHenry on 2018/6/19.
//  Copyright © 2018年 ST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BatterHelp.h"
#import "SystemSceneModel.h"
#import <HekrAPI.h>

@protocol SiterwellDelegate;

@interface SiterwellReceiver : NSObject

@property (nonatomic,strong) id<SiterwellDelegate> siterwelldelegate;

-(void) recv:(id) obj callback:(void(^)(id obj,id data,NSError*)) block;
@end


@protocol SiterwellDelegate

-(void) onlinestatus:(NSString *)devTid;

-(void) onUpdateOnSystemScene:(SystemSceneModel *) systemscenemodel;

@end
