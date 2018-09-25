//
//  SetDelayController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SetDelayController.h"
#import "DelayPickViewCell.h"

@interface SetDelayController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIPickerView *pickview;
@property (nonatomic,strong) UITableView *tableview;
@end
@implementation SetDelayController

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
    
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"分/秒", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            DelayPickViewCell *cell = [[DelayPickViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickViewCell"];
            self.pickview = cell.pickview;
            if(self.data!=nil){
                [cell.pickview selectRow:[self.data.minute intValue] inComponent:0 animated:NO];
                [cell.pickview selectRow:[self.data.second intValue] inComponent:2 animated:NO];
            }
            return cell;
        }
        
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    self.data = [SceneListItemData new];
    self.data.image = @"blue_ys_icon";
    self.data.type = @"delay";
    self.data.title = @"延时";
    NSInteger min = [self.pickview selectedRowInComponent:0];
    NSInteger sec =  [self.pickview selectedRowInComponent:2];
    if(min == 0 && sec == 0){
        [MBProgressHUD showError:NSLocalizedString(@"请设置延时时间", nil) ToView:self.view];
        return;
    }
    self.data.minute = [NSString stringWithFormat:@"%02ld",min];
    self.data.second = [NSString stringWithFormat:@"%02ld",sec];
    self.data.custmTitle = [NSString stringWithFormat:@"%@:%@",self.data.minute,self.data.second];
    [self.delegate sendNext:self.data];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
