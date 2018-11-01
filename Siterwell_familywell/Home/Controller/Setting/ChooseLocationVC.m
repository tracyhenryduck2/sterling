//
//  ChooseLocationVC.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/11/1.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ChooseLocationVC.h"
@interface ChooseLocationVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@end
@implementation ChooseLocationVC
#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定位设置", nil);
    [self table];
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSNumber *location = [config objectForKey:@"Location"];
    if(indexPath.row==0){
        cell.textLabel.text = NSLocalizedString(@"定位", nil);
    }else{
        cell.textLabel.text = NSLocalizedString(@"不定位", nil);
    }
    if(location!=nil && [location intValue] == 1){
        if(indexPath.row == 0){
            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            cell.accessoryView =imageview;
        }else{
            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes_icon"]];
            cell.accessoryView =imageview;
        }

    }else{
        if(indexPath.row == 0){
            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes_icon"]];
            cell.accessoryView =imageview;

        }else{
            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            cell.accessoryView =imageview;
        }
    }

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
    
    return 2;
    
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
@end
