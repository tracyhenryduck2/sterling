//
//  BaseVC+Detail.h
//  mytest4
//
//  Created by iMac on 2018/2/6.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "BaseVC.h"
//用block回传给上一个页面
typedef void(^valueBlock)(NSString *value,NSString *value2);

@interface Register : BaseVC
@property (nonatomic,strong) valueBlock refresh;
@end
