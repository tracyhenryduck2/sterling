//
//  EditEmergentPhoneVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "EditEmergentPhoneVC.h"
#import "EditPhoneCell.h"
@interface EditEmergentPhoneVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UITextField *phonefield;
@end
@implementation EditEmergentPhoneVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"紧急号码", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(save) image:@"yes_icon" highImage:@"yes_icon" withTintColor:ThemeColor];
    [self table];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellId = @"cell";
    EditPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[EditPhoneCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    _phonefield = cell.field;
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.text = NSLocalizedString(@"可以是您或您亲近的人的手机号码。可以在单个设备详情页点击“紧急电话”进行拨打。", nil);
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(13);
        make.right.equalTo(view.mas_right).offset(-13);
        make.height.equalTo(50);
        make.top.equalTo(view.mas_top).offset(6);
    }];
    
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

#pragma mark -lazy

- (UITableView *)table {
    
    if(!_table){
        _table= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = 50;
        _table.bounces = NO;
        _table.separatorInset = UIEdgeInsetsZero;
        _table.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(64);
        }];
    }
    
    return _table;
}

#pragma -mark method
-(void)save{
    NSDictionary *dic = @{
                          @"description" : _phonefield.text,
                          };
    
    [MBProgressHUD showLoadToView:GetWindow];
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"%@/user/profile", https] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile", https] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            [MBProgressHUD showSuccess:NSLocalizedString(@"设置成功", nil) ToView:GetWindow];
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setValue:responseObject forKey:UserInfos];
            [config synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
            [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
    }];
}
@end
