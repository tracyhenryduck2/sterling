//
//  BaseVC+Detail.m
//  mytest4
//
//  Created by iMac on 2018/2/6.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "Register.h"
#import "Macros.h"
#import "RegistCell.h"
#import "VerifyCodeAlertView.h"

@interface Register()

@property (nonatomic,weak) IBOutlet UITableView *uitable1;

@property (nonatomic,weak) UITextField *number;
@property (nonatomic,weak) UITextField *verifycode;
@property (nonatomic,weak) UITextField *passwd;
@property (nonatomic,weak) UITextField *passwdcofirm;
@end


@implementation Register{
    BOOL flag_register_type;
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(switchRegisterType) Title:NSLocalizedString(@"邮箱注册",nil) withTintColor:RGB(53, 167, 255)];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registCell" forIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.GetCodeBtn.hidden = YES;
        cell.hidenBtn.hidden = YES;

        if(flag_register_type==NO){
        cell.titleTextField.placeholder = NSLocalizedString(@"请输入手机号", nil);
        }else{
        cell.titleTextField.placeholder = NSLocalizedString(@"请输入邮箱号", nil);
        }
        _number = cell.titleTextField;
    }else if(indexPath.row==1) {
        cell.GetCodeBtn.hidden = NO;
        cell.hidenBtn.hidden = YES;
        cell.titleTextField.placeholder = NSLocalizedString(@"请输入验证码", nil);
        _verifycode = cell.titleTextField;
        [cell.GetCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    }else if(indexPath.row==2) {
        cell.GetCodeBtn.hidden = YES;
        cell.hidenBtn.hidden = NO;
        cell.titleTextField.placeholder = NSLocalizedString(@"请输入密码", nil);
        cell.titleTextField.secureTextEntry = YES;
        _passwd = cell.titleTextField;
    }else if(indexPath.row==3) {
        cell.GetCodeBtn.hidden = YES;
        cell.hidenBtn.hidden = NO;
        cell.titleTextField.placeholder = NSLocalizedString(@"请确认密码", nil);
        cell.titleTextField.secureTextEntry = YES;
        _passwdcofirm = cell.titleTextField;
    }
     cell.titleTextField.borderStyle = UITextBorderStyleNone;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}


#pragma mark - method
-(void)switchRegisterType{
    
    if(flag_register_type==NO){
        flag_register_type=YES;
                self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(switchRegisterType) Title:NSLocalizedString(@"手机注册",nil) withTintColor:RGB(53, 167, 255)];
    }else{
        flag_register_type=NO;
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(switchRegisterType) Title:NSLocalizedString(@"邮箱注册",nil) withTintColor:RGB(53, 167, 255)];
    }
    [_uitable1 reloadData];
    
    [_number setText:@""];
    [_verifycode setText:@""];

}

- (void)sendVerifyCode {
    if (!flag_register_type&&_number.text.length == 0) {
        [MBProgressHUD showMessage:NSLocalizedString(@"请输入手机号", nil) ToView:self.view RemainTime:1.1f];
        return;
    }
    
    if(![NSString  isPhoneNumber:_number.text]){
        [MBProgressHUD showMessage:NSLocalizedString(@"手机号非法格式", nil) ToView:self.view RemainTime:1.1f];
        return;
    }
    
    [self.view endEditing:YES];
    VerifyCodeAlertView *alert = [[VerifyCodeAlertView alloc] initWithTarget:self Title:NSLocalizedString(@"输入图形验证码", nil) Content:nil CancelButtonTitle:@"" DetermineButtonTitle:@"" toView:self.view.window];
    [alert cy_alertShow];
    [alert cy_clickCancelButton:^{
        
    } determineButton:^{
        //[self checkCaptchaCode:alert.captchaTF.text];
    }];
}


@end
