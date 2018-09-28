//
//  ContentHepler.h
//  Siterwell_familywell
//
//  Created by iMac on 2018/8/26.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef ContentHepler_h
#define ContentHepler_h
#import "SystemSceneModel.h"
#import "GS584RelationShip.h"
#import "SceneRelationShip.h"
#import "SceneModel.h"
#import "BatterHelp.h"
#import "NameHelper.h"
#import "SceneListItemData.h"

@interface ContentHepler : NSObject

+(NSString *)getContentFromSystem:(SystemSceneModel *)systemModel withSceneRelationShip:(NSMutableArray *)scenerelationships withGS584Relations:(NSMutableArray *)gs584relationships;

+(NSString *)getContentFromScene:(SceneModel *)sceneModel;

+(NSString *)getContentFromScene:(NSMutableArray *)outarray inputAraary:(NSMutableArray *)inarray type:(NSString *)type name:(NSString *)name sceneid:(NSNumber *)sceneid;
@end

#endif /* ContentHepler_h */
