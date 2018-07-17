//
//  SystemSceneModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SystemSceneModel_h
#define SystemSceneModel_h
@interface SystemSceneModel:JSONModel
@property (nonatomic, strong) NSString *answer_content;
@property(strong,nonatomic) NSString * systemname;
@property(nonatomic)        NSInteger   choice;
@property(nonatomic,assign) NSString * sid;
@property(nonatomic,assign) NSString * color;
@property(nonatomic,assign) NSString * devTid;
@end

#endif /* SystemSceneModel_h */
