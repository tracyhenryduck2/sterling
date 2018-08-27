//
//  CollectionController.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef CollectionController_h
#define CollectionController_h
@interface CollectionController:BaseVC

@property (nonatomic , copy) NSString * selectType;
@property (nonatomic , strong) RACSubject *delegate;

@end

#endif /* CollectionController_h */
