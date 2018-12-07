//
//  SettingController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SettingController.h"
#import "DBGatewayManager.h"
#import "AboutVC.h"
#import "GatewayListVC.h"
#import "ChangePsdVC.h"
#import "EmergentPhoneVC.h"
#import "ChooseLocationVC.h"
#import "BeforeConfigurationVC.h"

@interface SettingController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSArray *titles;
@property (nonatomic,strong) UITableView *table;
@end

@implementation SettingController

#pragma mark -life
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"配置", nil);
    self.titles = @[NSLocalizedString(@"当前网关", nil), NSLocalizedString(@"修改密码", nil), NSLocalizedString(@"网关配置", nil), NSLocalizedString(@"定位设置", nil),NSLocalizedString(@"紧急号码", nil),NSLocalizedString(@"新增摄像头", nil),NSLocalizedString(@"系统说明书", nil),NSLocalizedString(@"关于", nil) ];
    [self table];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(finish) image:@"arrow_down" highImage:nil withTintColor:[UIColor blackColor]];
}
-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [[self table] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        NSString *cellId = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.5];
        cell.textLabel.text = self.titles[indexPath.row];
        if (indexPath.row == 0) {
            NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
            NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
            GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
            if([gatewaymodel.deviceName isEqualToString:@"报警器"]){
              cell.detailTextLabel.text = [NSLocalizedString(@"我的家", nil) stringByAppendingString:[NSString stringWithFormat:@"(%@)",[gatewaymodel.devTid substringWithRange:NSMakeRange(gatewaymodel.devTid.length-4, 4)]]];
            }else{
                   cell.detailTextLabel.text = [gatewaymodel.deviceName stringByAppendingString:[NSString stringWithFormat:@"(%@)",[gatewaymodel.devTid substringWithRange:NSMakeRange(gatewaymodel.devTid.length-5, 4)]]];
            }
         
        }
        
        return cell;
    }else{
        NSString *cellId = @"loginoutCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = NSLocalizedString(@"退出登录", nil);
        
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                [self gotoGatewaylist];
                break;
            case 1:
                [self gotoChangePsd];
                break;
            case 2:
                [self gotoConfigGateway];
                break;
            case 3:
                [self gotoLocation];
                break;
            case 4:
                [self gotoEmergency];
                break;
            case 5:
                
                break;
            case 6:
                [self gotoSystem];
                break;
            case 7:
                [self gotoAbout];
                break;
            default:
                break;
        }
    }else{
        
        [[Hekr sharedInstance] logout];
        UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        AppDelegateInstance.window.rootViewController = [uistoryboard instantiateInitialViewController];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [[UIView alloc] init];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return _titles.count;
    }else {
        return 1;
    }
  
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

-(void)finish{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)gotoLocation{
    ChooseLocationVC *laction = [[ChooseLocationVC alloc] init];
    [self.navigationController pushViewController:laction animated:YES];
}

-(void)gotoAbout{
        AboutVC *about = [[AboutVC alloc] init];
    [self.navigationController pushViewController:about animated:YES];
}

-(void)gotoConfigGateway{
    BeforeConfigurationVC *about = [[BeforeConfigurationVC alloc] init];
    [self.navigationController pushViewController:about animated:YES];
}

-(void)gotoGatewaylist{
    GatewayListVC *listvc = [[GatewayListVC alloc] init];
    listvc.setting_to = YES;
    [self.navigationController pushViewController:listvc animated:YES];
}

-(void)gotoSystem{
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if ([languageName containsString:@"zh"]) {
        
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"http://www.china-siter.cn/company_detail.html?introId=17"];
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:URL options:@{}
               completionHandler:^(BOOL success) {
                   //NSLog(@"Open %@: %d",scheme,success);
               }];
        } else {
            BOOL success = [application openURL:URL];
            //NSLog(@"Open %@: %d",scheme,success);
        }
    } else {
        
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"http://www.china-siter.com/company_detail.html?introId=17"];
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:URL options:@{}
               completionHandler:^(BOOL success) {
               }];
        } else {
            BOOL success = [application openURL:URL];
        }
        
    }
}

-(void)gotoChangePsd{
    ChangePsdVC *listvc = [[ChangePsdVC alloc] init];
    [self.navigationController pushViewController:listvc animated:YES];
}

-(void)gotoEmergency{
    EmergentPhoneVC *vc = [[EmergentPhoneVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
