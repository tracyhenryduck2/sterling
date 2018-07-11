//
//  CircleMenuVc.h
//  sHome
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "KYCircleMenu.h"

@interface CircleMenuVc : KYCircleMenu

@property (strong, nonatomic) void(^clickedMenu)(NSInteger tag);

@end
