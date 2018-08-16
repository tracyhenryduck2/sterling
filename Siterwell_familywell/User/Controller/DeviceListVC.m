//
//  DeviceListVC.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/4/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DeviceListVC.h"
#import "DeviceModel.h"
@interface DeviceListVC() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray<DeviceModel *> *deviceList;
@property (nonatomic) UILabel *noDataLb;
@property (nonatomic,assign) int dsa;
@property (nonatomic) NSTimer *timer;
@end
@implementation DeviceListVC

#pragma mark - life

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设备列表", nil);
//    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(finish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
//    self.navigationItem.rightBarButtonItem =  [super itemWithTarget:self action:nil Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(53, 167, 255)];
   _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(adddone) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
      NSString *  _statusArray = [[dic objectForKey:@"names"] objectForKey:@"001"];
    NSLog(@"设备列表：%@",_statusArray);
}
-(void)viewWillAppear:(BOOL)animated{
      [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
  [self tableView];
}

#pragma mark - datasource,delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //DeviceModel *model = self.deviceList[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = SYSTEMFONT(15.5);
    cell.detailTextLabel.font = SYSTEMFONT(15);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 1) {
        [cell.imageView setImage:[UIImage imageNamed:@"wifisocket"]];

        cell.textLabel.text = NSLocalizedString(@"在线", nil);
        
        cell.detailTextLabel.text = NSLocalizedString(@"在线", nil);
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"dc_icon"]];
        cell.textLabel.text = NSLocalizedString(@"在线", nil);

        cell.detailTextLabel.text = NSLocalizedString(@"离线", nil);
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    DeviceModel *model = self.deviceList[indexPath.row];
//    [self deleteDeviceWithDevTid:model.devTid andBindKey:model.bindKey];
}

- (NSMutableArray<DeviceModel *> *)deviceList {
    if (!_deviceList) {
        _deviceList = [NSMutableArray<DeviceModel *> array];
    }
    return _deviceList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _tableView.backgroundColor = RGB(239, 239, 243);
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _tableView;
}

- (UILabel *)noDataLb {
    if (!_noDataLb) {
        _noDataLb = [UILabel new];
        _noDataLb.text = NSLocalizedString(@"该分组暂无设备\n点击右上角按钮添加设备", nil);
        _noDataLb.font = SYSTEMFONT(15);
        _noDataLb.numberOfLines = 0;
        _noDataLb.textAlignment = NSTextAlignmentCenter;
        _noDataLb.textColor = [UIColor grayColor];
        [self.view addSubview:_noDataLb];
        [_noDataLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-120);
        }];
    }
    return _noDataLb;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
        @weakify(self)
    UITableViewRowAction * rdsa = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"fan", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
//        [self deleteAction:indexPath];
    }];
    
    UITableViewRowAction * rdsa2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"fan2", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        //        [self deleteAction:indexPath];
    }];
    
    return @[rdsa,rdsa2];
    
}

//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NSLocalizedString(@"删除", nil);
//}

#pragma mark - m
-(void)finish{
        [self.navigationController popViewControllerAnimated:YES];
}

-(void) adddone{
    _dsa ++ ;
    NSLog(@"技术：%d",_dsa);
    if(_dsa == 10)
    {
        [_timer invalidate];
    }
}
@end
