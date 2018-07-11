//
//  CircleMenuVc.m
//  sHome
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "CircleMenuVc.h"

@interface CircleMenuVc ()

@end

@implementation CircleMenuVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Modify buttons' style in circle menu
    //  for (UIButton * button in [self.menu subviews])
    //    [button setAlpha:.95f];
    
    [self.view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KYCircleMenu Button Action
- (void)runButtonActions:(UITapGestureRecognizer*)sender {
    
    [super runButtonActions:sender];
    
    self.clickedMenu(((UIView*)sender.view).tag);
}


@end
