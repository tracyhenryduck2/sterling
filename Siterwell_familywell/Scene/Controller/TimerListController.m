//
//  TimerListController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//
#import "TimerListController.h"
#import "TimerSwitchCell.h"
#import "TimerModel.h"
#import "TimerEditController.h"
#import "DBTimerManager.h"
#import "Single.h"
#import "SyncTimerSwitchApi.h"
#import "DBGatewayManager.h"
#import "CRCqueueHelp.h"
#import "ContentHepler.h"
#import "AddTimerSwitchApi.h"
#import "DeleteTimerSwitchApi.h"

@interface TimerListController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray <TimerModel *>*timer_arry;
@property (nonatomic,assign) BOOL refresh;
@property (nonatomic,assign) int index_cache;
@property (nonatomic,strong) TimerModel *timer_cache;
@property (nonatomic,strong) TimerModel *timer_delete;
@end

@implementation TimerListController

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 239, 243);
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    if([NSString isBlankString:currentgateway2]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.title = NSLocalizedString(@"定时", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(gotoAdd) Title:NSLocalizedString(@"添加", nil) withTintColor:ThemeColor];

    
    [self table];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFreshTimer) name:@"refreshtimer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAnswerOK) name:@"answer_ok" object:nil];
    
    if(!_refresh){
        _refresh = YES;
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];

        NSMutableArray *timerss= [[DBTimerManager sharedInstanced] queryAllTimers:currentgateway2];
        
       NSString *timerlistcontent = [CRCqueueHelp getTimerCRCS:timerss withDevTid:currentgateway2];
        SyncTimerSwitchApi *api = [[SyncTimerSwitchApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost Content:timerlistcontent];
        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {

        }];
    }
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    
    _timer_arry = [[DBTimerManager sharedInstanced] queryAllTimers:currentgateway2];
    [_timer_arry enumerateObjectsUsingBlock:^(TimerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setName:[obj getTimerSenceNameBySenceGroup:currentgateway2]];
    }];
    
    [[self table] reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    //移除观察者 self
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -lazy

- (UITableView *)table {
    
    if(!_table){
        _table= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = 70;
        _table.separatorInset = UIEdgeInsetsZero;
        _table.tableFooterView = [[UIView alloc] init];
        _table.backgroundColor = RGB(239, 239, 243);
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(15);
        }];
    }
    
    return _table;
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
        NSString *cellId = @"cell";
        TimerSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[TimerSwitchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            
        }
    TimerModel *timer = [_timer_arry objectAtIndex:indexPath.row];
    [cell setWeek:timer.week];
    [cell setEnable:timer.enable];
    [cell setSceneGroup:timer.name];
    [cell setTime:timer.hour withMin:timer.min];
    [cell.clickBtn setTag:indexPath.row];
    cell.click = ^(int tag) {
        TimerModel *timera = [_timer_arry objectAtIndex:tag];
        NSNumber *enable = timera.enable;
        if([enable intValue] == 0){
            [timera setEnable:@1];
        }else{
            [timera setEnable:@0];
        }
        _index_cache = tag;
        _timer_cache = timera;
        NSString *content = [ContentHepler getContentFromTimer:timera];
        NSString *crc = [BatterHelp getTimerSceneCRCCode:content];
        
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        [Single sharedInstanced].command = TimerSwitchEnable;
        GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
        
        AddTimerSwitchApi *api = [[AddTimerSwitchApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost Content:[NSString stringWithFormat:@"%@%@",content,crc]];
        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
            
        }];
    };

        return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TimerModel *model = [_timer_arry objectAtIndex:indexPath.row];
    TimerEditController *editer = [[TimerEditController alloc] init];
    editer.timerid = model.timerid;
    [self.navigationController pushViewController:editer animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return _timer_arry.count;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"删除", nil);
}
/**
 cell点击删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _timer_delete = [_timer_arry objectAtIndex:indexPath.row];

    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    [Single sharedInstanced].command = DeleteTimerSwitch;
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    DeleteTimerSwitchApi *api = [[DeleteTimerSwitchApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost Content:_timer_delete.timerid];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        
    }];
    
}

#pragma -mark method
-(void)gotoAdd{
    TimerEditController *edit = [[TimerEditController alloc] init];
    [self.navigationController pushViewController:edit animated:YES];
}

-(void)onFreshTimer{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    
    _timer_arry = [[DBTimerManager sharedInstanced] queryAllTimers:currentgateway2];
    [_timer_arry enumerateObjectsUsingBlock:^(TimerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setName:[obj getTimerSenceNameBySenceGroup:currentgateway2]];
    }];
    
    [[self table] reloadData];
}

-(void)onAnswerOK{
    if([Single sharedInstanced].command == TimerSwitchEnable){
        [Single sharedInstanced].command = -1;
        if(_index_cache>=0){
            NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
            NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
            [_timer_cache setDevTid:currentgateway2];
            [[DBTimerManager sharedInstanced] insertTimer:_timer_cache];
            [_timer_arry setObject:_timer_cache atIndexedSubscript:_index_cache];
            [[self table] reloadData];
            _timer_cache = nil;
            _index_cache = -1;
        }
    }else if([Single sharedInstanced].command == DeleteTimerSwitch){
        [Single sharedInstanced].command = -1;
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        if(_timer_delete!=nil){
            [[DBTimerManager sharedInstanced] deleteTimer:_timer_delete.timerid withDevTid:currentgateway2];
            _timer_delete = nil;
            _timer_arry = [[DBTimerManager sharedInstanced] queryAllTimers:currentgateway2];
            [_timer_arry enumerateObjectsUsingBlock:^(TimerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setName:[obj getTimerSenceNameBySenceGroup:currentgateway2]];
            }];
            [[self table] reloadData];
        }
    }
}
@end
