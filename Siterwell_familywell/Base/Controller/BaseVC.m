//
//  BaseVC.m
//  Qibuer
//
//  Created by shap on 2016/11/25.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage withTintColor:(UIColor *)color
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *img=[UIImage imageNamed:image];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTintColor:color];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize btnSize = CGSizeMake(35, 44);
    CGRect frame = btn.frame;
    frame.size = btnSize;
    btn.frame = frame;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


/**
 自定义navbar按钮

 @param target 目标
 @param action 动作
 @param title 文字
 @param color tint颜色
 @return 按钮
 */
- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title withTintColor:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTintColor:color];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn sizeToFit];
    CGRect frame = btn.frame;
    btn.frame = frame;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
