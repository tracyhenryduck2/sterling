//
//  GatewayListVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/21.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "GatewayListVC.h"
#import "DBGatewayManager.h"
#import "DBSystemSceneManager.h"
#import "GatewayListView.h"
#import "ChangeGatewayNameVC.h"
@interface GatewayListVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray <GatewayModel *> * list_gateway;
@property (nonatomic,copy) NSString *current_devTid;
@property (nonatomic,strong) NSMutableArray <GatewayModel *> * gateways;
@end
@implementation GatewayListVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    _gateways = [[NSMutableArray alloc] init];
    self.title = NSLocalizedString(@"网关列表", nil);
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(finish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
    [self table];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    _list_gateway = [[DBGatewayManager sharedInstanced] queryAllGateway];
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    _current_devTid = currentgateway2;
    [[self table] reloadData];
    [self getGateways];
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
        NSString *cellId = @"cell";
        GatewayListView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[GatewayListView alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        GatewayModel *model = [_list_gateway objectAtIndex:indexPath.row];
        if([model.deviceName isEqualToString:@"报警器"]){
            cell.titleLabel.text = NSLocalizedString(@"我的家", nil);
        }else{
            cell.titleLabel.text = model.deviceName;
        }
       cell.subtitleLabel.text = model.devTid;
    if([_current_devTid isEqualToString:model.devTid]){
              cell.selectImageView.image = [UIImage imageNamed:@"yes_icon"];
    }else{
               cell.selectImageView.image = [UIImage imageNamed:@""];
    }
       cell.online_status.text = NSLocalizedString(@"在线", nil);
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
    
    return _list_gateway.count;
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    UITableViewRowAction * rdsa = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"编辑", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        [self editName:indexPath];
    }];
    
    UITableViewRowAction * rdsa2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"解除绑定", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        //        [self deleteAction:indexPath];
    }];
    
    return @[rdsa,rdsa2];
    
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
    if(_setting_to){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)getGateways{
    @weakify(self)
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *currentdomain = [config objectForKey:@"hekr_domain"];
    NSString *baseurl = [NSString isBlankString:currentdomain]?@"https://user-openapi.hekr.me":[NSString stringWithFormat:@"%@%@",@"https://user-openapi.",currentdomain];
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device", baseurl] parameters:@{@"page":@(0),@"size":@(20)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSArray *arr = responseObject;
        if (arr.count>0) {
            for(int i=0;i<arr.count;i++){
                GatewayModel * ds = [[GatewayModel alloc] initWithDictionary:[arr objectAtIndex:i] error:nil];
                ds.connectHost = [arr objectAtIndex:i][@"dcInfo"][@"connectHost"];
                [_gateways addObject:ds];
            }
            if(arr.count == 20){
                [self getGateways];
            }else{
                [self getChooseGateway];
            }
        }else{
            [[DBGatewayManager sharedInstanced] deleteGatewayTable];
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setObject:nil forKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
            [config synchronize];
            UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AppDelegateInstance.window.rootViewController = [uistoryboard instantiateInitialViewController];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self getChooseGateway];
    }];
}

-(void)getChooseGateway{
    
    NSMutableArray <GatewayModel *>*gatewjiulist = [[DBGatewayManager sharedInstanced] queryAllGateway];
    [gatewjiulist enumerateObjectsUsingBlock:^(GatewayModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL falg = false;
        
        for(int i=0;i<_gateways.count;i++){
            if([obj.devTid isEqualToString:[_gateways objectAtIndex:i].devTid]
               &&[obj.ctrlKey isEqualToString:[_gateways objectAtIndex:i].ctrlKey]
               &&[obj.bindKey isEqualToString:[_gateways objectAtIndex:i].bindKey]){
                falg = true;
                break;
            }
        }
        if(!falg){
            [[DBGatewayManager sharedInstanced] deleteGateway:obj.devTid];
        }
    }];
    
    [[DBGatewayManager sharedInstanced] insertGateways:_gateways];
    for(int i=0;i<_gateways.count;i++){
        GatewayModel * gateway = [_gateways objectAtIndex:i];
        
        SystemSceneModel * sys = [[SystemSceneModel alloc] init];
        sys.systemname=@"";
        sys.sence_group = @0;
        sys.choice = @0;
        sys.devTid = gateway.devTid;
        sys.color = @"F0";
        
        SystemSceneModel * sys1 = [[SystemSceneModel alloc] init];
        sys1.systemname=@"";
        sys1.sence_group = @1;
        sys1.choice = @0;
        sys1.devTid = gateway.devTid;
        sys1.color = @"F1";
        
        SystemSceneModel * sys2 = [[SystemSceneModel alloc] init];
        sys2.systemname=@"";
        sys2.sence_group = @2;
        sys2.choice = @0;
        sys2.devTid = gateway.devTid;
        sys2.color = @"F2";
        
        NSArray *arr2=[[NSArray alloc]initWithObjects:sys,sys1,sys2, nil];
        
        [[DBSystemSceneManager sharedInstanced] insertSystemScenesInit:arr2];
    }
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway = [config objectForKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
    
    if([NSString isBlankString:currentgateway]){
        if(_gateways.count>0){
            for(GatewayModel *d in _gateways){
                if([d.online isEqualToString:@"1"]){
                    [config setObject:d.devTid forKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
                    break;
                }
            }
        }
    }else{
        if(_gateways.count>0){
            BOOL flag_contain = NO;
            NSString * will = nil;
            for(GatewayModel *d in _gateways){
                
                if([d.online isEqualToString:@"1"] && will == nil){
                    will = d.devTid;
                }
                
                if([d.devTid isEqualToString:currentgateway]){
                    flag_contain = YES;
                    break;
                }
            }
            
            if(!flag_contain){
                
                if(will == nil){
                    will = [_gateways objectAtIndex:0].devTid;
                }
                [config setObject:will forKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
            }
        }
    }
    [config synchronize];
    [_gateways removeAllObjects];

    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
 
    _current_devTid = currentgateway2;
   _list_gateway = [[DBGatewayManager sharedInstanced] queryAllGateway];
    [[self table] reloadData];
}

-(void)editName:(NSIndexPath *) index{
    
    ChangeGatewayNameVC *vc = [[ChangeGatewayNameVC alloc] init];
    GatewayModel *ds = [_list_gateway objectAtIndex:index.row];
    vc.devTid = ds.devTid;
    vc.ctrlKey = ds.ctrlKey;
    vc.delegate = [RACSubject subject];
    @weakify(self);
    [vc.delegate subscribeNext:^(id x) {
        @strongify(self);
        [self getGateways];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
