//
//  InitController.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "InitController.h"
#import "DBGatewayManager.h"
#import "DBSystemSceneManager.h"
#import "DBSceneManager.h"
#import "DBDeviceManager.h"
#import "SiterwellReceiver.h"
#import "SycnSceneApi.h"
#import "ScynDeviceApi.h"
#import "ChooseSystemSceneApi.h"
#import "CRCqueueHelp.h"
@interface InitController()<SiterwellDelegate>
@property (nonatomic,strong) UIImage * LogoImage;
@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,strong) NSMutableArray <GatewayModel *> * gateways;
@property (nonatomic) SiterwellReceiver *siter;
@property (nonatomic) NSObject *testobj;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger count;
@property (nonatomic,assign)BOOL flag_timer;
@property (nonatomic,copy) NSNumber *current_system_scene;
@end

@implementation InitController

#pragma mark -life
-(void)viewDidLoad {
    [self SetView];
    _siter =  [[SiterwellReceiver alloc] init];
    _testobj = [[NSObject alloc] init];
    [_siter recv:_testobj callback:^(id obj, id data, NSError *error) {

    }];
    _siter.siterwelldelegate = self;
 //   _flag = 0;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if(_flag == 0){
//            UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            AppDelegate* appDelagete = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            appDelagete.window.rootViewController = [uistoryboard instantiateInitialViewController];
//        }
//
//    });
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(adddone) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    
    _gateways = [[NSMutableArray alloc] init];
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *username = [config objectForKey:@"UserName"];
    if(username.length>0){
            [[DBManager sharedInstanced] openDB:username];
    }

    if(!self.flag_login){
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        NSString *username = [config objectForKey:@"UserName"];
        NSString *password = [config objectForKey:@"Password"];
        WS(ws);
        if([Hekr sharedInstance].user && username.length != 0 && password.length != 0){
            [[Hekr sharedInstance] login:username password:password callbcak:^(id user, NSError *error) {
                
                if (!error) {
                    NSLog(@"重新登录成功");
                    UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AppDelegateInstance.window.rootViewController = [uistoryboard instantiateInitialViewController];
                }else{
                    if (error.code == -1011) {
                        [[Hekr sharedInstance] logout];
                        NSLog(@"重新登录失败：密码错误");
                        UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
                        AppDelegateInstance.window.rootViewController = [uistoryboard instantiateInitialViewController];
                        [MBProgressHUD showError:NSLocalizedString(@"用户名密码错误", nil) ToView:ws.view];
                    }
                }
            }];
        }
    }else{
        [_gateways removeAllObjects];
        [self getGateways];
    }

    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    _testobj = nil;
}


-(void) dealloc{
    NSLog(@"dealloc");
}


#pragma mark - method
-(void)SetView{
    //[self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = RGB(255, 255, 255);
    UIImageView *logoIMG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appLogo"]];
    [self.view addSubview:logoIMG];
    [logoIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(200);
        make.height.equalTo(200);
        make.centerY.equalTo(0);
    }];
}

-(void)getGateways{
    @weakify(self)

     NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *currentdomain = [config objectForKey:@"hekr_domain"];
    NSString *baseurl = [NSString isBlankString:currentdomain]?@"https://user-openapi.hekr.me":[NSString stringWithFormat:@"%@%@",@"https://user-openapi.",currentdomain];
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device", baseurl] parameters:@{@"page":@(0),@"size":@(20)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSArray *arr = responseObject;
        if (arr.count>0) {
            for(int i=0;i<arr.count;i++){
                GatewayModel * ds = [[GatewayModel alloc] initWithDictionary:[arr objectAtIndex:i] error:nil];
                ds.connectHost = [arr objectAtIndex:i][@"dcInfo"][@"connectHost"];
                [_gateways addObject:ds];
            }
            if(arr.count == 20){
                [self getGateways];
            }else{
              [self getChooseGateway];
            }
        }else{
            [self getChooseGateway];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self getChooseGateway];
    }];
}


