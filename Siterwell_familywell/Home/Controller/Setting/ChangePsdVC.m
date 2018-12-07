//
//  ChangePsdVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ChangePsdVC.h"
#import "ChangePsdCell.h"
@interface ChangePsdVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UITextField *oldcodefield;
@property (nonatomic,strong) UITextField *newcodefield;
@end
@implementation ChangePsdVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"修改密码", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(save) image:@"yes_icon" highImage:@"yes_icon" withTintColor:ThemeColor];
    [self table];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellId = @"cell";
    ChangePsdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ChangePsdCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    if(indexPath.row == 0){
        _oldcodefield = cell.field;
        cell.field.placeholder = NSLocalizedString(@"请输入旧密码", nil);
    }else{
        _newcodefield = cell.field;
        cell.field.placeholder = NSLocalizedString(@"请输入新密码", nil);
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [[UIView alloc] init];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

#pragma mark -lazy

- (UITableView *)table {
    
    if(!_table){
        _table= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = 50;
        _table.separatorInset = UIEdgeInsetsZero;
        _table.tableFooterView = [[UIView alloc] init];
        _table.backgroundColor = RGB(239, 239, 243);
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(10);
        }];
    }
    
    return _table;
}


#pragma -mark method
-(void)save{
    //判断密码长度6-14位
    if (_oldcodefield.text.length<6||_newcodefield.text.length>14) {
        [MBProgressHUD showError:NSLocalizedString(@"密码长度错误", nil) ToView:GetWindow];
        return;
    }
    
    
    [MBProgressHUD showMessage:NSLocalizedString(@"请稍候", nil) ToView:GetWindow];
    NSString *https = (ApiMap==nil?@"https://uaa-openapi.hekr.me":ApiMap[@"uaa-openapi.hekr.me"]);
    
    @weakify(self)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/changePassword", https] parameters:@{@"pid":HekrPID,@"newPassword":_newcodefield.text,@"oldPassword":_oldcodefield.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        [config setObject:_newcodefield.text forKey:@"Password"];
        [config synchronize];
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        [MBProgressHUD showSuccess:NSLocalizedString(@"修改成功", nil) ToView:GetWindow];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
    }];
}
@end

