//
//  QuestionViewController.m
//  SiterLink
//
//  Created by CY on 2017/6/4.
//  Copyright © 2017年 CY. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuesSectionHeader.h"
#import "QuesModel.h"

@interface QuestionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSArray<QuesModel *> *qaList;
@property (nonatomic) TXScrollLabelView *titleLabel2;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    [self titleLabel2].scrollTitle = NSLocalizedString(@"配网失败原因", nil);
    if([self titleLabel2].upLabel.frame.size.width <=200){
        [[self titleLabel2] endScrolling];
    }else{
        [[self titleLabel2] beginScrolling];
    }
    [self tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

#pragma mark - Lazy

-(TXScrollLabelView *)titleLabel2{
    if(_titleLabel2 == nil){
        _titleLabel2 = [TXScrollLabelView scrollWithTitle:@"" type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
        /** Step4: 布局(Required) */
        _titleLabel2.frame = CGRectMake(30, 7, 200, 30);
        
        
        
        //偏好(Optional), Preference,if you want.
        _titleLabel2.tx_centerY = 22;
        _titleLabel2.userInteractionEnabled = NO;
        _titleLabel2.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
        _titleLabel2.scrollSpace = 10;
        _titleLabel2.font = [UIFont systemFontOfSize:15];
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
        _titleLabel2.scrollTitleColor = [UIColor blackColor];
        _titleLabel2.backgroundColor = [UIColor clearColor];
        _titleLabel2.layer.cornerRadius = 5;
        self.navigationItem.titleView=_titleLabel2;
    }
    return _titleLabel2;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = GrayColor;
        [_tableView registerClass:[QuesSectionHeader class] forHeaderFooterViewReuseIdentifier:@"QuesSectionHeader"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _tableView;
}

- (NSArray<QuesModel *> *)qaList {
    if (!_qaList) {
        NSMutableArray *qaArray = [NSMutableArray array];
        
        QuesModel *model1 = [QuesModel qaWithDict:@{@"question":NSLocalizedString(@"WIFI密码错误", nil),@"answer":NSLocalizedString(@"您填入的WIFI密码可能是错误的", nil),@"expand":@YES}];
        QuesModel *model2 = [QuesModel qaWithDict:@{@"question":NSLocalizedString(@"空格问题", nil),@"answer":NSLocalizedString(@"您的路由器的SSID或密码可能含有空格", nil),@"expand":@YES}];
        QuesModel *model3 = [QuesModel qaWithDict:@{@"question":NSLocalizedString(@"2.4GHZ-WIFI", nil),@"answer":NSLocalizedString(@"本产品只支持2.4GHZ频率的WIFI,不支持5GHZ,请确保路由器正确的设置", nil),@"expand":@YES}];
        [qaArray addObject:model1];
        [qaArray addObject:model2];
        [qaArray addObject:model3];
        _qaList = qaArray;
    }
    return _qaList;
}

#pragma mark - UITableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.qaList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QuesModel *model = self.qaList[section];
    return model.expand;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QuesModel *model = self.qaList[section];
    QuesSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QuesSectionHeader"];
    header.contentView.backgroundColor = [UIColor whiteColor];
    header.section = section;
    header.quesLB.scrollTitle = model.question;
    //根据内容宽度动态决定是否走马灯显示
    if(header.quesLB.upLabel.frame.size.width<=300){
        [header.quesLB endScrolling];
    }else{
        [header.quesLB beginScrolling];
    }
    header.headerClickBlock = ^(NSInteger section) {
        model.expand = !model.expand;
        if (model.expand) {
            [tableView insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:section], nil] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:section], nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"value1Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = GrayColor;
    UILabel *lb = [UILabel new];
    lb.numberOfLines = 0;
    lb.text = self.qaList[indexPath.section].answer;
    lb.font = SYSTEMFONT(15);
    [cell.contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.center.equalTo(0);
        make.top.equalTo(6);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

@end
