//
//  BaseTableVC.m
//  sHome
//
//  Created by shaop on 2016/12/17.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseTableVC.h"

@interface BaseTableVC ()

@end

@implementation BaseTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delaysContentTouches = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    btn.backgroundColor = [UIColor redColor];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title withTintColor:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTintColor:color];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    CGRect frame = btn.frame;
    frame.size = CGSizeMake(40, 20);
    btn.frame = frame;
//    btn.backgroundColor = [UIColor redColor];
//    btn.frame = CGRectMake(0, 0, 44, 44);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
