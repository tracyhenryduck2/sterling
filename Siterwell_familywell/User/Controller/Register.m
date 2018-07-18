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
@property (strong, nonatomic)  YYLabel *RuleLabel;
@property (nonatomic,weak) UITextField *number;
@property (nonatomic,weak) UITextField *verifycode;
@property (nonatomic,weak) UITextField *passwd;
@property (nonatomic,weak) UITextField *passwdcofirm;
@property (nonatomic,strong) UIButton *registBtn;
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc] init];
    self.registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.registBtn.layer.cornerRadius = 17.5f;
    self.registBtn.backgroundColor = RGB(53, 167, 255);
    [self.registBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [self.registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registBtn addTarget:self action:@selector(registers) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.registBtn];
    
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(26);
        make.right.equalTo(view.mas_right).offset(-26);
        make.top.equalTo(view.mas_top).offset(13);
        make.height.equalTo(@35);
    }];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"注册即视为同意服务条款", nil)];
    text.yy_font = [UIFont systemFontOfSize:13];
    text.yy_color = [UIColor darkGrayColor];
    
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:RGB(198, 198, 198)];
    [highlight setFont:[UIFont boldSystemFontOfSize:13]];
    [highlight setUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle]];
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [self performSegueWithIdentifier:@"toInstruction" sender:nil];
    };
    [text yy_setColor:RGB(51, 51, 51) range:NSMakeRange(0, text.length)];
    [text yy_setFont:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, text.length)];
    [text yy_setTextUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle] range:NSMakeRange(0, text.length)];
    [text yy_setTextHighlight:highlight range:NSMakeRange(0, text.length)];
    
    self.RuleLabel = [YYLabel new];
    self.RuleLabel.attributedText = text;
    self.RuleLabel.numberOfLines = 2;
    self.RuleLabel.backgroundColor = [UIColor clearColor];
    self.RuleLabel.textAlignment = NSTextAlignmentCenter;
    self.RuleLabel.userInteractionEnabled = YES;
    [view addSubview:self.RuleLabel];
    
    WS(ws)
    [self.RuleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(ws.registBtn.mas_bottom).offset(13);
        make.height.equalTo(@60);
    }];
    
    return view;
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
    
    if (flag_register_type&&_number.text.length == 0) {
        [MBProgressHUD showMessage:NSLocalizedString(@"请输入邮箱号", nil) ToView:self.view RemainTime:1.1f];
        return;
    }
    
    if(!flag_register_type&&![NSString  isPhoneNumber:_number.text]){
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
         [self getVerifyCode:responseObject[@"captchaToken"] withNumber:_number.text];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];
}


- (void)getVerifyCode:(NSString *)token withNumber:(NSString *)number {
    
    NSString * type = flag_register_type? Hekr_getEmailVerifyCode:Hekr_getSmsVerifyCode;
    
    [[Hekr sharedInstance].sessionWithDefaultAuthorization GET:[NSString stringWithFormat:type,ApiMap[@"uaa-openapi.hekr.me"],number,HekrPID,Hekr_REGISTER,token] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showMessage:NSLocalizedString(@"发送成功", nil) ToView:self.view RemainTime:1.1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];
}

-(void)registers{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:NSLocalizedString(@"请稍后...", nil) ToView:self.view];
    if([NSString isBlankString:self.number.text] || [NSString isBlankString:self.verifycode.text]
       || [NSString isBlankString:self.passwd.text] || [NSString isBlankString:self.passwdcofirm.text]){
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NSLocalizedString(@"请输入完整信息", nil) ToView:self.view];
        return;
    }


    //邮箱正则表达判断
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", regex];
    if (![predicate evaluateWithObject:_number.text] && flag_register_type){
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NSLocalizedString(@"邮箱格式错误", nil) ToView:self.view];
        return;
    }

    if(![self.passwd.text isEqualToString:self.passwdcofirm.text]){
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:NSLocalizedString(@"密码输入不一致", nil) ToView:self.view];
        return;
    }


    NSDictionary *param1 = @{
                             @"pid" :HekrPID,
                             @"phoneNumber": self.number.text,
                             @"password" :self.passwd.text,
                             @"code" : self.verifycode.text
                             };
    NSDictionary *param2 = @{
                             @"pid" :HekrPID,
                             @"email": self.number.text,
                             @"password" :self.passwd.text,
                             @"code" : self.verifycode.text
                             };
    NSString *url = (flag_register_type?Hekr_Register_by_Email:Hekr_Register_by_Phone);
    @weakify(self)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:url, ApiMap[@"uaa-openapi.hekr.me"]] parameters:(flag_register_type?param2:param1) progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:NSLocalizedString(@"注册成功", nil) ToView:GetWindow];
        self.refresh(self.number.text, self.passwd.text);
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
