//
//  connectWifiVC.m
//  sHome
//
//  Created by shaop on 2016/12/21.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "connectWifiVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESP_ByteUtil.h"
#import "ESPUDPSocketClient.h"
#import "ESPTouchDelegate.h"
#import "GCDAsyncUdpSocket.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <POP/POP.h>
#import "ErrorCodeUtil.h"
#import "MyUdp.h"
#import "TimeZoneApi.h"
#import "HWCircleView.h"
#import "UploadTimeApi.h"
#import "QuestionViewController.h"
#import "BeforeConfigurationVC.h"
#import "SuccessVC.h"

@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>
@end
@implementation EspTouchDelegateImpl
//测试用接口
-(void) dismissAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
}

-(void) showAlertWithResult: (ESPTouchResult *) result {
    NSString *title = nil;
    NSString *message = [NSString stringWithFormat:@"%@ is connected to the wifi" , result.bssid];
    NSTimeInterval dismissSeconds = 3.5;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:dismissSeconds];
}

-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result {
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithResult:result];
    });
}

@end


@interface connectWifiVC ()<GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic)          UILabel              *statusLabel; //状态文字
@property (nonatomic, strong)          NSCondition          *_condition;
@property (atomic, strong)             ESPTouchTask         *_esptouchTask;
@property (strong, nonatomic)          UIImageView          *imgaView;
@property (nonatomic, strong)          EspTouchDelegateImpl *_esptouchDelegate;
@property (nonatomic ,strong)          GCDAsyncUdpSocket    *asyncUdpSocket;
@property (nonatomic , strong)         UIButton             *retryButton;
@property (nonatomic , strong)         UIButton             *needHelpButton;

@property (nonatomic) HWCircleView *circleView;

@property (nonatomic) NSTimer *timer;

@property (nonatomic) NSTimer *secondTimer;

//@property (nonatomic) NSString *devTid;
@property (nonatomic, copy) NSString *result9999;
@property (nonatomic, assign) NSInteger repeatCount;

@end


@implementation connectWifiVC
{
    int progress;
    NSString *_devTid;
    NSString *_bindId;
    NSString *yo_name;
    
    NSString *_ctrlKey;
    BOOL _isOver;
    BOOL _isConnecting;
    BOOL _isSwitchOver;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"配置WIFI", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.repeatCount = 3;
    progress = 0;
    _bindId = @"";
    yo_name = @"";
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    [self imgaView];
    [self statusLabel];
    HWCircleView *circleView = [[HWCircleView alloc] initWithFrame:[self imgaView].frame];
    [self.view addSubview:circleView];
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(180);
        make.center.equalTo(0);
    }];
    _circleView = circleView;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    [self executeForResults];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self._esptouchTask interrupt];
}

- (void)timerAction {
    self.circleView.progress += 0.01;
    
    if (_circleView.progress >= 1) {
        [self removeTimer];
        [self searchDeviceField];
        NSLog(@"完成");
    }
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)searchDeviceField {
    
}

#pragma -mark lazy
-(UIImageView *)imgaView{
    if(_imgaView==nil){
        _imgaView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imgaView setImage:[UIImage imageNamed:@"ljsb_icon"]];
        [self.view addSubview:_imgaView];
        [_imgaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(180);
            make.center.equalTo(0);
        }];
        _imgaView.hidden = YES;
    }
    return _imgaView;
}

-(UILabel *)statusLabel{
    if(_statusLabel==nil){
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = NSLocalizedString(@"连接中..", nil);
        [self.view addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(_imgaView.mas_bottom).offset(10);
        }];
    }
    return _statusLabel;
}

