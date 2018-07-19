//
//  InitController.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "InitController.h"
#import "DBGatewayManager.h"
@interface InitController()
@property (nonatomic,strong) UIImage * LogoImage;
@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,strong) NSMutableArray <GatewayModel *> * gateways;
@end

@implementation InitController

-(void)viewDidLoad {
    [self SetView];
 //   _flag = 0;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if(_flag == 0){
//            UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            AppDelegate* appDelagete = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            appDelagete.window.rootViewController = [uistoryboard instantiateInitialViewController];
//        }
//
//    });
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

    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device", ApiMap[@"user-openapi.hekr.me"]] parameters:@{@"page":@(0),@"size":@(20)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSArray *arr = responseObject;
        if (arr.count>0) {
            for(int i=0;i<arr.count;i++){
                GatewayModel * ds = [[GatewayModel alloc] initWithDictionary:[arr objectAtIndex:i] error:nil];
                ds.domain = [arr objectAtIndex:i][@"dcInfo"][@"domain"];
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
}
@end

