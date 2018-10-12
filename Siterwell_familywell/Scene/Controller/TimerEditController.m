//
//  TimerEditController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "TimerEditController.h"
#import "PickViewCell.h"
#import "WeekCell.h"
#import "TimerToModeCell.h"
#import "BatterHelp.h"
#import "DBTimerManager.h"
#import "SystemSceneModel.h"
#import "AddTimerSwitchApi.h"
#import "ContentHepler.h"
#import "DBGatewayManager.h"
#import "Single.h"
@interface TimerEditController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIPickerView *pickview_time;
@property (nonatomic , strong) UIPickerView *pickview_mode;
@property (nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *tomodelist;
@property(nonatomic,strong) TimerModel *thistimer;
@property(nonatomic,strong) TimerModel *newtimer;
@end
@implementation TimerEditController

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = (_timerid==nil?NSLocalizedString(@"添加定时", nil):NSLocalizedString(@"编辑定时", nil));
    
    if(_timerid!=nil){
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        _thistimer = [[DBTimerManager sharedInstanced] queryTimer:_timerid withDevTid:currentgateway2];
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(edittimer) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
    
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(backfinish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
    [self tableview];
}


-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAnswerOK) name:@"answer_ok" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    //移除观察者 self
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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


#pragma -mark tableview

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"时/分", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            PickViewCell *cell = [[PickViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickViewCell"];
            self.pickview_time = cell.pickview;
            if(self.thistimer!=nil){
                [cell.pickview selectRow:[self.thistimer.hour intValue] inComponent:0 animated:NO];
                [cell.pickview selectRow:[self.thistimer.min intValue] inComponent:2 animated:NO];
            }
            return cell;
        }
        
    }
    else if(indexPath.section ==1){
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"切换至", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            TimerToModeCell *cell = [[TimerToModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell3"];
            _tomodelist = cell.modelist;
            _pickview_mode = cell.pickview;
            if(self.thistimer!=nil){
                [_tomodelist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SystemSceneModel *ds = [_tomodelist objectAtIndex:idx];
                    if([ds.sence_group intValue] == [self.thistimer.sid intValue]){
                        *stop = YES;
                       [cell.pickview selectRow:idx inComponent:0 animated:NO];
                    }
                }];
            }

            return cell;
        }
    }
    else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell4"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"星期", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            WeekCell *cell = [[WeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weekViewCell"];
            if(self.thistimer!=nil){
                NSString *binweek = [BatterHelp getBinaryByhex:self.thistimer.week];
                cell.week = binweek;
            }
            return cell;
        }
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.row != 0) {
            return 160;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row != 0) {
            return 80;
        }
    }
    
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
    return nilView;
}


#pragma  -mark  method
-(void)onAnswerOK{
    if([Single sharedInstanced].command == AddTimerSwitch){
        [Single sharedInstanced].command = -1;
        if(_newtimer!=nil){
            [[DBTimerManager sharedInstanced] insertTimer:_newtimer];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)edittimer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    WeekCell *vd =(WeekCell *)[[self tableview] cellForRowAtIndexPath:indexPath];
    NSString *shi = [BatterHelp getDecimalBybinary:[vd getWeek]];
    if([shi isEqualToString:@"0"]){
        [MBProgressHUD showError:NSLocalizedString(@"请选择星期", nil) ToView:self.view];
        return;
    }
    NSInteger hour = [self.pickview_time selectedRowInComponent:0];
    NSInteger min = [self.pickview_time selectedRowInComponent:2];
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
   NSMutableArray * ds = [[DBTimerManager sharedInstanced] queryTimer:[NSString stringWithFormat:@"%02ld",hour] withMin:[NSString stringWithFormat:@"%02ld",min] withDevTid:currentgateway2];
    
    int shiji = [shi intValue];
    __block int zuihou = 0;
    [ds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *dsss = obj;
        zuihou = ([[BatterHelp numberHexString:dsss] intValue] &shiji);
    }];
    NSString *hexweek = [BatterHelp gethexBybinary:zuihou];
    NSString *zuihou2 = [BatterHelp getBinaryByhex:hexweek];
    NSUInteger s = zuihou2.length;
    for(int i=0;i<8-s;i++){
        zuihou2 = [@"0" stringByAppendingString:zuihou2];
    }
    
    if([zuihou2 integerValue]!=0 && self.timerid==nil){
        [MBProgressHUD showError:[self setWeekRepeat:zuihou2] ToView:self.view];
        return;
    }
    

    _newtimer = [[TimerModel alloc] init];
    if(self.timerid ==nil){
            [_newtimer setEnable:@1];
    }else{
            [_newtimer setEnable:_thistimer.enable];
    }

    [_newtimer setTimerid:[NSNumber numberWithInt:[self gettid]]];

    NSInteger index = [_pickview_mode selectedRowInComponent:0];
    [_newtimer setSid:((SystemSceneModel *)[_tomodelist objectAtIndex:index]).sence_group];
    NSString *ss = [BatterHelp gethexBybinary:[shi intValue]];
    for(int i = 0;i<2-ss.length;i++){
        ss = [@"0" stringByAppendingString:ss];
    }
    [_newtimer setWeek:ss];
    [_newtimer setHour:[NSString stringWithFormat:@"%02ld",hour]];
    [_newtimer setMin:[NSString stringWithFormat:@"%02ld",min]];
    [_newtimer setDevTid:currentgateway2];
    NSString *content =[ContentHepler getContentFromTimer:_newtimer];
    NSString *crc = [BatterHelp getTimerSceneCRCCode:content];
    [_newtimer setTime:[NSString stringWithFormat:@"%@%@",content,crc ]];
    
    GatewayModel *gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    [Single sharedInstanced].command = AddTimerSwitch;
    AddTimerSwitchApi *api = [[AddTimerSwitchApi alloc] initWithDevTid:gateway.devTid CtrlKey:gateway.ctrlKey Domain:gateway.connectHost Content:[NSString stringWithFormat:@"%@%@",content,crc ]];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        
    }];
}