#pragma mark - 获取wifi结果
- (NSArray *) executeForResults {
    [self._condition lock];
    NSString *apSsid = self.apSsid;
    NSString *apPwd = self.apPwd;
    NSString *apBssid = [self fetchBssid];
    BOOL isSsidHidden = NO;
    self._esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:isSsidHidden];
    // set delegate
    [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
    [self._condition unlock];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * esptouchResults = [self._esptouchTask executeForResults:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            ESPTouchResult *dic = esptouchResults[0];
            if (dic.bssid) {
                self.statusLabel.text = NSLocalizedString(@"已找到设备，绑定账号中",nil);
                _devTid = @"";
                NSString *st_devTid = [@"ST_" stringByAppendingString:dic.bssid];
                NSString *ipV4 = [ESP_NetUtil descriptionInetAddr4ByData:dic.ipAddrData];
                [[NSUserDefaults standardUserDefaults] setObject:[ESP_NetUtil descriptionInetAddr4ByData:dic.ipAddrData] forKey:@"ipV4"];
                @weakify(self)
                __block NSObject *objs = [[NSObject alloc] init];
                [[MyUdp shared] recvTokenObj:objs Callback:^(id obj, id data, NSError *error) {
                    @strongify(self)
                    [objs description];
                    [self getToken:data WithObj:objs];
                }];
                
                __block NSObject *objs2 = [[NSObject alloc] init];
                [[MyUdp shared] recvSwitchServerObj:objs2 Callback:^(id obj, id data, NSError *error) {
                    @strongify(self)
                    [objs2 description];
                    _isSwitchOver = YES;
                    NSLog(@"切换服务器成功");
                }];

                [[MyUdp shared] sendSwitchServer:ipV4 withDeviceID:st_devTid];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   if(_isSwitchOver == NO) [[MyUdp shared] sendSwitchServer:ipV4 withDeviceID:st_devTid];
                });

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  if(_isSwitchOver == NO) [[MyUdp shared] sendSwitchServer:ipV4 withDeviceID:st_devTid];
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                });
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(21 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(27 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(36 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(39 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(42 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(48 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(51 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(54 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(57 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(63 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(66 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""]) {
                        [[MyUdp shared] sendGetTokenEmptynNew:ipV4 withDeviceID:st_devTid];
                    }
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(69 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_bindId isEqualToString:@""] && [yo_name isEqualToString:@""]) {
                        _statusLabel.text = NSLocalizedString(@"配网失败", nil);
                        [_imgaView setHidden:NO];
                        WS(ws)
                        if (!self.retryButton) {
                            
                            self.retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
                            [self.retryButton setTitle:NSLocalizedString(@"重试",nil) forState:UIControlStateNormal];
                            [self.retryButton addTarget:self action:@selector(retryBind:) forControlEvents:UIControlEventTouchUpInside];
                            [self.view addSubview:self.retryButton];
                            [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(ws.statusLabel.mas_bottom).offset(13);
                                make.centerX.equalTo(ws.view);
                            }];
                        }
                        [self.retryButton setHidden:NO];
                    }
                    else if ([_bindId isEqualToString:@""] && ![yo_name isEqualToString:@""]) {
                        _statusLabel.text = NSLocalizedString(@"网关连上WI-FI，但是未连上服务器", nil);
                        [_imgaView setHidden:NO];
                        WS(ws)
                        if (!self.retryButton) {
                            
                            self.retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
                            [self.retryButton setTitle:NSLocalizedString(@"重试",nil) forState:UIControlStateNormal];
                            [self.retryButton addTarget:self action:@selector(retryBind:) forControlEvents:UIControlEventTouchUpInside];
                            [self.view addSubview:self.retryButton];
                            [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(ws.statusLabel.mas_bottom).offset(13);
                                make.centerX.equalTo(ws.view);
                            }];
                        }
                        [self.retryButton setHidden:NO];
                    }
                });
                
            }else{
                self.statusLabel.text = NSLocalizedString(@"没有找到设备",nil);
                [self needHelpButton];
                if (!self.retryButton) {
                    [self.imgaView setHidden:NO];
                    [self.circleView setHidden:YES];
                    self.retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    [self.retryButton setTitle:NSLocalizedString(@"重试",nil) forState:UIControlStateNormal];
                    [self.retryButton addTarget:self action:@selector(retryBind:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:self.retryButton];
                    WS(ws)
                    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(ws.needHelpButton.mas_bottom).offset(13);
                        make.centerX.equalTo(ws.view);
                    }];
                }
                [self.retryButton setHidden:NO];
            }
         
        });
    });
    
    return nil;
}

- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

- (NSString *)fetchBssid
{
    NSDictionary *bssidInfo = [self fetchNetInfo];
    
    return [bssidInfo objectForKey:@"BSSID"];
}

