//
//  TimerEditController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "TimerEditController.h"

@implementation TimerEditController

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = (_timerid==nil?NSLocalizedString(@"添加定时", nil):NSLocalizedString(@"编辑定时", nil));
}

@end
