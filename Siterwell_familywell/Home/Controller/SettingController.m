//
//  SettingController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SettingController.h"

@interface SettingController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSArray *titles;
@property (nonatomic,strong) UITableView *table;
@end

@implementation SettingController

#pragma mark -life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"设置", nil);
    self.titles = @[NSLocalizedString(@"序列号", nil), NSLocalizedString(@"设备型号", nil), NSLocalizedString(@"网络模式", nil), NSLocalizedString(@"云连接状态", nil), ];
    [self table];
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.textColor = RGB(28, 140, 249);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.5];
    cell.textLabel.text = self.titles[indexPath.row];
    //    cell.detailTextLabel.text = self.details[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"aaa";
    }
    else if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"aaa";
    }
    else if (indexPath.row == 2) {
        cell.detailTextLabel.text = @"aaa";
    }
    else if (indexPath.row == 3) {
        cell.detailTextLabel.text = @"aaa";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

#pragma mark -lazy

- (UITableView *)table {
    
    if(!_table){
        _table= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = 50;
        _table.bounces = NO;
        _table.separatorInset = UIEdgeInsetsZero;
        _table.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(64);
            //        make.height.equalTo(Main_Screen_Width/2 + 50*4+64);
        }];
    }

    return _table;
}



@end
