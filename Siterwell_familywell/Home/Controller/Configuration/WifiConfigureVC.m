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
@property (nonatomic,assign) UIButton *remberPsdButton;
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
        cell.hidenBtn.hidden = YES;
    }else{
        cell.labeltitle.hidden = YES;
        cell.field.hidden = NO;
        [cell.image_title setImage:[UIImage imageNamed:@"password_icon"]];
        cell.field.placeholder = NSLocalizedString(@"请输入新密码", nil);
        _psdTextFiled = cell.field;
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        NSString *psw = [config objectForKey:[NSString stringWithFormat:@"st_wifi_%@",[HekrConfig getWifiName]]];
        if(![NSString isBlankString:psw]){
            cell.field.text = psw;
        }
        
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
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [[UIView alloc] init];
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

        UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 200, 50);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"jzmm_noselect"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"jzmm_select"] forState:UIControlStateSelected];
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitle:NSLocalizedString(@"记住密码", nil) forState:UIControlStateNormal];
    //button标题的偏移量，这个偏移量是相对于图片的
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.titleLabel.textAlignment = UITextAlignmentLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //设置button正常状态下的标题颜色
    button.tag = 1;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(remember:) forControlEvents:UIControlEventTouchUpInside];
    [nilView addSubview:button];
    
    _remberPsdButton = button;
    [_remberPsdButton setSelected:YES];
       UIButton*  _btn = [[UIButton alloc] initWithFrame:CGRectZero];
        _btn.backgroundColor = ThemeColor;
        _btn.layer.cornerRadius = 10;
        _btn.tag = 2;
        [_btn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(remember:) forControlEvents:UIControlEventTouchUpInside];
        [nilView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(200);
            make.centerX.equalTo(nilView.mas_centerX);
            make.top.equalTo(button.mas_bottom).offset(20);
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


-(void)remember:(UIButton *)sender{
    if(sender.tag == 1){
            sender.selected = !sender.selected;
    }else if(sender.tag==2){
        if([NSString isBlankString:[HekrConfig getWifiName]]){
            [MBProgressHUD showError:NSLocalizedString(@"无WIFI", nil) ToView:self.view];
            return;
        }
        
        if([NSString isBlankString:_psdTextFiled.text]){
            [MBProgressHUD showError:NSLocalizedString(@"请输入WIFI密码", nil) ToView:self.view];
            return;
        }
        if(_remberPsdButton.selected)
        {
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setObject:_psdTextFiled.text forKey:[NSString stringWithFormat:@"st_wifi_%@",[HekrConfig getWifiName]]];
        }
        connectWifiVC *connectvc = [[connectWifiVC alloc] init];
        connectvc.apSsid = [HekrConfig getWifiName];
        connectvc.apPwd = _psdTextFiled.text;
        [self.navigationController pushViewController:connectvc animated:YES];
    }

}
@end
