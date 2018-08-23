//
//  SettingController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SettingController.h"
#import "DBManager.h"

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
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(finish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
}
-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
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
            cell.detailTextLabel.text = @"aaa";
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
        NSLog(@"di");
    }else{
        
        [[Hekr sharedInstance] logout];
        [[DBManager sharedInstanced] close];
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
        return 20;
    }
    return 10;
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

#pragma -mark method

-(void)finish{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
