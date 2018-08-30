//
//  UIViewController+HomeVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/2/23.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HomeVC.h"
#import "DeviceListVC.h"
#import "CYMarquee.h"
#import "CYNetManager.h"
#import "ModeCircleView.h"
#import "CircleMenuVc.h"
#import "HomeHeadView.h"
#import "SettingController.h"
#import "DBGatewayManager.h"
#import <CoreLocation/CoreLocation.h>
#import "SiterwellReceiver.h"
#import "DBDeviceManager.h"
#import "DBGatewayManager.h"
#import "DBSceneManager.h"
#import "WarnAnalisysHelper.h"
#import "PostControllerApi.h"
@interface HomeVC()<CLLocationManagerDelegate,HomeHeadViewDelegate,SiterwellDelegate>
@property (nonatomic) CLLocationManager *locationMgr;
@property (nonatomic,strong) CYMarquee *weather_marquee;
@property (nonatomic,strong) ModeCircleView *modecirleView;
@property (nonatomic,strong) CircleMenuVc *menuVc;
@property (nonatomic,strong) HomeHeadView *videoView;
@property (nonatomic,strong) UIButton *titlbtn;
@property (nonatomic) SiterwellReceiver *siter;
@property (nonatomic) NSObject *testobj;
@end


@implementation HomeVC{
    BOOL flag;
    NSMutableArray <SystemSceneModel *>* _systemSceneListArray;
}


#pragma mark -life
-(void)viewDidLoad{
    _siter =  [[SiterwellReceiver alloc] init];
    _testobj = [[NSObject alloc] init];
    [_siter recv:_testobj callback:^(id obj, id data, NSError *error) {
        
    }];
    _siter.siterwelldelegate = self;
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel * gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    NSMutableArray <ItemData *> *dsa = [[DBDeviceManager sharedInstanced] queryAllTHCheck:currentgateway2];
    self.weather_marquee.tempAndHumArray=dsa;
    
    [[self titlbtn] setTitle:([gateway.deviceName isEqualToString:@"报警器"]?NSLocalizedString(@"我的家", nil):gateway.deviceName) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(test) image:@"setting_icon" highImage:@"setting_icon" withTintColor:[UIColor whiteColor]];


    UIColor* color = [UIColor whiteColor];
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes= dict;
    [self initLocation];
    

    [self modecirleView];
    
    NSArray * ds = @[@{@"devid":@"lbt_01",@"name":@"嘿嘿嘿"}];
    [self.videoView setVideoArray:ds];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    //设置透明标题栏
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    _systemSceneListArray = [[NSMutableArray alloc] init];;
    for(int i=0;i<3;i++){
        SystemSceneModel * itemdata = [[SystemSceneModel alloc] init];
        [_systemSceneListArray addObject:itemdata];
    }
    //圆形菜单
    _menuVc = [[CircleMenuVc alloc] initWithButtonCount:_systemSceneListArray.count
                                               menuSize:kKYCircleMenuSize
                                             buttonSize:kKYCircleMenuButtonSize
                                  buttonImageNameFormat:kKYICircleMenuButtonImageNameFormat
                                       centerButtonSize:kKYCircleMenuCenterButtonSize
                                  centerButtonImageName:kKYICircleMenuCenterButton
                        centerButtonBackgroundImageName:kKYICircleMenuCenterButtonBackground
                                            centerPoint:_modecirleView.center
                                           sysSceneArry:_systemSceneListArray];
    _menuVc.view.frame = self.tabBarController.view.frame;
    [[UIApplication sharedApplication].keyWindow addSubview:_menuVc.view];
    
    _menuVc.view.hidden = YES;
    
    __weak typeof (self) weakSelf = self;
    _menuVc.closedCircleMenu = ^{
        weakSelf.menuVc.view.hidden = YES;
    };
    _menuVc.clickedMenu = ^(NSInteger tag) {
        
        weakSelf.menuVc.view.hidden = YES;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark -lazy

- (UIButton *)titlbtn {
    if (!_titlbtn) {
        _titlbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titlbtn setBackgroundColor:[UIColor clearColor]];
        [_titlbtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [_titlbtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [self.navigationController.navigationBar addSubview:_titlbtn];
        [_titlbtn addTarget:self action:@selector(selectGateWays) forControlEvents:UIControlEventTouchUpInside];
        [_titlbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.centerX.equalTo(0);
            make.centerY.equalTo(0);
        }];
    }
    return _titlbtn;
}

-(CYMarquee *)weather_marquee{
    if(!_weather_marquee){
        _weather_marquee = [[CYMarquee alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 260)];
        [self.view addSubview:_weather_marquee];
    }
    return _weather_marquee;
}

-(ModeCircleView *)modecirleView{
    if(!_modecirleView){
        _modecirleView = [[ModeCircleView alloc]init];
        [self.view addSubview:_modecirleView];
        [_modecirleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.bottom.mas_equalTo(self.weather_marquee.mas_bottom).offset(30);
            make.centerX.equalTo(0);
        }];
        [_modecirleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCircleMenu)]];
        _modecirleView.userInteractionEnabled = YES;
        
    }
    return _modecirleView;
}

