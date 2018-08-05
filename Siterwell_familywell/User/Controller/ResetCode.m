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
#import "HekrHttpsApi.h"

@interface ResetCode()

@property (nonatomic,weak) IBOutlet UITableView *uitable2;

@property (nonatomic,weak) UITextField *number2;
@property (nonatomic,weak) UITextField *verifycode2;
@property (nonatomic,weak) UITextField *passwd2;
@property (nonatomic,weak) UITextField *passwdcofirm2;
@property (nonatomic,strong) UIButton *resetBtn;
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
        [self.navigationController setNavigationBarHidden:NO];
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc] init];
    self.resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.resetBtn.layer.cornerRadius = 17.5f;
    self.resetBtn.backgroundColor = RGB(53, 167, 255);
    [self.resetBtn setTitle:NSLocalizedString(@"重置", nil) forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.resetBtn];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(26);
        make.right.equalTo(view.mas_right).offset(-26);
        make.top.equalTo(view.mas_top).offset(13);
        make.height.equalTo(@35);
    }];
    return view;
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
    
    if((!flag_register_type)&&(![NSString  isPhoneNumber:_number2.text]) ){
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

-(void)reset{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:NSLocalizedString(@"请稍后...", nil) ToView:self.view];
    if([NSString isBlankString:self.number2.text] || [NSString isBlankString:self.verifycode2.text]
       || [NSString isBlankString:self.passwd2.text] || [NSString isBlankString:self.passwdcofirm2.text]){
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NSLocalizedString(@"请输入完整信息", nil) ToView:self.view];
        return;
    }
    
    
    //邮箱正则表达判断
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", regex];
    if (![predicate evaluateWithObject:_number2.text] && flag_register_type){
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NSLocalizedString(@"邮箱格式错误", nil) ToView:self.view];
        return;
    }
    
    if(![self.passwd2.text isEqualToString:self.passwdcofirm2.text]){
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NSLocalizedString(@"密码输入不一致", nil) ToView:self.view];
        return;
    }
    
    
    NSDictionary *param1 = @{
                             @"pid" :HekrPID,
                             @"phoneNumber": self.number2.text,
                             @"password" :self.passwd2.text,
                             @"verifyCode" : self.verifycode2.text
                             };
    NSDictionary *param2 = @{
                             @"pid" :HekrPID,
                             @"email": self.number2.text,
                             @"password" :self.passwd2.text,
                             @"verifyCode" : self.verifycode2.text
                             };
    NSString *url = (flag_register_type?Hekr_Reset_by_Email:Hekr_Reset_by_Phone);
    @weakify(self)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:url, ApiMap[@"uaa-openapi.hekr.me"]] parameters:(flag_register_type?param2:param1) progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:NSLocalizedString(@"重置成功", nil) ToView:GetWindow];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        
        UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:[ErrorCodeUtil getMessageWithCode:model.code] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVc addAction:action1];
        [self presentViewController:alertVc animated:YES completion:nil];
    }];
    
    
}
@end
