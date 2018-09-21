//
//  NormalStatusVC.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/7.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef NormalStatusVC_h
#define NormalStatusVC_h
#import "SceneListItemData.h"
@interface NormalStatusVC:BaseVC

@property (nonatomic,strong) SceneListItemData *data;
@property (nonatomic , strong) RACSubject *delegate;
@end

#endif /* NormalStatusVC_h */
