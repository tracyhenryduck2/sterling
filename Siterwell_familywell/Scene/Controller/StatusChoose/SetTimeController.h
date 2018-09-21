//
//  SetTimeController.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SetTimeController_h
#define SetTimeController_h
#import "SceneListItemData.h"
@interface SetTimeController:BaseVC
@property (nonatomic , strong) RACSubject *delegate;
@property (nonatomic , strong) SceneListItemData *data;
@end

#endif /* SetTimeController_h */
