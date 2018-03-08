//
//  UIViewController+Loginvc.m
//  mytest4
//
//  Created by iMac on 2018/2/6.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "Loginvc.h"
#import "AppDelegate.h"
#import "SiterTools.h"

@interface Loginvc()
@property (nonatomic,weak) IBOutlet UIButton *test1;
@property (nonatomic,weak) IBOutlet UIButton *savePsdbtn;
@property (nonatomic,weak) IBOutlet UIButton *login;
@property (nonatomic,weak) IBOutlet UITextField *username;
@property (nonatomic,weak) IBOutlet UITextField *pwd;
@end

@implementation Loginvc


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem =  [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"ok", nil) withTintColor:RGB(53, 167, 255)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.title = @"ddd";
    [self.navigationController setNavigationBarHidden:YES];
    _login.layer.cornerRadius = 17.5f;
    [_pwd setSecureTextEntry:YES];
    [_savePsdbtn setImage:[UIImage imageNamed:@"unselect_remember"] forState:UIControlStateNormal];
    [_savePsdbtn setImage:[UIImage imageNamed:@"select_remember"] forState:UIControlStateSelected];
    [_savePsdbtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)];
    [_savePsdbtn setSelected:YES];
}


//记住密码
- (IBAction)savePasswordAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setSelected:![btn isSelected]];
   
}

//登录主界面
- (IBAction)Login:(id)sender {
    
    UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* test2obj = [uistoryboard instantiateViewControllerWithIdentifier:@"testvc"];  //
    AppDelegate* appDelagete = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelagete.window.rootViewController = test2obj;
}

@end
