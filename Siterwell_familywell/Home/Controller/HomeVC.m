//
//  UIViewController+HomeVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/2/23.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HomeVC.h"
#import "DeviceListVC.h"
@implementation HomeVC

-(void)viewDidLoad{
    [self.navigationController setNavigationBarHidden:YES];
}

//登录主界面
- (IBAction)ToDeviceList:(id)sender {
    
    DeviceListVC *devcelistvc = [[DeviceListVC alloc] init];
    [self.navigationController pushViewController:devcelistvc animated:YES];
}

@end