-(void)DeviceMethod:(NSString *)bindkey{
    NSString *devTid = _devTid;
    if (([devTid isEqualToString:@""] || [devTid isEqualToString:@"NULL"]) && !_isOver) {
        return;
    }
    
    WS(ws)
    _bindId = bindkey;

    if ([devTid isEqualToString:@""]) {
        _statusLabel.text = NSLocalizedString(@"配网失败", nil);
        [_imgaView setHidden:NO];
        [self.circleView setHidden:YES];
        if (!self.retryButton) {
            
            self.retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [self.retryButton setTitle:NSLocalizedString(@"重试",nil) forState:UIControlStateNormal];
            [self.retryButton addTarget:self action:@selector(retryBind:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.retryButton];
            [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.statusLabel.mas_bottom).offset(13);
                make.centerX.equalTo(ws.view);
            }];
        }
        [self.retryButton setHidden:NO];
        return;
    }
    
    NSDictionary *param = @{
                            @"devTid":devTid,
                            @"deviceName":@"报警器",
                            @"bindKey":bindkey,
                            @"desc":@"device"
                            };
    
    NSLog(@"%@",param);


    if (_isConnecting) {
        return;
    }
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    manager.requestSerializer.timeoutInterval = 200.0f;
    _isConnecting = YES;
    @weakify(self)
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
    [manager POST:[NSString stringWithFormat:@"%@/device", https] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        _devTid = devTid;
        [self removeTimer];
        self.secondTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(secondTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.secondTimer forMode:NSRunLoopCommonModes];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            self.statusLabel.text = NSLocalizedString(@"绑定成功！",nil);
            TimeZoneApi *zoneApi = [[TimeZoneApi alloc] initWithDevTid:devTid CtrlKey:_ctrlKey Domain:nil];
            [zoneApi startUdpObj:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                
            } failure:^(id data, NSError *error) {
                
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UploadTimeApi *api = [[UploadTimeApi alloc] initWithDevTid:devTid CtrlKey:_ctrlKey Domain:nil];
                [api startUdpObj:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                    
                } failure:^(id data, NSError *error) {
                    
                }];
            });
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self)
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        
        //如果是这个状态码。则说明绑定重复了，需要进行账号判断
        if (model.code == 5400043 || model.code == 5400013) {
            NSDictionary *parame = @{
                                  @"devTid" : devTid,
                                  @"bindKey" : bindkey
                                  };
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/device", https] parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //账号判断
                NSDictionary *dic = responseObject;
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                NSString *username = [config objectForKey:@"UserName"];
                if ([dic[@"message"] isEqualToString:username]) {
                    self.statusLabel.text = NSLocalizedString(@"绑定成功！",nil);
                    TimeZoneApi *zoneApi = [[TimeZoneApi alloc] initWithDevTid:devTid CtrlKey:_ctrlKey Domain:nil];
                    [zoneApi startUdpObj:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                        
                    } failure:^(id data, NSError *error) {
                        
                    }];
                    
                    UploadTimeApi *api = [[UploadTimeApi alloc] initWithDevTid:devTid CtrlKey:_ctrlKey Domain:nil];
                    [api startUdpObj:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                        
                    } failure:^(id data, NSError *error) {
                        
                    }];

                    _devTid = devTid;
                    [self removeTimer];
                    self.secondTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(secondTimerAction) userInfo:nil repeats:YES];
                    [[NSRunLoop mainRunLoop] addTimer:self.secondTimer forMode:NSRunLoopCommonModes];
                }else {
                    model.desc = [model.desc stringByAppendingString:[NSString stringWithFormat:@" %@ %@",devTid, dic[@"message"]]];
                    model.userinfo = dic[@"message"];
                    [self printError:model bindKey:bindkey];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self printError:model bindKey:bindkey];
            }];
        }else {
            //如果不是的话，正常报错
//            [self printError:model bindKey:bindkey];
            if (self.repeatCount > 0) {
                [self DeviceMethod: self.result9999];
                self.repeatCount -= 1;
            } else {
                [self printError:model bindKey:bindkey];
            }
            
        }
        
    }];
}