-(void)getChooseGateway{
    [[DBGatewayManager sharedInstanced] insertGateways:_gateways];
    for(int i=0;i<_gateways.count;i++){
        GatewayModel * gateway = [_gateways objectAtIndex:i];
        
        SystemSceneModel * sys = [[SystemSceneModel alloc] init];
        sys.systemname=@"";
        sys.sence_group = @0;
        sys.choice = @0;
        sys.devTid = gateway.devTid;
        sys.color = @"F0";
        
        SystemSceneModel * sys1 = [[SystemSceneModel alloc] init];
        sys1.systemname=@"";
        sys1.sence_group = @1;
        sys1.choice = @0;
        sys1.devTid = gateway.devTid;
        sys1.color = @"F1";
        
        SystemSceneModel * sys2 = [[SystemSceneModel alloc] init];
        sys2.systemname=@"";
        sys2.sence_group = @2;
        sys2.choice = @0;
        sys2.devTid = gateway.devTid;
        sys2.color = @"F2";
        
        NSArray *arr2=[[NSArray alloc]initWithObjects:sys,sys1,sys2, nil];
        
        [[DBSystemSceneManager sharedInstanced] insertSystemScenesInit:arr2];
    }
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway = [config objectForKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
    
    if([NSString isBlankString:currentgateway]){
        if(_gateways.count>0){
            for(GatewayModel *d in _gateways){
                if([d.online isEqualToString:@"1"]){
                    [config setObject:d.devTid forKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
                    break;
                }
            }
        }
    }else{
        if(_gateways.count>0){
            BOOL flag_contain = NO;
            NSString * will = nil;
            for(GatewayModel *d in _gateways){
                
                if([d.online isEqualToString:@"1"] && will == nil){
                    will = d.devTid;
                }
                
                if([d.devTid isEqualToString:currentgateway]){
                    flag_contain = YES;
                    break;
                }
            }
            
            if(!flag_contain){
                
                if(will == nil){
                    will = [_gateways objectAtIndex:0].devTid;
                }
               [config setObject:will forKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
            }
        }
    }
    [config synchronize];
    [_gateways removeAllObjects];
    
//    UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AppDelegateInstance.window.rootViewController = [uistoryboard instantiateInitialViewController];
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    
    if([NSString isBlankString:currentgateway2]){
                    UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    AppDelegateInstance.window.rootViewController = [uistoryboard instantiateInitialViewController];
    }else{
        GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
        
        _flag_timer = YES;
        ScynDeviceApi *deviceApi = [[ScynDeviceApi alloc] initWithDrivce:gatewaymodel.devTid andCtrlKey:gatewaymodel.ctrlKey DeviceStatus:[CRCqueueHelp getDeviceCRCContent:[[DBDeviceManager sharedInstanced] queryAllDevice:gatewaymodel.devTid]] ConnectHost:gatewaymodel.connectHost];
        [deviceApi startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
            NSLog(@"得到数据为%@",data);
        }];
    }


    
}

-(void) adddone{
    if(_flag_timer == YES){
        
        _count ++ ;
        NSLog(@"同步超时计数：%ld",_count);
        if(_count == 5)
        {
            _count = 0;
            [_timer invalidate];
            UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AppDelegateInstance.window.rootViewController = [uistoryboard instantiateInitialViewController];
        }
    }

}

- (void)onlinestatus:(NSString *)devTid {
        NSLog(@"onlinestatus");
}

-(void)onUpdateOnSystemScene:(SystemSceneModel *)systemscenemodel withDevTid:(NSString *)devTid{
    _count = 0;
    [[DBSceneReManager sharedInstanced] deleteRelation:systemscenemodel.sence_group withDevTid:devTid];
    [[DBGS584RelationShipManager sharedInstanced] deleteRelation:systemscenemodel.sence_group withDevTid:devTid];
    if(![[systemscenemodel.answer_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]){
        [systemscenemodel settotalDevTid:devTid];
        [[DBSystemSceneManager sharedInstanced] insertSystemScene:systemscenemodel];
        
        //关系表更新
        [[DBSceneReManager sharedInstanced] insertRelations:systemscenemodel.sceneRelationShip];
        [[DBGS584RelationShipManager sharedInstanced] insertGS584Relations:systemscenemodel.dev584List];
    }else{
        if([systemscenemodel.sence_group intValue] < 3){
            [[DBSystemSceneManager sharedInstanced] updateColor:[NSString stringWithFormat:@"F%@",systemscenemodel.sence_group] withSid:systemscenemodel.sence_group withDevTid:devTid];
        }else{
            [[DBSystemSceneManager sharedInstanced] deleteSystemScene:systemscenemodel.sence_group withDevTid:devTid];
        }

    }

}

-(void)onUpdateOnScene:(SceneModel *)scenemodel withDevTid:(NSString *)devTid{
        _count = 0;
    if([scenemodel.scene_type integerValue] == 256){
        if(_current_system_scene!=nil){
            [[DBSystemSceneManager sharedInstanced] updateSystemChoicewithSid:_current_system_scene withDevTid:devTid];
        }
        [_timer invalidate];
        UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegateInstance.window.rootViewController = [uistoryboard instantiateInitialViewController];
    }else{
        [scenemodel setDevTid:devTid];
        [[DBSceneManager sharedInstanced] insertScene:scenemodel];
    }
}

-(void) onUpdateOnCurrentSystemScene:(NSNumber *)currentmodel withDevTid:(NSString *)devTid{
    _count = 0;
    _current_system_scene = currentmodel;
    [[DBSystemSceneManager sharedInstanced] updateSystemChoicewithSid:_current_system_scene withDevTid:devTid];
}

-(void) onDeviceStatus:(DeviceModel *)devicemodel withDevTid:(NSString *)devTid{
    _count = 0;
    if([devicemodel.device_ID intValue] == 65535){
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
        
        NSMutableArray * systemscenelist = [[DBSystemSceneManager sharedInstanced] queryAllSystemScene:gatewaymodel.devTid];
        NSMutableArray * scenelist = [[DBSceneManager sharedInstanced] queryAllScenewithDevTid:gatewaymodel.devTid];
        
        NSString *sys = [CRCqueueHelp getSystemSceneCRCContent:systemscenelist withDevTid:gatewaymodel.devTid];
        NSString *scenes = [CRCqueueHelp getSceneCRCContent:scenelist];
        NSNumber *currentmode = [[DBSystemSceneManager sharedInstanced] queryCurrentSystemScene:gatewaymodel.devTid];
                SycnSceneApi * sy = [[SycnSceneApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost SceneGroup:currentmode answerContent:sys SceneContent:scenes];
                [sy startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                    NSLog(@"得到数据为%@",data);
                }];
    }else if([devicemodel.device_name isEqualToString:@"DEL"]){
        [[DBDeviceManager sharedInstanced] deleteDevice:devicemodel.device_ID withDevTid:devTid];
    }
    else{
        [devicemodel setDevTid:devTid];
        [[DBDeviceManager sharedInstanced] insertDevice:devicemodel];
    }

}
@end

