//
//  ChangeGatewayNameVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ChangeGatewayNameVC.h"
#import "EditPhoneCell.h"
@interface ChangeGatewayNameVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UITextField *namefield;
@end
@implementation ChangeGatewayNameVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"修改网关名称", nil);
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
    _namefield = cell.field;
    cell.field.placeholder = NSLocalizedString(@"请输入名称", nil);
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
    
    return 1;
    
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
    if ([_namefield.text isEqualToString:@""]||_namefield.text == nil) {
        [MBProgressHUD showError:NSLocalizedString(@"名称不能为空", nil) ToView:GetWindow];
        return;
    }
    NSDictionary *dic = @{
                          @"deviceName" : _namefield.text,
                          @"desc" : @"1",
                          @"ctrlKey" : _ctrlKey
                          };
    
    [MBProgressHUD showLoadToView:GetWindow];
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PATCH:[NSString stringWithFormat:@"%@/device/%@", https, _devTid] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        [MBProgressHUD showSuccess:NSLocalizedString(@"修改成功", nil) ToView:GetWindow];
        [self.delegate sendNext:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
    }];
}

@end