-(void)backfinish{
    if(self.timerid==nil){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        WeekCell *vd =(WeekCell *)[[self tableview] cellForRowAtIndexPath:indexPath];
        NSString *shi = [BatterHelp getDecimalBybinary:[vd getWeek]];
        if(![shi isEqualToString:@"0"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否保存", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"保存", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self edittimer];
            }]];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        WeekCell *vd =(WeekCell *)[[self tableview] cellForRowAtIndexPath:indexPath];
        NSString *shi = [BatterHelp getDecimalBybinary:[vd getWeek]];
        NSInteger hour = [self.pickview_time selectedRowInComponent:0];
        NSInteger min = [self.pickview_time selectedRowInComponent:2];
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        
        NSString *initcontent = [ContentHepler getContentFromTimer:_thistimer];
        TimerModel *timermodel = [[TimerModel alloc] init];
        [timermodel setEnable:_thistimer.enable];
        [timermodel setTimerid:self.timerid];
        NSInteger index = [_pickview_mode selectedRowInComponent:0];
        [timermodel setSid:((SystemSceneModel *)[_tomodelist objectAtIndex:index]).sence_group];
        [timermodel setWeek:[BatterHelp gethexBybinary:[shi intValue]]];
        [timermodel setHour:[NSString stringWithFormat:@"%02ld",hour]];
        [timermodel setMin:[NSString stringWithFormat:@"%02ld",min]];
        [timermodel setDevTid:currentgateway2];
        
        NSString *content =[ContentHepler getContentFromTimer:timermodel];
        
        if(![initcontent isEqualToString:content]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否保存", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"保存", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self edittimer];
            }]];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(NSString *)setWeekRepeat:(NSString *)binstring{
    NSString *ss = @"";
    for(int i=0;i<7;i++){
        NSString * wei = [binstring substringWithRange:NSMakeRange(7-i-1, 1)];
        
        switch (i) {
            case 0:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周一", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 1:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周二", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 2:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周三", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 3:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周四", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 4:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周五", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 5:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周六", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 6:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周日", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
                
            default:
                break;
        }
    }
    NSRange range = [ss rangeOfString:@"、" options:NSBackwardsSearch];
    ss = [ss substringWithRange:NSMakeRange(0, range.location)];
    
    return [NSString stringWithFormat:NSLocalizedString(@"这个时间点在%@重复了", nil),ss ];
}

-(int)gettid{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    NSMutableArray *list = [[DBTimerManager sharedInstanced] queryAllTimersTid:currentgateway2];
    if(list.count==0){
        return 0;
    }else{
        
        if(list.count==1){
            if([[list objectAtIndex:0] integerValue] == 0){
                return 1;
            }else {
                return 0;
            }
            
        }else{
            int m = 0;
            for(int i=0;i<list.count-1;i++){
                
                if(i==0){
                    int d = [[list objectAtIndex:i] intValue];
                    if(d!=0){
                        m = 0;
                        break;
                    }
                    else {
                        if( (([[list objectAtIndex:i] intValue])+1) < ([[list objectAtIndex:i+1] intValue])) {
                            m = (int)[list objectAtIndex:i]+1;
                            break;
                        }else{
                            m = i+2;
                        }
                    }
                }else{
                    if( (([[list objectAtIndex:i] intValue])+1) < ([[list objectAtIndex:i+1] intValue])){
                        m = (int)[list objectAtIndex:i]+1;
                        break;
                    }else{
                        m = i+2;
                    }
                }
                
                
            }
            return m;
        }
    
    }
    
    
}

@end
