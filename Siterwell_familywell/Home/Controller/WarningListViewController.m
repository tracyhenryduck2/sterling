//
//  WarningListViewController.m
//  sHome
//
//  Created by CY on 2018/2/24.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "WarningListViewController.h"
#import "DevNetManager.h"
#import "WarningModel.h"
#import "SceneModel.h"
#import "ItemData.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BatterHelp.h"
#import "DBGatewayManager.h"
#import "DBDeviceManager.h"
#import "DBSceneManager.h"

@interface WarningListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource>

@property (nonatomic) UITableView *table;

@property (nonatomic) NSMutableArray<WarningModel *> *warningList;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic,assign) NSInteger page_loginout;

@property (nonatomic) GatewayModel * gateway;
@end

@implementation WarningListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    _gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    [self setupNav];
    
    [self table];
    [self getWarnings];
}

- (void)setupNav {
    self.view.backgroundColor = RGB(239, 239, 239);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sj_list_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    self.navigationItem.title = NSLocalizedString(@"设备告警历史记录", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"清空", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clearHistoryWarnings)];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.tableFooterView = [UIView new];
        _table.dataSource = self;
        _table.delegate = self;
        _table.emptyDataSetSource = self;
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _table;
}

- (NSMutableArray<WarningModel *> *)warningList {
    if (!_warningList) {
        _warningList = [[NSMutableArray<WarningModel *> alloc] init];
    }
    return _warningList;
}



- (void)backToHome {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)getWarnings {

    __weak typeof(self) weakSelf = self;
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel * gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    if (gateway ) {
        if(self.page == 0){
          [MBProgressHUD showLoadToView:self.view];
        }
        [DevNetManager getWarningsWithDevTid:gateway.devTid andPage:self.page handler:^(NSArray<WarningModel *> *parseArray, BOOL isLast, NSError *error) {
            [weakSelf.warningList addObjectsFromArray:parseArray];
            weakSelf.page += 1;
            if (isLast == NO) {
                [weakSelf getWarnings];
            } else if (isLast == YES) {
                [weakSelf.table reloadData];
                [MBProgressHUD hideHUDForView:self.view];
            }

        }];
    }
}


- (void)clearHistoryWarnings {
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel * gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    if (gateway) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"确定删除历史告警记录", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [DevNetManager clearAllWarningsWithDevTid:gateway.devTid ctrlKey:gateway.ctrlKey handler:^(NSError *error) {
                self.page = 0;
                [self.warningList removeAllObjects];
                [weakSelf getWarnings];
            }];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [MBProgressHUD showError:NSLocalizedString(@"请选择网关", nil) ToView:self.view];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.warningList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    if (self.warningList.count != 0) {
        cell.textLabel.text = [TimeHelper TimestampToData:[[self.warningList[indexPath.row].reportTime stringValue] substringToIndex:10]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    dic = [dic objectForKey:@"names"];
    if (self.warningList.count < indexPath.row) {
        return cell;
    }
    NSString *type = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(4, 2)];
    NSString *msg = @"";
    if ([type isEqualToString:@"AC"]) {
        NSString *sid = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(6, 2)];
        int mid = (int)strtoul([sid UTF8String],0,16);
        
        SceneModel *model = [[DBSceneManager sharedInstanced] querySceneModel:[NSNumber numberWithInt:mid] withDevTid:_gateway.devTid];
        if (model.scene_name) {
            msg = [NSString stringWithFormat:NSLocalizedString(@"情景触发",nil),model.scene_name];
        }else{
            NSString * scene = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"情景",nil),mid];
            msg = [NSString stringWithFormat:NSLocalizedString(@"情景触发",nil),scene];
        }
    } else {
        
        NSString *sid = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(6, 4)];
        int mid = 0;
        if (sid) {
            mid = (int)strtoul([sid UTF8String],0,16);
        }

        
        if(mid!=0){
            ItemData *data = [[DBDeviceManager sharedInstanced] queryDeviceModel:[NSNumber numberWithInt:mid] withDevTid:_gateway.devTid];
            NSString *deviceCode = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(11, 3)];
            NSString *status = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(14, 8)];
            NSString *alarm = [WarningModel getAlertWithDevType:deviceCode status:status];
            if (!data) {
                NSString *deviceName = [dic objectForKey:deviceCode];

                msg = [NSString stringWithFormat:@"%@ %d %@",NSLocalizedString(deviceName, nil), mid, alarm];
                
            }else{
                

                NSString *content;
                if([NSString isBlankString:data.customTitle]){
                    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
                    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
                    NSDictionary * _names = [dic valueForKey:@"names"];
                    content = [NSString stringWithFormat:@"%@%@",NSLocalizedString([_names objectForKey:data.device_name], nil),data.device_ID];
                }else {
                    content = data.customTitle;
                }
                msg = [NSString stringWithFormat:@"%@ %@",content,alarm];
            }
        }
        else {
            NSString *status = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(14, 8)];
            //市电断开  //市电恢复//电池正常//电池异常
            if([status isEqualToString:@"00000000"]){
                msg = NSLocalizedString(@"市电断开", nil);
                
            }
            else if([status isEqualToString:@"00000001"]){
                msg = NSLocalizedString(@"市电恢复", nil);
            }
            else if([status isEqualToString:@"00000002"]){
                msg = NSLocalizedString(@"电池正常", nil);
            }
            else if([status isEqualToString:@"00000003"]){
                msg = NSLocalizedString(@"电池异常", nil);
            }else if([status isEqualToString:@"00000004"]){
                msg = NSLocalizedString(@"老人可能长时间未移动", nil);
            }else{
                msg = [NSString stringWithFormat:@"%@",NSLocalizedString(@"报警", nil)];
            }
            
        }
    }
    
    cell.detailTextLabel.text = msg;
    
    return cell;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"没有数据", nil) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: GrayColor}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}



@end