-(HomeHeadView *)videoView{
    if(!_videoView){
        _videoView = [[HomeHeadView alloc] init];
        [self.view addSubview:_videoView];
        [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(Main_Screen_Width, Main_Screen_Width*79/108));
            make.top.equalTo(_weather_marquee.bottom);
            
        }];
        [self.view bringSubviewToFront:_modecirleView];
    }
    return _videoView;
}

#pragma mark -method
-(void)initLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationMgr = [[CLLocationManager alloc] init];
        self.locationMgr.delegate = self;
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.locationMgr requestAlwaysAuthorization];
        self.locationMgr.distanceFilter = 10.0f;
        [self.locationMgr startUpdatingLocation];
    }
}

- (void)getLocationWeather {
    NSString *lan;
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if ([languageName containsString:@"zh"]) {
        lan = @"zh";
    } else if ([languageName containsString:@"de"]) {
        lan = @"de";
    } else if ([languageName containsString:@"fr"]) {
        lan = @"fr";
    }else if ([languageName containsString:@"es"]) {
        lan = @"es";
    } else {
        lan = @"en";
    }
    

    
    NSDictionary *params = @{@"lat": @(self.locationMgr.location.coordinate.latitude),
                             @"lon": @(self.locationMgr.location.coordinate.longitude),
                             @"appid": @"b45eb4739891c226b7a36613ce3d1dbd",
                             @"lang" : lan };
    [CYNetManager getWeatherWithParams:params handler:^(NewWeatherModel *model, NSError *error) {
        if (!error) {

            NSDictionary *modelDict = @{@"weather": model.weather,
                                        @"humidity": model.humidity,
                                        @"icon": model.icon,
                                        @"temp": model.temp
                                        };
            [[NSUserDefaults standardUserDefaults] setObject:modelDict forKey:@"weatherDict"];
            _weather_marquee.model = model;
        }
    }];
    
    NSDictionary *parames = @{@"latlng": [NSString stringWithFormat:@"%f,%f",self.locationMgr.location.coordinate.latitude, self.locationMgr.location.coordinate.longitude],
                              @"sensor": @"true",
                              @"language": lan
                              };
    [CYNetManager getLocationWithParams:parames handler:^(NSString *address, NSString *errorStr) {
        if ([errorStr isEqualToString:@"OK"]) {
            _weather_marquee.address = address;
            [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"address"];
        } else {
        }
    }];
}

-(void)test{
//    SettingController * vc = [[SettingController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];

    SettingController *wl = [[SettingController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wl];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)showCircleMenu{
    _menuVc.view.hidden = NO;
    [_menuVc open];
}

#pragma mark -delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self getLocationWeather];
}

- (void)cycleScrollView:(HomeHeadView *)cycleScrollView didSelectImageView:(NSInteger)index videoInfos:(NSArray *)videosArray {
    
}


#pragma -mark 长链接代理方法
- (void)onAnswerOK:(NSString *)devTid {
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    if([currentgateway2 isEqualToString:devTid]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"answer_ok" object:nil];
    }

}

