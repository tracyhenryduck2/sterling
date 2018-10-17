//
//  GatewayListVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/21.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "GatewayListVC.h"
#import "DBGatewayManager.h"
#import "GatewayListView.h"
@interface GatewayListVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray <GatewayModel *> * list_gateway;
@end
@implementation GatewayListVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"网关列表", nil);
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(finish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
    [self table];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    _list_gateway = [[DBGatewayManager sharedInstanced] queryAllGateway];
    [[self table] reloadData];
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
       cell.selectImageView.image = [UIImage imageNamed:@"yes_icon"];
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
        //        [self deleteAction:indexPath];
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
        _table.bounces = NO;
        _table.separatorInset = UIEdgeInsetsZero;
        _table.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(64);
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
@end
