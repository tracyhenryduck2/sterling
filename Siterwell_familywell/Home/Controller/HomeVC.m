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
#import "DBSystemSceneManager.h"
#import "ChooseSystemSceneApi.h"
#import "Single.h"
#import "GatewayListVC.h"
#import "DBTimerManager.h"
#import "DBVideoManager.h"
#import "POP.h"
#import "WarningListViewController.h"
@interface HomeVC()<CLLocationManagerDelegate,HomeHeadViewDelegate,SiterwellDelegate>
@property (nonatomic) CLLocationManager *locationMgr;
@property (nonatomic,strong) CYMarquee *weather_marquee;
@property (nonatomic,strong) ModeCircleView *modecirleView;
@property (nonatomic,strong) CircleMenuVc *menuVc;
@property (nonatomic,strong) HomeHeadView *videoView;
@property (nonatomic,strong) UIButton *titlbtn;
@property (nonatomic) SiterwellReceiver *siter;
@property (nonatomic) NSObject *testobj;
@property (nonatomic,strong) NSMutableArray <SystemSceneModel *>* systemSceneListArray;
@property (nonatomic,strong) UIView *bottomview;
@end


@implementation HomeVC{
    BOOL flag;
    int _select_sid;
}


#pragma mark -life
-(void)viewDidLoad{

    _siter =  [[SiterwellReceiver alloc] init];
    _testobj = [[NSObject alloc] init];
    [_siter recv:_testobj callback:^(id obj, id data, NSError *error) {
        
    }];
    _siter.siterwelldelegate = self;
    


    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(test) image:@"setting_icon" highImage:@"setting_icon" withTintColor:[UIColor whiteColor]];


    UIColor* color = [UIColor whiteColor];
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes= dict;
    [self initLocation];
    

    [self modecirleView];
    
    NSArray * ds = @[@{@"devid":@"lbt_01",@"name":@"嘿嘿嘿"}];
    [self.videoView setVideoArray:ds];
    
    [self bottomview];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.bottomview addGestureRecognizer:recognizer];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottom:)];
    [self.bottomview addGestureRecognizer:tap];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    //设置透明标题栏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnswerOK) name:@"answer_ok" object:nil];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel * gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    NSMutableArray <ItemData *> *dsa = [[DBDeviceManager sharedInstanced] queryAllTHCheck:currentgateway2];
    self.weather_marquee.tempAndHumArray=dsa;
    if(gateway == nil){
        [[self titlbtn] setTitle:@"" forState:UIControlStateNormal];
    }else{
        [[self titlbtn] setTitle:[NSString stringWithFormat:@"%@(%@)",([gateway.deviceName isEqualToString:@"报警器"]?NSLocalizedString(@"我的家", nil):gateway.deviceName),[gateway.online isEqualToString:@"1"]?NSLocalizedString(@"在线", nil):NSLocalizedString(@"离线", nil)]   forState:UIControlStateNormal];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    GatewayModel * gateway = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    if([NSString isBlankString:currentgateway2]){
        _systemSceneListArray = [[NSMutableArray alloc] init];
    }else{
       _systemSceneListArray = [[DBSystemSceneManager sharedInstanced] queryAllSystemScene:currentgateway2];
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
    
    WS(ws)
    _menuVc.closedCircleMenu = ^{
        ws.menuVc.view.hidden = YES;
    };
    _menuVc.clickedMenu = ^(NSInteger tag) {

        ws.menuVc.view.hidden = YES;
        SystemSceneModel *ads = [ws.systemSceneListArray objectAtIndex:(tag-1)];
        _select_sid = [ads.sence_group intValue];
        [Single sharedInstanced].command = ChooseSystemScene_Home;
        ChooseSystemSceneApi *api = [[ChooseSystemSceneApi alloc] initWithDevTid:gateway.devTid CtrlKey:gateway.ctrlKey Domain:gateway.connectHost SceneGroup:ads.sence_group];
        [api startWithObject:ws CompletionBlockWithSuccess:^(id data, NSError *error) {
            
        }];
    };
    [self getUserIonfo];
    [self refresh];
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


#pragma -mark lazy
-(UIView *)bottomview{
    if(_bottomview==nil){
        _bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 31)];
        [self.view addSubview:_bottomview];
        [_bottomview makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(31);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        }];
        
        UIImageView *imagebg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbgjblue_bg"]];
        [_bottomview addSubview:imagebg];
        [imagebg makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"设备告警", nil);
        label.font = SYSTEMFONT(14);
        label.textColor = [UIColor whiteColor];
        [_bottomview addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(0);
        }];
        
        UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tj01_icon"]];
        [_bottomview addSubview:image1];
        [image1 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left).offset(-5);
            make.centerY.equalTo(0);
        }];
        
        UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow01_icon"]];
        [_bottomview addSubview:image2];
        [image2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(5);
            make.centerY.equalTo(0);
        }];
    }
    return _bottomview;
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
    SettingController *wl = [[SettingController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wl];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)showCircleMenu{
    _menuVc.view.hidden = NO;
    [_menuVc open];
}

