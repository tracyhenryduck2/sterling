//
//  SceneModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SceneModel_h
#define SceneModel_h
#import "JSONModel+HekrDic.h"
@interface SceneModel:JSONModel
@property(nonatomic,strong) NSString * scene_content;
@property(nonatomic,strong) NSNumber * scene_type;

@property(nonatomic,strong) NSString<Ignore> * devTid;
@property (nonatomic, strong) NSString<Ignore> *scene_name;
@property (nonatomic, strong) NSString<Ignore> *isShouldClick;

@property (nonatomic, strong) NSMutableArray<Ignore> *scene_outdevice_array;

@property (nonatomic, strong) NSMutableArray<Ignore> *scene_indevice_array;
@property (nonatomic, strong) NSString<Ignore> *scene_select_type;

+ (NSString *)getCRCFromContent:(NSString *)answer_content;
@end

#endif /* SceneModel_h */
