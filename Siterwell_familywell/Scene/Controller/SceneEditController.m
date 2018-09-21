//
//  SceneEditController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneEditController.h"
#import "DBSceneManager.h"
#import "SceneListItemData.h"
#import "InOutputAddSceneCell.h"
#import "CollectionController.h"
#import "ModelListVC.h"
#import "SetDelayController.h"
#import "SetTimeController.h"
#import "NormalStatusVC.h"

@interface SceneEditController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITextField *titleTextFiled;
@property (nonatomic,copy) NSString *initcode;
@property (nonatomic,strong) NSMutableArray <SceneListItemData*>* inputList;
@property (nonatomic,strong) NSMutableArray <SceneListItemData*>* outputList;
@property (nonatomic,copy) NSString *trigger_style;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)SceneModel *sceneModel;
@end

@implementation SceneEditController{

}

#pragma -mark life
-(void)viewDidLoad{
     [super viewDidLoad];
    [self initdata];
    UITextField * enterTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width-60, 30)];
    enterTextField.backgroundColor = RGB(242, 242, 245);
    enterTextField.layer.cornerRadius = 15.0f;
    enterTextField.placeholder = NSLocalizedString(@"请输入自定义情景名称", nil);
    CGRect frame = enterTextField.frame;
    frame.size.width = 20;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    enterTextField.leftViewMode = UITextFieldViewModeAlways;
    enterTextField.leftView = leftview;
    _titleTextFiled = enterTextField;
    self.navigationItem.titleView = enterTextField;
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(backfinish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
    [self tableView];

    if(_sceneModel!=nil){
        _titleTextFiled.text = _sceneModel.scene_name;
    }
    
    @weakify(self)
    [_inputList enumerateObjectsUsingBlock:^(SceneListItemData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if([_inputList[idx].type isEqualToString:@"empty"]){
            [MBProgressHUD showError:NSLocalizedString(@"有设备被删除", nil) ToView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
    }];
    
    [_outputList enumerateObjectsUsingBlock:^(SceneListItemData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if([_outputList[idx].type isEqualToString:@"empty"]){
            [MBProgressHUD showError:NSLocalizedString(@"有设备被删除", nil) ToView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)initdata{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    
    if(_mid==nil){
        _inputList = [NSMutableArray new];
        _outputList = [NSMutableArray new];
        _trigger_style = @"00";
        SceneListItemData *ds = [[SceneListItemData alloc] init];
        [ds setType:@"add"];
        ds.image = @"add_icon";
        ds.custmTitle = NSLocalizedString(@"添加", nil);
        [_inputList addObject:ds];
        [_outputList addObject:ds];
    }else{
        _sceneModel= [[DBSceneManager sharedInstanced] querySceneModel:_mid withDevTid:currentgateway2];
        _inputList = [_sceneModel getInDeviceArray:currentgateway2];
        _outputList = [_sceneModel getOutDeviceArray:currentgateway2];
        _trigger_style = [_sceneModel getSelectType];
        SceneListItemData *ds = [[SceneListItemData alloc] init];
        [ds setType:@"add"];
        ds.custmTitle = NSLocalizedString(@"添加", nil);
        ds.image = @"add_icon";
        [_inputList addObject:ds];
        [_outputList addObject:ds];
    }
    
    
}

#pragma -mark tableview

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"执行条件", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
           InOutputAddSceneCell *cell = [[InOutputAddSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inputCell"];
            cell.itemdatas = _inputList;
            cell.delegate = [RACSubject subject];
            @weakify(self);
            [cell.delegate subscribeNext:^(id x) {
                @strongify(self);
                SceneListItemData *data = x;
                if([data.type isEqualToString:@"add"]){
                    ModelListVC *vc = [[ModelListVC alloc] init];
                    vc.title = NSLocalizedString(@"添加触发条件", nil);
                    vc.IsInput = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if([data.type isEqualToString:@"time"]){
                    SetTimeController *vc = [[SetTimeController alloc] init];
                    vc.title = NSLocalizedString(@"定时", nil);
                    vc.data = data;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if([data.type isEqualToString:@"click"]){
                    [MBProgressHUD showError:NSLocalizedString(@"无需设置", nil) ToView:self.view];
                }else{
                    NormalStatusVC *vc = [[NormalStatusVC alloc] init];
                    vc.data = data;
                    vc.title = data.custmTitle;
                    [self.navigationController pushViewController:vc animated:YES];
                }

            }];
            cell.longclickdelegate = [RACSubject subject];
            [cell.longclickdelegate subscribeNext:^(id x) {
                
                int index = [x intValue];
                [_inputList removeObjectAtIndex:index];
              [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
            }];
            return cell;
        }
        
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([_trigger_style isEqualToString:@"FF"]){
          cell.textLabel.text = NSLocalizedString(@"满足所有条件触发", nil);
        }else{
          cell.textLabel.text = NSLocalizedString(@"满足任一条件即触发", nil);
        }
        cell.textLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"按顺序执行", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            InOutputAddSceneCell *cell = [[InOutputAddSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"outputCell"];
            cell.itemdatas = _outputList;
            cell.delegate = [RACSubject subject];
            @weakify(self);
            [cell.delegate subscribeNext:^(id x) {
                @strongify(self);
                SceneListItemData *data = x;
                if([data.type isEqualToString:@"add"]){
                    ModelListVC *vc = [[ModelListVC alloc] init];
                    vc.title = data.custmTitle;
                    vc.IsInput = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if([data.type isEqualToString:@"delay"]){
                    SetDelayController *vc = [[SetDelayController alloc] init];
                    vc.title = NSLocalizedString(@"延时", nil);
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    NormalStatusVC *vc = [[NormalStatusVC alloc] init];
                    vc.data = data;
                    vc.title = data.custmTitle;
                    [self.navigationController pushViewController:vc animated:YES];
                }

            }];
            cell.longclickdelegate = [RACSubject subject];
            [cell.longclickdelegate subscribeNext:^(id x) {

                int index = [x intValue];
                [_outputList removeObjectAtIndex:index];
              [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationRight];
            }];
            return cell;
        }
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    if(indexPath.section == 1){
        CollectionController *vc = [[CollectionController alloc] init];
        vc.selectType = _trigger_style;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            self.trigger_style = x;
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 1;
    }else {
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
            int count = (int)(_inputList.count-1);
            int row = count/3;
            return (Main_Screen_Width/4)*(row+1);
        }
    }else if(indexPath.section == 2){
        if (indexPath.row != 0) {
            int count = (int)(_outputList.count-1);
            int row = count/3;
            return (Main_Screen_Width/4)*(row+1);
        }
    }
    
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
    return nilView;
}

#pragma -mark lazy
-(UITableView *)tableView{
    if(_tableView==nil){
        
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

#pragma -mark method
-(void)backfinish{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickItem{
    
}






@end
