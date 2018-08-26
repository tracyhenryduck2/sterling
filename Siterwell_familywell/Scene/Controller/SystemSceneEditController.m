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
#import "DBSystemSceneManager.h"
#import "DBSceneReManager.h"
#import "DBGS584RelationShipManager.h"
#import "SelectColorCell.h"

@interface SystemSceneEditController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITextField *titleTextFiled;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,assign) NSString *color;
@property (nonatomic,strong) SystemSceneModel * sysmodel;
@property (strong,nonatomic)NSMutableArray <SceneModel *>* array_scene;
@property (strong,nonatomic)NSMutableArray <NSNumber *>*array_ship;
@end

@implementation SystemSceneEditController

#pragma -mark life

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initdata];
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
    if ( _edit == YES) {
        
        if([self.scene_type intValue] <= 2 ){
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
            _titleTextFiled.text = _sysmodel.systemname;
        }

    }else{
        _titleTextFiled.enabled = YES;
    }
    self.navigationItem.titleView = enterTextField;
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
    

    
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
            cell.textLabel.font = SYSTEMFONT(13);
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
        
        BOOL ds = NO;
        for (NSNumber *sceneship in _array_ship) {
            if([sceneship integerValue] == [model.scene_type integerValue]){
                ds = YES;
               break;
            }

        }
        cell.idLabel.text = [NSString stringWithFormat:@"%02ld",(long)(indexPath.row+1)];
        cell.titleLabel.text = model.scene_name;
        cell.selectSceneBtn.selected = ds;
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
        SceneModel *model = _array_scene[indexPath.row];
        
        AddSystemScenCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectSceneBtn.selected = !cell.selectSceneBtn.selected;
        if (cell.selectSceneBtn.selected) {
            [self.array_ship addObject:model.scene_type];
        }else {
            [self.array_ship removeObject:model.scene_type];
        }
    }
}



#pragma -mark method
-(void)clickItem{
    
}

-(void) initdata{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    if(_edit == YES ){
        _sysmodel = [[DBSystemSceneManager sharedInstanced] querySystemScene:_scene_type withDevTid:currentgateway2];
        _array_ship = [[DBSceneReManager sharedInstanced] querymid:_scene_type withDevTid:currentgateway2];
        _color = _sysmodel.color;
    }else{
        _array_ship = [[NSMutableArray alloc] init];
        _color = nil;
    }
    _array_scene = [[DBSceneManager sharedInstanced] queryAllScenewithDevTid:currentgateway2];
}

//插空法获取情景模式id
-(int)getsid{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    NSMutableArray * sids = [[DBSystemSceneManager sharedInstanced] queryAllSystemSceneId:currentgateway2];
    
    if(sids.count<3){
        return -1;
    }else{
        int m = 0;
        for(int i=0;i<sids.count-1;i++){
            if( ([[sids objectAtIndex:i] intValue]+1) <[[sids objectAtIndex:(i+1)] intValue]){
                m = ([[sids objectAtIndex:i] intValue]+1);
                break;
            }else{
                m = i+2;
            }
        }
        return m;
    }
    
}
@end
