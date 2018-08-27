//
//  CollectionController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "CollectionController.h"
@interface CollectionController()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tableView;

@end

@implementation CollectionController

#pragma -mark life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"选择执行条件", nil);
    [self tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark lazy
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01;
    }
    else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 70;
    }else{
        return 175;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    NSString *str;
    if (section == 0) {
        str = NSLocalizedString(@"如果你添加了一个或者多个启动条件时，达到其中任何一个条件都会执行任务。", nil);
    }else{
        str = NSLocalizedString(@"如果添加了多个启动条件时，必须达到所有条件才会执行任务；\n 如果只添加了一个启动条件，此时满足该条件即执行任务；\n如果您还未理解此选项功能，选择默认选项或者咨询我们。", nil);
    }
    UILabel *label = [UILabel new];
    label.font = SYSTEMFONT(13);
    label.text = str;
    label.numberOfLines = 0;
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(13);
        make.right.equalTo(view.mas_right).offset(-13);
        make.centerY.equalTo(view);
    }];
    
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"chooseItemCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
    }

    
    if (indexPath.section == 0) {

        cell.textLabel.text = NSLocalizedString(@"满足任一条件即触发", nil);
        if ([_selectType isEqualToString:@"00"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        cell.textLabel.text = NSLocalizedString(@"满足所有条件执行", nil);
        if ([_selectType isEqualToString:@"FF"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        _selectType = @"00";
    }else{
        _selectType = @"FF";
    }
    if (self.delegate) {
        [self.delegate sendNext:_selectType];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
