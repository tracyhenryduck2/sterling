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
#import "BatterHelp.h"

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
            cell.textLabel.text = NSLocalizedString(@"时/分", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            PickViewCell *cell = [[PickViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickViewCell"];
            self.pickview = cell.pickview;
            if(self.data!=nil){
                [cell.pickview selectRow:[self.data.hour intValue] inComponent:0 animated:NO];
                [cell.pickview selectRow:[self.data.minute intValue] inComponent:2 animated:NO];
            }
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
            if(self.data!=nil){
                NSString *binweek = [BatterHelp getBinaryByhex:self.data.week];
                cell.week = binweek;
            }
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
    
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            return 160;
        }
    }else if(indexPath.section == 1){
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

#pragma -mark method

-(void)confirm{
    self.data = [SceneListItemData new];
    self.data.image = @"blue_clock_icon";
    self.data.type = @"time";
    self.data.title = @"定时";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    WeekCell *vd =(WeekCell *)[[self tableview] cellForRowAtIndexPath:indexPath];
    
    NSString *shi = [BatterHelp getDecimalBybinary:[vd getWeek]];
    if([shi isEqualToString:@"0"]){
        [MBProgressHUD showError:NSLocalizedString(@"请选择星期", nil) ToView:self.view];
        return;
    }
    NSString *dsa = [BatterHelp gethexBybinary:[shi intValue]];
    NSString *last = @"";
    for(int i=0;i<(2-dsa.length);i++){
       last = [last stringByAppendingString:@"0"];
    }
   last = [last stringByAppendingString:dsa];
    self.data.week = last;
    NSInteger hour = [self.pickview selectedRowInComponent:0];
    NSInteger min =  [self.pickview selectedRowInComponent:2];
    self.data.hour = [NSString stringWithFormat:@"%02ld",hour];
    self.data.minute = [NSString stringWithFormat:@"%02ld",min];
    self.data.custmTitle = [NSString stringWithFormat:@"%@:%@",self.data.hour,self.data.minute];
    [self.delegate sendNext:self.data];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