- (void)onDeviceStatus:(ItemData *)devicemodel withDevTid:(NSString *)devTid {
    [devicemodel setDevTid:devTid];
    [[DBDeviceManager sharedInstanced] insertDevice:devicemodel];
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    if([currentgateway2 isEqualToString:devTid]){
           [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceSuccess" object:nil];
    }
}

- (void)onUpdateOnCurrentSystemScene:(NSNumber *)currentmodel withDevTid:(NSString *)devTid {
    
}

- (void)onUpdateOnScene:(SceneModel *)scenemodel withDevTid:(NSString *)devTid {
    
}

- (void)onUpdateOnSystemScene:(SystemSceneModel *)systemscenemodel withDevTid:(NSString *)devTid {
    
}

- (void)onlinestatus:(NSString *)devTid {
    
}

-(void)onAlert:(NSString *)content withDevTid:(NSString *)devTid{
    
    if(content.length < 8 && devTid.length < 4)
        return;
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    NSString * alarmtype;
    NSString * gatewaytype;
    NSString * gatewayname;
    NSString * lastfour;
    NSString * devicename;
    NSString * alartname;
    NSString * scenename;
    
    if([currentgateway2 isEqualToString:devTid]){
        gatewaytype = NSLocalizedString(@"当前网关", nil);
    }else{
        gatewaytype = NSLocalizedString(@"其他网关", nil);
    }
    GatewayModel * gatew = [[DBGatewayManager sharedInstanced] queryForChosedGateway:devTid];
    if ([gatew.deviceName isEqualToString:@"报警器"] || [gatew.deviceName isEqualToString:@"智能网关"]) {
        gatewayname =  NSLocalizedString(@"我的家", nil);
    }else{
        gatewayname = gatew.deviceName;
    }
    alarmtype = [content substringWithRange:NSMakeRange(4, 2)];
    lastfour = [devTid substringWithRange:NSMakeRange(devTid.length-4, 4)];
    if([alarmtype isEqualToString:@"AD"]){
        NSString *deviceid = [content substringWithRange:NSMakeRange(6, 4)];
        
        deviceid = [NSString stringWithFormat:@"%d",(int)strtoul([deviceid UTF8String],0,16)];
        
        NSNumber *dev_ID = [NSNumber numberWithInt:[deviceid intValue]];
       ItemData *dev = [[DBDeviceManager sharedInstanced] queryDeviceModel:dev_ID withDevTid:devTid];
        
        if([NSString isBlankString:dev.customTitle]){
            NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
            NSDictionary * _names = [dic valueForKey:@"names"];
            devicename = [NSString stringWithFormat:@"%@%@",NSLocalizedString([_names objectForKey:dev.device_name], nil),dev.device_ID];
        }else {
            devicename = dev.customTitle;
        }
        
        NSString *deviceName = [content substringWithRange:NSMakeRange(10, 4)];
        NSString *deviceStatus = [content substringWithRange:NSMakeRange(14, 8)];
        
        alartname = [WarnAnalisysHelper getAlertWithDevType:deviceName status:deviceStatus withID:dev_ID];
        ItemData *dev2 = [[ItemData alloc] initWithTitle:@"" DevID:[dev_ID integerValue] DevType:deviceName Code:deviceStatus];
        [dev2 setDevTid:devTid];
        [[DBDeviceManager sharedInstanced] insertDevice:dev2];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceSuccess" object:nil];
    }else if([alarmtype isEqualToString:@"AC"]){
        NSNumber * scene_ID = [BatterHelp numberHexString:[content substringWithRange:NSMakeRange(6, 2)]];
        SceneModel *scene = [[DBSceneManager sharedInstanced] querySceneModel:scene_ID withDevTid:devTid];
        if([NSString isBlankString:scene.scene_name]){
            scenename = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"情景", nil),scene.scene_type];
        }else{
            scenename = scene.scene_name;
        }
    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:gatewaytype message:[NSString stringWithFormat:NSLocalizedString(@"请注意，%@(%@) 的 %@%@", nil),gatewayname ,lastfour ,[alarmtype isEqualToString:@"AD"]?devicename:scenename, [alarmtype isEqualToString:@"AD"]?alartname:NSLocalizedString(@"触发", nil)] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"静音", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       GatewayModel *gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:devTid];
       PostControllerApi *api = [[PostControllerApi alloc] initWithDrivce:devTid andCtrlKey:gateway.ctrlKey DeviceID:@0 DeviceStatus:@"00000000" ConnectHost:gateway.connectHost];
        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
            
        }];
    }]];
    [GetWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
