//
//  DeviceDetailVC.h
//  sHome
//
//  Created by shaop on 2016/12/19.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseVC.h"
#import "ItemData.h"

typedef NS_ENUM(NSInteger, DeviceStatus) {
    DeviceStatusGZ= 0,
    DeviceStatusAQ = 1,
    DeviceStatusNO = 2,
    DeviceStatusBJ = 3
};
@interface DeviceDetailVC : BaseVC


@property (nonatomic, strong) ItemData *data;


@end
