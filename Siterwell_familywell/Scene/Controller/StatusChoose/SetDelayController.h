//
//  SetDelayController.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SetDelayController_h
#define SetDelayController_h
#import "SceneListItemData.h"
@interface SetDelayController:BaseVC
@property (nonatomic , strong) RACSubject *delegate;
@property (nonatomic , strong) SceneListItemData *data;
@end

#endif /* SetDelayController_h */
