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

@interface TimerListController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray <TimerModel *>*timer_arry;
@property (nonatomic,assign) BOOL refresh;
@end

@implementation TimerListController

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 239, 243);
    self.title = NSLocalizedString(@"定时", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(gotoAdd) Title:NSLocalizedString(@"添加", nil) withTintColor:ThemeColor];
    _timer_arry = [NSMutableArray new];
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    
    _timer_arry = [[DBTimerManager sharedInstanced] queryAllTimers:currentgateway2];
    [_timer_arry enumerateObjectsUsingBlock:^(TimerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setName:[obj getTimerSenceNameBySenceGroup:currentgateway2]];
    }];
    
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
            make.top.equalTo(74);
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
        NSLog(@"点击咯咯%d",tag);
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
    if([Single sharedInstanced].command == AddTimerSwitch){
        [Single sharedInstanced].command = -1;
        
    }
}
@end
