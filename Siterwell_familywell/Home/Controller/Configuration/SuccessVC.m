//
//  SuccessVC.m
//  sHome
//
//  Created by shaop on 2017/1/12.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SuccessVC.h"
#import "SuccessView.h"
#import "HomeVC.h"
@interface SuccessVC ()

@end

@implementation SuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    SuccessView *suc = [[SuccessView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    suc.center = self.view.center;
    [self.view addSubview:suc];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        UIViewController *target = nil;
        for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[HomeVC class]]) { //这里判断是否为你想要跳转的页面
                target = controller;
            }
        }
        if (target) {
            [self.navigationController popToViewController:target animated:YES]; //跳转
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
