//
//  AppDelegate.m
//  mytest4
//
//  Created by iMac on 2018/2/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "AppDelegate.h"
#import "GeTuiSdk.h"
#import "HekrAPI.h"
#import "NSBundle+Language.h"
#import <HekrSimpleTcpClient.h>
#import "InitController.h"
// iOS10 及以上需导入 UserNotifications.framework

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<GeTuiSdkDelegate, UNUserNotificationCenterDelegate>


@property (nonatomic) HekrSimpleTcpClient *tcpClient;

@end

@implementation AppDelegate

#pragma mark - life
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    [NSBundle setLanguage:lan];
    
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"]];
    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    [[Hekr sharedInstance] config:config startPage:nil launchOptions:launchOptions];
    [[Hekr sharedInstance] firstPage];
    
    // Override point for customization after application launch.
    [self configureBoardManager];
    
    // Standard lumberjack initialization
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    self.window.backgroundColor=[UIColor whiteColor];
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    [self registerRemoteNotification];
    

    self.tcpClient = [[HekrSimpleTcpClient alloc] init];
    [self.tcpClient createTcpSocket:@"info.hekr.me" onPort:91 connect:^(HekrSimpleTcpClient *client ,BOOL isConnect) {
        if (isConnect) {
            [client writeDict:@{@"action":@"getAppDomain"}];
        }else{
            //            NSLog(@"get domain error:TCP连接不成功");
                NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
           NSString *ds =  [config objectForKey:@"domain"];
            if(ds==nil || ds.length ==0){
                //        自己本地保存domain的参数
                [[NSUserDefaults standardUserDefaults] setObject:@"hekr.me" forKey:@"hekr_domain"];
                
                ApiMap = @{@"user-openapi.hekr.me":[@"https://user-openapi." stringByAppendingString:@"hekr.me"],
                           @"uaa-openapi.hekr.me":[@"https://uaa-openapi." stringByAppendingString:@"hekr.me"],
                           @"console-openapi.hekr.me":[@"https://console-openapi." stringByAppendingString:@"hekr.me"]};
                
              [[NSUserDefaults standardUserDefaults] setObject:@"hekr.me" forKey:@"hekr_domain"];
            }else{
                ApiMap = @{@"user-openapi.hekr.me":[@"https://user-openapi." stringByAppendingString:ds],
                           @"uaa-openapi.hekr.me":[@"https://uaa-openapi." stringByAppendingString:ds],
                           @"console-openapi.hekr.me":[@"https://console-openapi." stringByAppendingString:ds]};
            }
        }
    } successCallback:^(HekrSimpleTcpClient *client, NSDictionary *data) {
        NSString* domain = [[data objectForKey:@"dcInfo"] objectForKey:@"domain"];
        //        自己本地保存domain的参数
        [[NSUserDefaults standardUserDefaults] setObject:domain forKey:@"hekr_domain"];
        
        ApiMap = @{@"user-openapi.hekr.me":[@"https://user-openapi." stringByAppendingString:domain],
                   @"uaa-openapi.hekr.me":[@"https://uaa-openapi." stringByAppendingString:domain],
                   @"console-openapi.hekr.me":[@"https://console-openapi." stringByAppendingString:domain]};
    }];
    
    
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString *username = [config2 objectForKey:@"UserName"];
    
    if(![NSString isBlankString:username]){
        InitController *newViewController = [[InitController alloc] init];
        newViewController.flag_login = YES;
        self.window.rootViewController = newViewController;
        
    }

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [[Hekr sharedInstance] didRegisterUserNotificationSettings:notificationSettings];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[Hekr sharedInstance] didReceiveRemoteNotification:userInfo];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[Hekr sharedInstance] openURL:url sourceApplication:sourceApplication annotation:annotation];
}


#pragma mark 键盘收回管理
-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField = 60;
    manager.enableAutoToolbar = NO;
}

#pragma mark - getui

-(void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:nil];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"嘿嘿嘿", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setObject:clientId forKey:AppClientID];
    [config synchronize];
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}
@end
