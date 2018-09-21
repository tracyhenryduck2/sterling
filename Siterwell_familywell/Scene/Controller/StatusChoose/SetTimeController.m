//
//  SetTimeController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SetTimeController.h"
#import "PickViewCell.h"
#import "WeekCell.h"

@interface SetTimeController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIPickerView *pickview;
@property (nonatomic,strong) UITableView *tableview;
@end
@implementation SetTimeController

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableview];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(confirm) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
}

-(void)viewWillAppear:(BOOL)animated{
    
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
            cell.textLabel.text = NSLocalizedString(@"分/秒", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            PickViewCell *cell = [[PickViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickViewCell"];
            return cell;
        }
        
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"星期", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            WeekCell *cell = [[WeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weekViewCell"];
             return cell;
        }
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    
    if(indexPath.row == 1){
        return 160;
    }
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
    return nilView;
}

#pragma -mark method

-(void)confirm{
    
}

@end
