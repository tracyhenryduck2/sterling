//
//  SystemSceneModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SystemSceneModel_h
#define SystemSceneModel_h
#import "JSONModel+HekrDic.h"
#import "GS584RelationShip.h"
#import "SceneRelationShip.h"
@interface SystemSceneModel:JSONModel
@property (nonatomic, strong) NSString *answer_content;
@property (nonatomic, strong) NSString *sence_group;
@property(strong,nonatomic) NSString<Ignore> * systemname;
@property(nonatomic)        NSNumber<Ignore> *choice;
@property(nonatomic,assign) NSString<Ignore>  * color;
@property(nonatomic,assign) NSString<Ignore> * devTid;
@property (nonatomic) NSNumber<Ignore> *dev584Count;

@property (nonatomic) NSMutableArray<Ignore> *dev584List;

@property (nonatomic) NSNumber<Ignore> *sceneCount;

@property (nonatomic) NSMutableArray<Ignore> *sceneRelationShip;
+ (NSString *)getCRCFromContent:(NSString *)answer_content;
-(void)settotalDevTid:(NSString<Ignore> *)devTid;
@end

#endif /* SystemSceneModel_h */
