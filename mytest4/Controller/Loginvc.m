//
//  UIViewController+Loginvc.m
//  mytest4
//
//  Created by iMac on 2018/2/6.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "Loginvc.h"
#import "Macros.h"

@interface Loginvc()

@end

@implementation Loginvc


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"语言", nil);
    
    self.navigationItem.rightBarButtonItem =  [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(53, 167, 255)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}


@end
