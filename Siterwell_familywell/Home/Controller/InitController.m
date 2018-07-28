//
//  InitController.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "InitController.h"
#import "DBGatewayManager.h"
#import "DBDeviceManager.h"
#import "SiterwellReceiver.h"
#import "SycnSceneApi.h"
#import "ChooseSystemSceneApi.h"
@interface InitController()<SiterwellDelegate>
@property (nonatomic,strong) UIImage * LogoImage;
@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,strong) NSMutableArray <GatewayModel *> * gateways;
@property (nonatomic) SiterwellReceiver *siter;
@property (nonatomic) NSObject *testobj;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger count;
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
    [[DBGatewayManager sharedInstanced] insertDevices:_gateways];
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
        
        SycnSceneApi * sy = [[SycnSceneApi alloc] initWithDevTid:gatewaymodel.devTid CtrlKey:gatewaymodel.ctrlKey Domain:gatewaymodel.connectHost SceneGroup:@"0" answerContent:@"000851B168EF4FEF" SceneContent:@"00043FCA"];
        [sy startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
            NSLog(@"得到数据为%@",data);
        }];
    }


    
}

-(void) adddone{
    _count ++ ;
    NSLog(@"同步超时计数：%ld",_count);
    if(_count == 5)
    {
        _count = 0;
        [_timer invalidate];
    }
}

- (void)onlinestatus:(NSString *)devTid {
        NSLog(@"onlinestatus");
}

-(void)onUpdateOnSystemScene:(SystemSceneModel *)systemscenemodel withDevTid:(NSString *)devTid{
    NSLog(@"onUpdateOnSystemScene%@",systemscenemodel);
}

-(void)onUpdateOnScene:(SceneModel *)scenemodel withDevTid:(NSString *)devTid{
    
}

-(void) onUpdateOnCurrentSystemScene:(NSString *)currentmodel withDevTid:(NSString *)devTid{
    
}

-(void) onDeviceStatus:(DeviceModel *)devicemodel withDevTid:(NSString *)devTid{
    if([devicemodel.device_ID intValue] == 65535){
        
    }else{
        [devicemodel setDevTid:devTid];
        [[DBDeviceManager sharedInstanced] insertDevice:devicemodel];
    }

}
@end

