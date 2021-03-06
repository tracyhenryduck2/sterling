//
//  UIViewController+HomeVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/2/23.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneVC.h"
#import "SystemSceneCell.h"
#import "SceneCell.h"
#import "DBSystemSceneManager.h"
#import "DBSceneManager.h"
#import "DBGatewayManager.h"
#import "SceneHeaderView.h"
#import "SceneEditController.h"
#import "ChooseSystemSceneApi.h"
#import "SiterwellReceiver.h"
#import "SystemSceneEditController.h"
#import "Single.h"
#import "DeviceListVC.h"
#import "CollectionController.h"
#import "TimerListController.h"
#import "DeleteSystemSceneApi.h"
#import "DBSceneReManager.h"
#import "DBGS584RelationShipManager.h"
#import "DeleteSceneApi.h"
#import "ContentHepler.h"
#import "PushSystemSceneApi.h"
#import "ClickApi.h"
@interface SceneVC() <UITableViewDelegate,UITableViewDataSource,CLickdelegate,CLickBtndelegate>

@property (nonatomic,strong) UITableView *table_scene;
@property (nonatomic,strong) NSMutableArray <SystemSceneModel *> *list_system_scene;
@property (nonatomic,strong) NSMutableArray <SceneModel *> *list_scene;
@property (nonatomic,strong) SceneHeaderView *sceneheaderview;
@property (nonatomic,assign) NSInteger select_sid;
@property (nonatomic,strong) NSNumber *delete_sid;
@property (nonatomic,strong) NSNumber *delete_mid;

@end
@implementation SceneVC

#pragma -mark life

-(void)viewDidLoad{
    
    self.title = NSLocalizedString(@"情景", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(gotoSystemSceneAdd) image:@"add_list_icon" highImage:nil withTintColor:nil];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(gototimerlist) Title:NSLocalizedString(@"定时", nil) withTintColor:ThemeColor];
    [self table_scene];


}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAnswerOK) name:@"answer_ok" object:nil];
    [self refresh];
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    if([NSString isBlankString:currentgateway2]){
        [MBProgressHUD showError:NSLocalizedString(@"请选择网关", nil) ToView:self.view];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}


-(void)viewDidDisappear:(BOOL)animated{
     NSLog(@"viewDidDisappear");
}

