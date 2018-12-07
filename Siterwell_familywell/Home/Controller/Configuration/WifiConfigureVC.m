//
//  WifiConfigureVC.m
//  Siterwell_familywell
//
//  Created by tracyhenry on 2018/11/5.
//  Copyright © 2018 iMac. All rights reserved.
//

#import "WifiConfigureVC.h"
#import "WifiContentCell.h"
#import "HekrConfig.h"
#import "connectWifiVC.h"
@interface WifiConfigureVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (strong, nonatomic) UITextField *psdTextFiled;
@end
@implementation WifiConfigureVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"配置WIFI", nil);
    [self table];
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellId = @"cell";
    WifiContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WifiContentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    if(indexPath.row == 0){
        [cell.image_title setImage:[UIImage imageNamed:@"wifi_icon"]];
        cell.labeltitle.hidden = NO;
        cell.field.hidden = YES;
        cell.labeltitle.text = [HekrConfig getWifiName];
    }else{
        cell.labeltitle.hidden = YES;
        cell.field.hidden = NO;
        [cell.image_title setImage:[UIImage imageNamed:@"password_icon"]];
        cell.field.placeholder = NSLocalizedString(@"请输入新密码", nil);
        _psdTextFiled = cell.field;
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
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [[UIView alloc] init];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

        UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
        
       UIButton*  _btn = [[UIButton alloc] initWithFrame:CGRectZero];
        _btn.backgroundColor = ThemeColor;
        _btn.layer.cornerRadius = 10;
        [_btn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nilView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(200);
            make.centerX.equalTo(nilView.mas_centerX);
            make.top.equalTo(nilView.mas_top).offset(20);
        }];
        
        return nilView;
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
-(void)next{
    
    if([NSString isBlankString:[HekrConfig getWifiName]]){
        [MBProgressHUD showError:NSLocalizedString(@"无WIFI", nil) ToView:self.view];
        return;
    }
    
    if([NSString isBlankString:_psdTextFiled.text]){
        [MBProgressHUD showError:NSLocalizedString(@"请输入WIFI密码", nil) ToView:self.view];
        return;
    }
    
    connectWifiVC *connectvc = [[connectWifiVC alloc] init];
    connectvc.apSsid = [HekrConfig getWifiName];
    connectvc.apPwd = _psdTextFiled.text;
    [self.navigationController pushViewController:connectvc animated:YES];
}
@end
