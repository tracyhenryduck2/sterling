//
//  ResetCode.m
//  mytest4
//
//  Created by iMac on 2018/2/21.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ResetCode.h"
#import "Macros.h"
#import "ResetCell.h"
#import "VerifyCodeAlertView.h"

@interface ResetCode()

@property (nonatomic,weak) IBOutlet UITableView *uitable2;

@property (nonatomic,weak) UITextField *number2;
@property (nonatomic,weak) UITextField *verifycode2;
@property (nonatomic,weak) UITextField *passwd2;
@property (nonatomic,weak) UITextField *passwdcofirm2;
@end


@implementation ResetCode{
    BOOL flag_register_type;
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(switchRegisterType) Title:NSLocalizedString(@"邮箱重置",nil) withTintColor:RGB(53, 167, 255)];
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
    ResetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resetCell" forIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.aGetCodeBtn.hidden = YES;
        cell.ahidenBtn.hidden = YES;
        
        if(flag_register_type==NO){
            cell.atextField.placeholder = NSLocalizedString(@"请输入手机号", nil);
        }else{
            cell.atextField.placeholder = NSLocalizedString(@"请输入邮箱号", nil);
        }
        _number2 = cell.atextField;
    }else if(indexPath.row==1) {
        cell.aGetCodeBtn.hidden = NO;
        cell.ahidenBtn.hidden = YES;
        cell.atextField.placeholder = NSLocalizedString(@"请输入验证码", nil);
        _verifycode2 = cell.atextField;
        [cell.aGetCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    }else if(indexPath.row==2) {
        cell.aGetCodeBtn.hidden = YES;
        cell.ahidenBtn.hidden = NO;
        cell.atextField.placeholder = NSLocalizedString(@"请输入密码", nil);
        cell.atextField.secureTextEntry = YES;
        _passwd2 = cell.atextField;
    }else if(indexPath.row==3) {
        cell.aGetCodeBtn.hidden = YES;
        cell.ahidenBtn.hidden = NO;
        cell.atextField.placeholder = NSLocalizedString(@"请确认密码", nil);
        cell.atextField.secureTextEntry = YES;
        _passwdcofirm2 = cell.atextField;
    }
    cell.atextField.borderStyle = UITextBorderStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}


#pragma mark - method
-(void)switchRegisterType{
    
    if(flag_register_type==NO){
        flag_register_type=YES;
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(switchRegisterType) Title:NSLocalizedString(@"手机重置",nil) withTintColor:RGB(53, 167, 255)];
    }else{
        flag_register_type=NO;
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(switchRegisterType) Title:NSLocalizedString(@"邮箱重置",nil) withTintColor:RGB(53, 167, 255)];
    }
    [_uitable2 reloadData];
    
    [_number2 setText:@""];
    [_verifycode2 setText:@""];
    
}


- (void)sendVerifyCode {
    if (!flag_register_type&&_number2.text.length == 0) {
        [MBProgressHUD showMessage:NSLocalizedString(@"请输入手机号", nil) ToView:self.view RemainTime:1.1f];
        return;
    }
    
    if(![NSString  isPhoneNumber:_number2.text]){
        [MBProgressHUD showMessage:NSLocalizedString(@"手机号非法格式", nil) ToView:self.view RemainTime:1.1f];
        return;
    }
    
    [self.view endEditing:YES];
    VerifyCodeAlertView *alert = [[VerifyCodeAlertView alloc] initWithTarget:self Title:NSLocalizedString(@"输入图形验证码", nil) Content:nil CancelButtonTitle:@"" DetermineButtonTitle:@"" toView:self.view.window];
    [alert cy_alertShow];
    [alert cy_clickCancelButton:^{
        
    } determineButton:^{
        [self checkCaptchaCode:alert.captchaTF.text];
    }];
}

- (void)checkCaptchaCode:(NSString *)code {
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:Hekr_checkCode,ApiMap[@"uaa-openapi.hekr.me"],Hekr_rid,code] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self getVerifyCode:responseObject[@"captchaToken"] withNumber:_number2.text];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];
}


- (void)getVerifyCode:(NSString *)token withNumber:(NSString *)number {
    
    NSString * type = flag_register_type? Hekr_getEmailVerifyCode:Hekr_getSmsVerifyCode;
    
    [[Hekr sharedInstance].sessionWithDefaultAuthorization GET:[NSString stringWithFormat:type,ApiMap[@"uaa-openapi.hekr.me"],number,HekrPID,Hekr_RESET_PASSWORD,token] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showMessage:NSLocalizedString(@"发送成功", nil) ToView:self.view RemainTime:1.1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];
}

@end