- (void)dealloc {
    
    //移除观察者 self
    NSLog(@"dealloc SceneVC");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma -mark lazy

- (UITableView *)table_scene {
    if (!_table_scene) {
        _table_scene = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table_scene.dataSource = self;
        _table_scene.delegate = self;
        _table_scene.rowHeight = 60;
        _table_scene.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _table_scene.backgroundColor = RGB(239, 239, 243);
        _table_scene.tableFooterView = [UIView new];
        [self.view addSubview:_table_scene];
        [_table_scene mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _table_scene;
}

#pragma -mark delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        static NSString *cellIdentifier = @"SystemSceneCell";
        SystemSceneCell *cell = (SystemSceneCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[SystemSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.clickdelegate = self;
            [cell.selectSceneBtn setTag:indexPath.row];
        }
        SystemSceneModel *systemscene = [_list_system_scene objectAtIndex:indexPath.row];
        if([systemscene.sence_group integerValue] == 0){
            [cell.headerImageView setImage:[UIImage imageNamed:@"zjms_icon"]];
            cell.titleLabel.text =  NSLocalizedString(@"在家", nil);
        }else if([systemscene.sence_group integerValue] == 1){
            [cell.headerImageView setImage:[UIImage imageNamed:@"ljms_icon"]];
            cell.titleLabel.text =  NSLocalizedString(@"离家", nil);
        }else if([systemscene.sence_group integerValue] == 2){
            
            [cell.headerImageView setImage:[UIImage imageNamed:@"smms_icon"]];
            cell.titleLabel.text =  NSLocalizedString(@"睡眠", nil);
        }else{
            [cell.headerImageView setImage:[UIImage imageNamed:@"zjms_icon"]];
            cell.titleLabel.text = systemscene.systemname;
        }
        
        if ([systemscene.color isEqualToString:@"00"]||[systemscene.color isEqualToString:@"F8"]) {
            
        }else if ([systemscene.color isEqualToString:@"F1"]){
            //                cell.color.backgroundColor = RGB(25,181,254);
            cell.color.backgroundColor = HEXCOLOR(0x33a7ff);
        }else if ([systemscene.color isEqualToString:@"F2"]){
            //                cell.color.backgroundColor = RGB(122,13,142);
            cell.color.backgroundColor = HEXCOLOR(0xc968ed);
        }else if ([systemscene.color isEqualToString:@"F3"]){
            //                cell.color.backgroundColor = RGB(255,121,175);
            cell.color.backgroundColor = HEXCOLOR(0xf067bb);
        }else if ([systemscene.color isEqualToString:@"F4"]){
            //                cell.color.backgroundColor = RGB(46,204,113);
            cell.color.backgroundColor = HEXCOLOR(0x53f6ab);
        }else if ([systemscene.color isEqualToString:@"F5"]){
            //                cell.color.backgroundColor = RGB(38,166,91);
            cell.color.backgroundColor = HEXCOLOR(0xa5f7b2);
        }else if ([systemscene.color isEqualToString:@"F6"]){
            //                cell.color.backgroundColor = RGB(249,105,14);
            cell.color.backgroundColor = HEXCOLOR(0xf56735);
        }else if ([systemscene.color isEqualToString:@"F7"]){
            //                cell.color.backgroundColor = RGB(26,56,144);
            cell.color.backgroundColor = HEXCOLOR(0x4d94ff);
        }else if ([systemscene.color isEqualToString:@"F0"]){
            //                cell.color.backgroundColor = RGB(10, 114, 58);
            cell.color.backgroundColor = HEXCOLOR(0x11da28);
        }
        
        if([systemscene.choice intValue] == 1){
            [cell.selectSceneBtn setSelected:YES];
        }else{
            [cell.selectSceneBtn setSelected:NO];
        }
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"SceneCell";
        SceneCell *cell2 = (SceneCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell2 == nil) {
            cell2 = [[SceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell2.clickdelegate = self;
            [cell2.clickBtn setTag:indexPath.row];
        }
        SceneModel *scenemodel = [_list_scene objectAtIndex:indexPath.row];
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
         [scenemodel getInDeviceArray:currentgateway2];
        cell2.titleLabel.text = [NSString stringWithFormat:@"%d",[scenemodel.scene_type intValue]];
        cell2.detailLabel.text = scenemodel.scene_name;
        if([scenemodel.isShouldClick isEqualToString:@"AB"]){
            cell2.clickBtn.hidden = NO;
        }else{
            cell2.clickBtn.hidden = YES;
        }
        return cell2;
    }

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.table_scene deselectRowAtIndexPath:[self.table_scene indexPathForSelectedRow] animated:YES];
    if(indexPath.section == 0){
        SystemSceneModel *sys = [_list_system_scene objectAtIndex:indexPath.row];
        SystemSceneEditController *systemSceneController = [[SystemSceneEditController alloc] init];
        systemSceneController.edit = YES;
        systemSceneController.scene_type = sys.sence_group;
        [self.navigationController pushViewController:systemSceneController animated:YES];
    }else{
        SceneModel *sys = [_list_scene objectAtIndex:indexPath.row];
        SceneEditController *vc = [[SceneEditController alloc] init];
        vc.mid = sys.scene_type;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return _list_system_scene.count;
    }else if(section == 1){
        return _list_scene.count;
    }
    else return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0)
    {
        return 10;
    }else
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0){
        UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
        return nilView;
    }else{
        
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        if([NSString isBlankString:currentgateway2]){
            UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
            return nilView;
        }else{
            _sceneheaderview = [[SceneHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
            _sceneheaderview.backgroundColor = [UIColor whiteColor];
            [_sceneheaderview.btn_add_scene addTarget:self
                                               action:@selector(BtnClick:)
                                     forControlEvents:UIControlEventTouchUpInside];
            return _sceneheaderview;
        }
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==0){
        UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
        return nilView;
    }else return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"删除", nil);
}

/**
 cell点击删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        GatewayModel *gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
       SystemSceneModel *mde = [_list_system_scene objectAtIndex:indexPath.row];
       NSNumber *dd = [[DBSystemSceneManager sharedInstanced] queryCurrentSystemScene:currentgateway2];
        if([mde.sence_group intValue]<=2){
            [MBProgressHUD showError:NSLocalizedString(@"此情景模式不能被删除", nil) ToView:self.view];
        }else if([dd intValue]==[mde.sence_group intValue]){
            [MBProgressHUD showError:NSLocalizedString(@"当前情景模式不能被删除", nil) ToView:self.view];
        }else{
            [Single sharedInstanced].command = DeleteSystemScene;
            DeleteSystemSceneApi *api = [[DeleteSystemSceneApi alloc] initWithDevTid:gateway.devTid CtrlKey:gateway.ctrlKey Domain:gateway.connectHost Content:mde.sence_group];
            _delete_sid = mde.sence_group;
            [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                
            }];
        }
    }else{
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        GatewayModel *gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
        [Single sharedInstanced].command = DelteScene;
        SceneModel *model = [_list_scene objectAtIndex:indexPath.row];
        DeleteSceneApi *api = [[DeleteSceneApi alloc] initWithDevTid:gateway.devTid CtrlKey:gateway.ctrlKey Domain:gateway.connectHost SceneContent:model.scene_type];
        _delete_mid = model.scene_type;
        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
            
        }];
    }
}

-(void)click:(NSInteger)index{
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    SystemSceneModel *model = _list_system_scene[index];
    [Single sharedInstanced].command = ChooseSystemScene;
    ChooseSystemSceneApi *choose  = [[ChooseSystemSceneApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost SceneGroup:model.sence_group];
    _select_sid = [model.sence_group intValue];
    [choose startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        NSLog(@"选择后返回的数据为%@",data);
    }];
}

-(void)clickfor:(NSInteger)index{
    NSLog(@"index:%ld",index);
    SceneModel *model =  [_list_scene objectAtIndex:index];
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    [Single sharedInstanced].command = ClickToAction;
    ClickApi *api = [[ClickApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost Scene:model.scene_type];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        NSLog(@"选择后返回的数据为%@",data);
    }];
}

-(void) onAnswerOK{
    if([Single sharedInstanced].command == ChooseSystemScene){
        [Single sharedInstanced].command = -1;
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        [[DBSystemSceneManager sharedInstanced] updateSystemChoicewithSid:[NSNumber numberWithInteger:_select_sid] withDevTid:currentgateway2];
        [self refresh];
    }else if([Single sharedInstanced].command == DeleteSystemScene){
        [Single sharedInstanced].command = -1;

        if(_delete_sid!=nil){
            NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
            NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
            [[DBSystemSceneManager sharedInstanced] deleteSystemScene:_delete_sid withDevTid:currentgateway2];
            [[DBSceneReManager sharedInstanced] deleteRelation:_delete_sid withDevTid:currentgateway2];
            [[DBGS584RelationShipManager sharedInstanced] deleteRelation:_delete_sid withDevTid:currentgateway2];
            [self refresh];
        }
    }else if([Single sharedInstanced].command == DelteScene){
        [Single sharedInstanced].command = -1;
        if(_delete_mid!=nil){
            NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
            NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
                GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
            
            [[DBSceneReManager sharedInstanced] deleteRelationWithMid:_delete_mid withDevTid:currentgateway2];
            [[DBSceneManager sharedInstanced] deleteScene:_delete_mid withDevTid:currentgateway2];
            [self refresh];
            
            for(int i=0;i<_list_system_scene.count;i++){
                SystemSceneModel *model = [_list_system_scene objectAtIndex:i];
                NSMutableArray <NSNumber *> *mids = [[DBSceneReManager sharedInstanced] querymid:model.sence_group withDevTid:currentgateway2];
                NSMutableArray <GS584RelationShip *> *ships = [[DBGS584RelationShipManager sharedInstanced] queryAllGS584RelationShipwithDevTid:currentgateway2 withSid:model.sence_group];
               NSString *content = [ContentHepler getContentFromSystem:model withSceneRelationShip:mids withGS584Relations:ships];
                
                NSLog(@"删除时同时发的其他命令%@",content);
                PushSystemSceneApi *apia = [[PushSystemSceneApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost SceneContent:content];
                [apia startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                    
                }];
                
            }
            
        }

        
    }else if([Single sharedInstanced].command == ClickToAction){
        [Single sharedInstanced].command = -1;
        [MBProgressHUD showSuccess:NSLocalizedString(@"执行成功", nil) ToView:GetWindow];
    }

}

#pragma -mark method
-(void)BtnClick:(id)Sender{
    SceneEditController *sc = [[SceneEditController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
}

-(void)gotoSystemSceneAdd{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    if([NSString isBlankString:currentgateway2]){
        [MBProgressHUD showError:NSLocalizedString(@"请选择网关", nil) ToView:self.view];
    }else if(_list_system_scene.count>=8){
        [MBProgressHUD showError:NSLocalizedString(@"情景模式达到上限", nil) ToView:self.view];
    }else{
        SystemSceneEditController *systemSceneController = [[SystemSceneEditController alloc] init];
        [self.navigationController pushViewController:systemSceneController animated:YES];
    }

}

-(void)gototimerlist{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    if([NSString isBlankString:currentgateway2]){
        [MBProgressHUD showError:NSLocalizedString(@"请选择网关", nil) ToView:self.view];
    }else{
        TimerListController *timercv = [[TimerListController alloc] init];
        [self.navigationController pushViewController:timercv animated:YES];
    }

}

-(void)refresh{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    _list_system_scene = [[DBSystemSceneManager sharedInstanced] queryAllSystemScene:gatewaymodel.devTid];
    
    _list_scene = [[DBSceneManager sharedInstanced] queryAllSysceneScene:[[DBSystemSceneManager sharedInstanced] queryCurrentSystemScene:gatewaymodel.devTid] withDevTid:gatewaymodel.devTid];
    [self.table_scene reloadData];
}
@end
