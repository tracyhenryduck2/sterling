//
//  AddDeviceVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/22.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "AddDeviceVC.h"
#import "CancelAddingApi.h"
#import "DBGatewayManager.h"
#import "AddDeviceCell.h"
#import "AddDeviceApi.h"
@interface AddDeviceVC ()<UITableViewDelegate , UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableview;

@end

@implementation AddDeviceVC


#pragma -mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];

    if ([_type isEqualToString:@"update"]) {
        self.title = NSLocalizedString(@"替换设备",nil);
    }else{
        self.title = NSLocalizedString(@"添加设备",nil);
        GatewayModel * gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
        AddDeviceApi *api = [[AddDeviceApi alloc] initWithDevTid:gateway.devTid CtrlKey:gateway.ctrlKey ConnectHost:gateway.connectHost];
        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
            
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss:) name:@"addDeviceSuccess" object:nil];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(btndismiss) Title:NSLocalizedString(@"取消",nil) withTintColor:ThemeColor];
    [self tableview];
}

-(void)viewWillAppear:(BOOL)animated{
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = NSLocalizedString(@"请将需要添加的设备按钮快速连按3次", nil);
        return cell;
    }else if(indexPath.row == 1){
        AddDeviceCell *cell = [[AddDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell3"];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell2"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = NSLocalizedString(@"注意！网关绿灯闪烁时,长按网关按钮3秒以上将删除全部设备", nil);
        return cell;
    }
    
}


-(void)dismiss:(NSNotification *)noti {
    if ([_type isEqualToString:@"update"]) {
        
    }
    
}

-(void)btndismiss{
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    
    
    CancelAddingApi *api = [[CancelAddingApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey ConnectHost:gatewaymodel.connectHost];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma -mark lazy

-(UITableView *)tableview{
    if(_tableview==nil){
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.rowHeight = 60;
        _tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _tableview.backgroundColor = RGB(239, 239, 243);
        _tableview.tableFooterView = [UIView new];
        [self.view addSubview:_tableview];
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _tableview;
}
@end
