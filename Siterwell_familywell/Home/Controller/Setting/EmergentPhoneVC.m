//
//  EmergentPhoneVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "EmergentPhoneVC.h"
#import "EditEmergentPhoneVC.h"
#import "UserInfoModel.h"
@interface EmergentPhoneVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UserInfoModel *usermodel;
@end
@implementation EmergentPhoneVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"紧急号码", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(save) image:@"pen_icon" highImage:@"pen_icon" withTintColor:ThemeColor];
    [self table];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    _usermodel = [[UserInfoModel alloc] initWithDictionary:[config objectForKey:UserInfos] error:nil];
    [[self table] reloadData];
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = NSLocalizedString(@"点击拨打", nil);
    if (_usermodel!=nil && ![NSString isBlankString:_usermodel.emergencyNumber]) {
        cell.detailTextLabel.text = _usermodel.emergencyNumber;
    }else{
        cell.detailTextLabel.text = NSLocalizedString(@"未设置", nil);
    }

    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:[config objectForKey:UserInfos] error:nil];
    if (![NSString isBlankString:model.emergencyNumber]) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.emergencyNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"紧急号码为空",nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"设置",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
            [self save];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
    EditEmergentPhoneVC *vc =[[EditEmergentPhoneVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
