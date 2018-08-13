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
@interface SceneVC() <UITableViewDelegate,UITableViewDataSource,CLickdelegate,SiterwellDelegate>

@property (nonatomic,strong) UITableView *table_scene;
@property (nonatomic,strong) NSMutableArray <SystemSceneModel *> *list_system_scene;
@property (nonatomic,strong) NSMutableArray <SceneModel *> *list_scene;
@property (nonatomic,strong) SceneHeaderView *sceneheaderview;
@property (nonatomic,assign) NSInteger select_sid;
@property (nonatomic) SiterwellReceiver *siter;
@property (nonatomic) NSObject *testobj;
@end
@implementation SceneVC

#pragma -mark life

-(void)viewDidLoad{
        NSLog(@"viewDidLoad");
    self.title = NSLocalizedString(@"情景", nil);
    [self table_scene];
    _siter =  [[SiterwellReceiver alloc] init];
    _testobj = [[NSObject alloc] init];
    [_siter recv:_testobj callback:^(id obj, id data, NSError *error) {
        
    }];
    _siter.siterwelldelegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self refresh];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated{
     NSLog(@"viewWillDisappear");
    _testobj = nil;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}


-(void)viewDidDisappear:(BOOL)animated{
     NSLog(@"viewDidDisappear");
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
        }
        SceneModel *scenemodel = [_list_scene objectAtIndex:indexPath.row];
        cell2.titleLabel.text = [NSString stringWithFormat:@"%d",[scenemodel.scene_type intValue]];
        cell2.detailLabel.text = scenemodel.scene_name;
        
        return cell2;
    }

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.table_scene deselectRowAtIndexPath:[self.table_scene indexPathForSelectedRow] animated:YES];
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
        return 20;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0)
    {
        return 20;
    }else
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0){
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
    
}

-(void)click:(NSInteger)index{
    NSLog(@"新建%ld",index);
    _select_sid = index;
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    SystemSceneModel *model = _list_system_scene[index];
    ChooseSystemSceneApi *choose  = [[ChooseSystemSceneApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost SceneGroup:model.sence_group];
    [choose startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        NSLog(@"选择后返回的数据为%@",data);
    }];
}

-(void) onAnswerOK{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    [[DBSystemSceneManager sharedInstanced] updateSystemChoicewithSid:[NSNumber numberWithInteger:_select_sid] withDevTid:gatewaymodel.devTid];
    [self refresh];
    [self.table_scene reloadData];
}

#pragma -mark method
-(void)BtnClick:(id)Sender{
    SceneEditController *sc = [[SceneEditController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
}

-(void)refresh{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    _list_system_scene = [[DBSystemSceneManager sharedInstanced] queryAllSystemScene:gatewaymodel.devTid];
    
    _list_scene = [[DBSceneManager sharedInstanced] queryAllSysceneScene:[[DBSystemSceneManager sharedInstanced] queryCurrentSystemScene:gatewaymodel.devTid] withDevTid:gatewaymodel.devTid];
}
@end
