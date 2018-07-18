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
#import <CoreLocation/CoreLocation.h>
@interface HomeVC()<CLLocationManagerDelegate,HomeHeadViewDelegate>
@property (nonatomic) CLLocationManager *locationMgr;
@property (nonatomic,strong) CYMarquee *weather_marquee;
@property (nonatomic,strong) ModeCircleView *modecirleView;
@property (nonatomic,strong) CircleMenuVc *menuVc;
@property (nonatomic,strong) HomeHeadView *videoView;
@end


@implementation HomeVC{
    BOOL flag;
    NSMutableArray <SystemSceneModel *>* _systemSceneListArray;
}


#pragma mark -life
-(void)viewDidLoad{

    
    
    NewWeatherModel *model = [[NewWeatherModel alloc] init];
    model.weather = @"天晴";
    model.humidity = @"10";
    model.icon = @"s1";
    model.temp = @"283.16";
    
    NSString *address = @"宁波";
    self.weather_marquee.model = model;
    self.weather_marquee.address = address;
    
    NSMutableArray <ItemData *> *dsa = [[NSMutableArray alloc] init];
    
    for(int i=0;i<3;i++){
      ItemData * itemdata = [[ItemData alloc] initWithTitle:@"dsa" DevID:(i+1) DevType:@"0102" Code:@"04645501"];
        [dsa addObject:itemdata];
    }
    self.weather_marquee.tempAndHumArray=dsa;
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(test) image:@"setting_icon" highImage:@"setting_icon" withTintColor:[UIColor whiteColor]];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"我的家";
    UIColor* color = [UIColor whiteColor];
    
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes= dict;
    [self initLocation];
    

    [self modecirleView];
    
    NSArray * ds = @[@{@"devid":@"lbt_01",@"name":@"嘿嘿嘿"}];
    [self.videoView setVideoArray:ds];
    
    NSDictionary *dic2 = @{
                           @"action" : @"heartbeatResp",
                           };
    @weakify(self)
    [[Hekr sharedInstance] recv:dic2 obj:self callback:^(id obj, id data, NSError *error) {
        @strongify(self)
        if (!error) {
            NSLog(@"收到数据为%@",data);
        }
    }];
    
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
    SettingController * vc = [[SettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

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


@end