-(void) AnswerOK{
    if([Single sharedInstanced].command == ChooseSystemScene_Home){
        [Single sharedInstanced].command = -1;
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
        [[DBSystemSceneManager sharedInstanced] updateSystemChoicewithSid:[NSNumber numberWithInteger:_select_sid] withDevTid:gatewaymodel.devTid];
        [self refresh];
    }
    
}

-(void)refresh{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    SystemSceneModel *currentsystem = [[DBSystemSceneManager sharedInstanced] queryCurrentSystemScene2:currentgateway2];
  
    if(currentsystem!=nil){
          [[self modecirleView] setLabel:currentsystem];
        if([currentsystem.sence_group intValue] == 0){
            [[self modecirleView] setText:NSLocalizedString(@"在家", nil)];
        }else if([currentsystem.sence_group intValue] == 1){
            [[self modecirleView] setText:NSLocalizedString(@"离家", nil)];
        }else if([currentsystem.sence_group intValue] == 2){
            [[self modecirleView] setText:NSLocalizedString(@"睡眠", nil)];
        }else{
            [[self modecirleView] setText:currentsystem.systemname];
        }
    }
  
}

-(void)selectGateWays{
    GatewayListVC *wl = [[GatewayListVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wl];
    [self presentViewController:nav animated:YES completion:nil];
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
    
    if([devicemodel.device_name isEqualToString:@"STATUES"]){
        
    }else if([devicemodel.device_name isEqualToString:@"DEL"]){
        [[DBDeviceManager sharedInstanced] deleteDevice:devicemodel.device_ID withDevTid:devTid];
    }
    else{
        [devicemodel setDevTid:devTid];
        [[DBDeviceManager sharedInstanced] insertDevice:devicemodel];
        NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
        NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
        if([currentgateway2 isEqualToString:devTid]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceSuccess" object:nil];
        }
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

-(void)onTimerSwitch:(TimerModel *)time withDevTid:(NSString *)devTid{
    if([time.time isEqualToString:@"TIMER_OVER"]){
       [[NSNotificationCenter defaultCenter] postNotificationName:@"timerover" object:nil];
    }else if([time.time containsString:@"DEL"]){
        int timerId =(int)strtoul([[time.time substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
        [[DBTimerManager sharedInstanced] deleteTimer:[NSNumber numberWithInt:timerId] withDevTid:devTid];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshtimer" object:nil];
    }else {
        [time setDevTid:devTid];
        [[DBTimerManager sharedInstanced] insertTimer:time];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshtimer" object:nil];
    }
}

-(void)onDeviceName:(NSString *)device_name withDevTid:(NSString *)devTid{
    
    if([device_name isEqualToString:@"NAME_OVER"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceNameOver" object:nil];
    }else{
        if (device_name.length == 36) {
            NSString *device_id = [NSString stringWithFormat:@"%lu",strtoul([[device_name substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16)];
            NSString *name = [device_name substringWithRange:NSMakeRange(4, 32)];
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            NSData *data = [BatterHelp hexStringToData:name];
            NSString *result = [[NSString alloc] initWithData:data encoding:enc];
            result = [result stringByReplacingOccurrencesOfString:@"@" withString:@""];
            result = [result stringByReplacingOccurrencesOfString:@"$" withString:@""];
            
        }
    }

}

#pragma -mark method
- (void)getUserIonfo{
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile", https]
      parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
          [config setValue:responseObject forKey:UserInfos];
          [config synchronize];
          
          NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];

          if (extraPropertiesDic[@"monitor"] !=nil) {

              NSMutableArray *monitor = [(NSArray*)[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];

              for (int i = 0; i < [monitor count]; i++) {

                  if (![[monitor objectAtIndex:i][@"devid"] isEqualToString:@"lbt_01"]&&[monitor objectAtIndex:i][@"devid"]!=nil) {

                      NSDictionary *videoDic = (NSDictionary *)monitor[i];
                      VideoModel *vInfo = [[VideoModel alloc] init];
                      vInfo.devid = videoDic[@"devid"];
                      vInfo.name = videoDic[@"name"];
                      [[DBVideoManager sharedInstanced] insertVideo:vInfo];
                  }
              }

              if (monitor != nil&&[monitor count] > 0) {
                  _videoView.videoArray = monitor;
              }else{
                  _videoView.videoArray = @[@{@"devid":@"lbt_01",@"name":NSLocalizedString(@"无视频，点击添加", nil)}];
              }

          }else{
              _videoView.videoArray = @[@{@"devid":@"lbt_01",@"name":NSLocalizedString(@"无视频，点击添加", nil)}];
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"%@",error.domain);
      }];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    WarningListViewController *wl = [[WarningListViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wl];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 点击底部的蓝条
 */
-(void)tapBottom:(UITapGestureRecognizer *)sender{
    //弹动一下
    BOOL animated = [self.bottomview.layer pop_animationKeys] > 0;
    if (!animated) {
        POPDecayAnimation *scollerTop = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        scollerTop.velocity = @(-30);
        [_bottomview.layer pop_addAnimation:scollerTop forKey:@"scollerTop"];
        
        WS(ws)
        scollerTop.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            POPSpringAnimation *dropAnamation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
            dropAnamation.toValue = @(0);
            dropAnamation.springBounciness = 20;
            [ws.bottomview.layer pop_addAnimation:dropAnamation forKey:@"dropAnamation"];
        };
    }
}
@end
