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
@property (nonatomic,weak) IBOutlet UIButton *test2;
@property (nonatomic,weak) IBOutlet UIButton *login;
@end

@implementation Loginvc


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"语言", nil);
    
    self.navigationItem.rightBarButtonItem =  [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(53, 167, 255)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
//    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"ddd";
    DDLogError(@"eeee");
}


////记住密码
//- (IBAction)savePasswordAction:(id)sender {
//    NSLog(@"test");
//   
//}

//登录主界面
- (IBAction)Login:(id)sender {
    
    UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* test2obj = [uistoryboard instantiateViewControllerWithIdentifier:@"testvc"];  //
    AppDelegate* appDelagete = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelagete.window.rootViewController = test2obj;
}

@end