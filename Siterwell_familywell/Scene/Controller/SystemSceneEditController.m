//
//  SystemSceneEditController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SystemSceneEditController.h"
#import "AddSystemScenCell.h"
#import "DBSceneManager.h"
#import "DBSceneReManager.h"
#import "SelectColorCell.h"

@interface SystemSceneEditController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITextField *titleTextFiled;
@property (strong, nonatomic) UITableView *tableView;
@property (strong,nonatomic)NSMutableArray <SceneModel *>* array_scene;
@end

@implementation SystemSceneEditController

#pragma -mark life

-(void)viewDidLoad{
    [super viewDidLoad];
    UITextField * enterTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width-60, 30)];
    enterTextField.backgroundColor = RGB(242, 242, 245);
    enterTextField.layer.cornerRadius = 15.0f;
    enterTextField.placeholder = NSLocalizedString(@"请输入情景模式名称", nil);
    CGRect frame = enterTextField.frame;
    frame.size.width = 20;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    enterTextField.leftViewMode = UITextFieldViewModeAlways;
    enterTextField.leftView = leftview;
    _titleTextFiled = enterTextField;
    if ( [self.scene_type intValue] <= 2 && _edit == YES) {
        _titleTextFiled.enabled = NO;
        switch ([_scene_type intValue]) {
            case 0:
                _titleTextFiled.text = NSLocalizedString(@"在家", nil);
                break;
            case 1:
                _titleTextFiled.text = NSLocalizedString(@"离家", nil);
                break;
            case 2:
                _titleTextFiled.text = NSLocalizedString(@"睡眠", nil);
                break;
            default:
                break;
        }
    }else{
        _titleTextFiled.enabled = YES;
    }
    self.navigationItem.titleView = enterTextField;
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    
    _array_scene = [[DBSceneManager sharedInstanced] queryAllScenewithDevTid:currentgateway2];
    
    [self tableView];
    
    
}


#pragma -mark lazy
-(UITableView *)tableView{
    if(_tableView==nil){
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGB(239, 239, 243);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
    }
    return _tableView;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return _array_scene.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addScenTitleCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"请选择情景灯颜色", nil);
            return cell;
        }else{
            SelectColorCell *cell = [[SelectColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"colorCell"];
            cell.currtetColor = self.color;
            cell.colorSelected = ^(NSString *color) {
                _color = color;
            };
            return cell;
        }

    }else{
        AddSystemScenCell *cell =  [[AddSystemScenCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"addScenCell"];
        SceneModel *model = _array_scene[indexPath.row];
        
        
        cell.idLabel.text = [NSString stringWithFormat:@"%02ld",(long)(indexPath.row+1)];
        cell.titleLabel.text = model.scene_name;
        cell.selectSceneBtn.selected = YES;
        
        
        return cell;
    }
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0 && indexPath.row == 1){
        return 100;
    }else
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
    }
}



#pragma -mark method
-(void)clickItem{
    
}
@end
