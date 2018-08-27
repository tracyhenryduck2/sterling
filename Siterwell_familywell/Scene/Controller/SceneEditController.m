//
//  SceneEditController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneEditController.h"
@interface SceneEditController()

@property (nonatomic,strong) UITextField *titleTextFiled;

@end

@implementation SceneEditController{
    int dsa;
}

#pragma -mark life
-(void)viewDidLoad{
     [super viewDidLoad];
    UITextField * enterTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width-60, 30)];
    enterTextField.backgroundColor = RGB(242, 242, 245);
    enterTextField.layer.cornerRadius = 15.0f;
    enterTextField.placeholder = NSLocalizedString(@"请输入自定义情景名称", nil);
    CGRect frame = enterTextField.frame;
    frame.size.width = 20;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    enterTextField.leftViewMode = UITextFieldViewModeAlways;
    enterTextField.leftView = leftview;
    _titleTextFiled = enterTextField;
    self.navigationItem.titleView = enterTextField;
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(backfinish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

-(void)viewDidAppear:(BOOL)animated{
    
}


#pragma -mark method
-(void)backfinish{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
