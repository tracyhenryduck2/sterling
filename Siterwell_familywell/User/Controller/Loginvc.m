//
//  UIViewController+Loginvc.m
//  mytest4
//
//  Created by iMac on 2018/2/6.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "Loginvc.h"
#import "SiterTools.h"
#import "Register.h"
#import "InitController.h"
@interface Loginvc()
@property (nonatomic,weak) IBOutlet UIButton *savePsdbtn;
@property (nonatomic,weak) IBOutlet UIButton *login;
@property (nonatomic,weak) IBOutlet UITextField *username;
@property (nonatomic,weak) IBOutlet UITextField *pwd;
@property (nonatomic,weak) IBOutlet UIButton *seePwd;
@end

@implementation Loginvc


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    _login.layer.cornerRadius = 17.5f;
    [_pwd setSecureTextEntry:YES];
    [_savePsdbtn setImage:[UIImage imageNamed:@"unselect_remember"] forState:UIControlStateNormal];
    [_savePsdbtn setImage:[UIImage imageNamed:@"select_remember"] forState:UIControlStateSelected];
    [_savePsdbtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];

    [_seePwd setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
    [_seePwd setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateSelected];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *username = [config objectForKey:@"UserName"];
    NSString *password = [config objectForKey:@"Password"];
    NSNumber *rem = [config objectForKey:@"RememberLoginPasswd"];
    
    
    if ([rem integerValue] == 1) {
        _username.text = username;
        _pwd.text = password;
        [_savePsdbtn setSelected:YES];
    }else{
        _username.text = username;
        [_savePsdbtn setSelected:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    
}

//切换密码可见
- (IBAction)seePasswordAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    self.pwd.secureTextEntry = !sender.selected;
    
}

//记住密码
- (IBAction)savePasswordAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setSelected:![btn isSelected]];
   
}

//登录主界面
- (IBAction)Login:(id)sender {
    
    
    [MBProgressHUD showMessage:NSLocalizedString(@"加载中", nil) ToView:self.view];
    WS(ws)
    [[Hekr sharedInstance] login:_username.text password:_pwd.text callbcak:^(id user, NSError *error) {
        if (!error) {
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            
            [config setObject:_username.text forKey:@"UserName"];
            [config setObject:_pwd.text forKey:@"Password"];
            if (self.savePsdbtn.selected) {
                [config setObject:@1 forKey:@"RememberLoginPasswd"];
            }else{
                [config setObject:@0 forKey:@"RememberLoginPasswd"];
            }
            [config synchronize];
            InitController* test2obj = [[InitController alloc] init];
            test2obj.flag_login = YES;
            AppDelegateInstance.window.rootViewController = test2obj;

        }
        else{
            [MBProgressHUD hideHUDForView:ws.view animated:YES];
            
            if (error.code == -1011) {
                [MBProgressHUD showError:NSLocalizedString(@"用户名密码错误", nil) ToView:ws.view];
            }else{
                [MBProgressHUD showError:NSLocalizedString(@"网络错误", nil) ToView:ws.view];
            }
            
        }
    }];
    
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"toRegister"]){
        
        Register *resetcodeviewcontroller = segue.destinationViewController;
        resetcodeviewcontroller.refresh =^(NSString *value, NSString *value2){
            _username.text = value;
            _pwd.text = value2;
        };
    }

}

@end