- (void)printError: (ErrorModel *)model bindKey:(NSString *)bindkey{
    self.statusLabel.text = [NSString stringWithFormat:@"%@", [ErrorCodeUtil getErrorMessageWithError:model withDeviceTid:_devTid]] ;
    
    [self.circleView setHidden:YES];
    
    if (!self.retryButton) {
        [self.imgaView setHidden:NO];
        
        self.retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.retryButton setTitle:NSLocalizedString(@"重试",nil) forState:UIControlStateNormal];
        _bindId = bindkey;
        [self.retryButton addTarget:self action:@selector(retryBind:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.retryButton];
        WS(ws)
        [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.statusLabel.mas_bottom).offset(13);
            make.centerX.equalTo(ws.view);
        }];
    }
    [self.retryButton setHidden:NO];
}

- (void)retryBind:(UIButton *)button{
//    [self DeviceMethod:_bindId];
    
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[BeforeConfigurationVC class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
    [button setHidden:YES];
}

-(void)lookforreason:(UIButton *)button{
    QuestionViewController *vc =[[QuestionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getToken:(NSString *)str WithObj:(id)obj{
    NSLog(@">>>>>>>>%@",str);

    if([str rangeOfString:@"NAME"].location != NSNotFound && [str rangeOfString:@"BIND"].location != NSNotFound) {
        if([_statusLabel.text isEqualToString:NSLocalizedString(@"已找到设备，绑定账号中",nil)]){
            _statusLabel.text = NSLocalizedString(@"设备得到响应", nil);
        }
        
        NSRange startRange1 = [str rangeOfString:@"NAME:"];
        NSRange endRange1 = [str rangeOfString:@"BIND:"];
        NSRange range1 = NSMakeRange(startRange1.location + startRange1.length, endRange1.location - startRange1.location - startRange1.length);
        NSString *result1 = [str substringWithRange:range1];
        result1 = [result1 substringWithRange:NSMakeRange(0, [result1 length] - 1)];
        if ([result1 isEqualToString:@"NULL"]) {
            return;
        }
        obj = nil;
        _devTid = result1;
        yo_name = result1;

        NSRange startRange = [str rangeOfString:@"BIND:"];
        NSRange endRange = [str rangeOfString:@"KEY:"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [str substringWithRange:range];
        result = [result substringWithRange:NSMakeRange(0, [result length] - 1)];
        NSLog(@"%@",result);
        _bindId = result;
        
        NSString *ctrlKey = [str componentsSeparatedByString:@"KEY:"].lastObject;
        ctrlKey = [ctrlKey stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        _ctrlKey = ctrlKey;
        
        self.result9999 = result;
        [self performSelector:@selector(DeviceMethod:) withObject:result afterDelay:5.0];
        
    }

}

- (void)secondTimerAction {
    self.circleView.progress += 0.01;
    if (_circleView.progress >= 1) {
        [self removeSecondTimer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //跳转到成功页面
            SuccessVC *successVc = [[SuccessVC alloc] init];
            [self.navigationController pushViewController:successVc animated:YES];
        });
    }
}

- (void)removeSecondTimer {
    [_secondTimer invalidate];
    _secondTimer = nil;
}


-(UIButton *)needHelpButton{
    if(_needHelpButton == nil){
            self.needHelpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        // underline Terms and condidtions
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:[NSLocalizedString(@"配网失败原因", nil) stringByAppendingString:@"?"] ];
        
        //设置下划线...
        /*
         NSUnderlineStyleNone                                    = 0x00, 无下划线
         NSUnderlineStyleSingle                                  = 0x01, 单行下划线
         NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
         NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
         */
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        //此时如果设置字体颜色要这样
        [tncString addAttribute:NSForegroundColorAttributeName value:ThemeColor  range:NSMakeRange(0,[tncString length])];
        
        //设置下划线颜色...
        [tncString addAttribute:NSUnderlineColorAttributeName value:ThemeColor range:(NSRange){0,[tncString length]}];
        [self.needHelpButton setAttributedTitle:tncString forState:UIControlStateNormal];
        
            [self.needHelpButton addTarget:self action:@selector(lookforreason:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.needHelpButton];
            WS(ws)
            [self.needHelpButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.statusLabel.mas_bottom).offset(13);
                make.centerX.equalTo(ws.view);
            }];
    
    }
    return _needHelpButton;
}
@end
