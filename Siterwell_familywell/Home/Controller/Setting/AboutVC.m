//
//  AboutVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/7.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "AboutVC.h"
#import "DBGatewayManager.h"
#import "GatewayVersionModel.h"
@interface AboutVC()<UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSString *appversion;
@property (nonatomic,copy) NSString *phonenumber;
@property (nonatomic,copy) NSString *mail;
@end
@implementation AboutVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"关于", nil);
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    _appversion = [NSString stringWithFormat:@"%@%@",[infoDic objectForKey:@"CFBundleDisplayName"],currentVersion];
    _phonenumber= @"0574-83007591";
    _mail = @"sales@china-siter.com";
    [self table];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text =  NSLocalizedString(@"App版本", nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            cell.detailTextLabel.text = _appversion;
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"点击查看固件更新", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"售后服务", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }


    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 2){
        UIActionSheet *showSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:_phonenumber,_mail, nil];
        [showSheet showInView:self.view];
    }else if(indexPath.row == 1){
        [self checkFirmwareVersion];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 170)];
    UIImageView *imageview = [UIImageView new];
    imageview.image = [UIImage imageNamed:@"appLogo"];
    [view addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(110);
        make.top.equalTo(view.mas_top).offset(30);
        make.centerX.equalTo(view);
    }];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 170;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phonenumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        
    }
}

#pragma mark -lazy

- (UITableView *)table {
    
    if(!_table){
        _table= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = 50;
        _table.separatorInset = UIEdgeInsetsZero;
        _table.tableFooterView = [[UIView alloc] init];
        _table.backgroundColor = RGB(239, 239, 243);
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(0);
        }];
    }
    
    return _table;
}

#pragma -mark method
//检测固件版本
- (void)  checkFirmwareVersion {
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    
    NSDictionary *dic = @{
                          @"devTid":gatewaymodel.devTid,
                          @"productPublicKey":gatewaymodel.productPublicKey,
                          @"binType":gatewaymodel.binType,
                          @"binVer":gatewaymodel.binVersion,
                          };
    
    @weakify(self)
    NSString *https = (ApiMap==nil?@"https://console-openapi.hekr.me":ApiMap[@"console-openapi.hekr.me"]);
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/external/device/fw/ota/check", https] parameters:@[dic] progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        
        GatewayVersionModel *mmodel = [[GatewayVersionModel alloc] initWithDictionary:responseObject[0] error:nil];
        if (mmodel.update == 1) {

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:[NSString stringWithFormat:NSLocalizedString(@"当前网关固件版本:%@,最新版本%@",nil),gatewaymodel.binVersion,mmodel.devFirmwareOTARawRuleVO.latestBinVer] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [MBProgressHUD showSuccess:NSLocalizedString(@"版本升级中，请耐心等待",nil) ToView:GetWindow];
         
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"暂不升级",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"固件已经是最新版本了",nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];
}


@end
