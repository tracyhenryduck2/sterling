//
//  CYMarquee.h
//  sHome
//
//  Created by CY on 2018/3/26.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewWeatherModel.h"
#import "ItemData.h"

@interface CYMarquee : UIView

@property (nonatomic) NSArray<ItemData *> *tempAndHumArray;

@property (nonatomic) NewWeatherModel *model;

@property (nonatomic) NSString *address;

@end
