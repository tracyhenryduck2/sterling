//
//  SceneModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SceneModel_h
#define SceneModel_h

@interface SceneModel:JSONModel
@property(strong,nonatomic) NSString * scenename;
@property(nonatomic,assign) NSString * code;
@property(nonatomic,assign) NSString * mid;
@property(nonatomic,assign) NSString * devTid;
@property(nonatomic,assign) NSString * desc;
@end

#endif /* SceneModel_h */
