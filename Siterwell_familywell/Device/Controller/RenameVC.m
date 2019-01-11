//
//  RenameVC.m
//  sHome
//
//  Created by shap on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "RenameVC.h"
#import "RenameCell.h"
#import "UINavigationBar+Awesome.h"
#import "RenameDeviceApi.h"
#import "DBGatewayManager.h"
#import "DBDeviceManager.h"
#import "Single.h"
@interface RenameVC ()
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UITableView *table;
@property (nonatomic,strong) GatewayModel *gateway;
@end

@implementation RenameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    _gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    self.title = NSLocalizedString(@"重命名", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(53, 167, 255)];
    [self table];
}

- (void)rightItem{

    
    RenameDeviceApi *apirename = [[RenameDeviceApi alloc] initWithDevTid:_gateway.devTid CtrlKey:_gateway.ctrlKey DeviceId:[_deviceId intValue]  DeviceName:_textField.text ConnectHost:_gateway.connectHost];
    [Single sharedInstanced].command = EditDeviceName;
    [apirename startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
      
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAnswerOK) name:@"answer_ok" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    //移除观察者 self
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dismiss{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RenameCell *cell = [[RenameCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"renameCell"];
    _textField = cell.field;
    _textField.placeholder = NSLocalizedString(@"请输入新的命名", nil) ;
    @weakify(self)
    [[_textField.rac_textSignal filter:^BOOL(id value) {
        @strongify(self);
        NSString *text = value;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        return text.length > 0;
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma -mark lazy
-(UITableView *)table{
    if(_table==nil){
        
    }
    return _table;
}

#pragma -mark method
-(void)onAnswerOK{
    if([Single sharedInstanced].command == EditDeviceName){
        [Single sharedInstanced].command = -1;
        [[DBDeviceManager sharedInstanced] updateDeviceName:_deviceId withName:_textField.text withDevTid:_gateway.devTid];
        [self dismiss];
    }
}

@end
