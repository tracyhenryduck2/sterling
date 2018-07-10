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
#import <CoreLocation/CoreLocation.h>
@interface HomeVC()<CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationMgr;
@property (nonatomic,strong) CYMarquee *weather_marquee;

@end


@implementation HomeVC


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
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:nil image:@"setting_icon" highImage:@"setting_icon" withTintColor:[UIColor whiteColor]];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"我的家";
    UIColor* color = [UIColor whiteColor];
    
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes= dict;
    [self initLocation];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//登录主界面
- (IBAction)ToDeviceList:(id)sender {
    
    DeviceListVC *devcelistvc = [[DeviceListVC alloc] init];
    [self.navigationController pushViewController:devcelistvc animated:YES];
}


#pragma mark -lazy

-(CYMarquee *)weather_marquee{
    if(!_weather_marquee){
        _weather_marquee = [[CYMarquee alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 260)];
        [self.view addSubview:_weather_marquee];
    }
    return _weather_marquee;
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

@end
