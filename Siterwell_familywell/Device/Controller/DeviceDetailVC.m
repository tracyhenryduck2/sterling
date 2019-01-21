//
//  DeviceDetailVC.m
//  sHome
//
//  Created by shaop on 2016/12/19.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "DeviceDetailVC.h"
#import "UINavigationBar+Awesome.h"
#import "POP.h"
#import "BaseNC.h"
#import "AddDeviceVC.h"
#import "LCActionSheet.h"
#import "BatterHelp.h"
#import "DBGatewayManager.h"
#import "DBDeviceManager.h"
#import "PostControllerApi.h"
#import "deleteDeviceApi.h"
#import "replaceDeviceApi.h"
#import "RenameVC.h"
#import "UserInfoModel.h"
#import "MyUdp.h"
#import "LEEAlert.h"
#import "Encryptools.h"
#import "TXScrollLabelView.h"
@interface DeviceDetailVC ()
@property (strong, nonatomic) UIView *borderView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *MainLabel;
@property (strong, nonatomic) UIView *centerLine;
@property (strong, nonatomic) UIButton *TestBtn;
@property (strong, nonatomic) UIButton *PhoneBtn;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UILabel *batteryLabel;
@property (strong, nonatomic) UISwitch *deviceSwitch;

@property (nonatomic) UIImageView *wifiImgV;
@property (nonatomic) UIImageView *batteryImgV;

@property (nonatomic) UITextField *textf;

//@property (nonatomic, assign) BOOL isShowTip;

@property (nonatomic) UISwitch *switch1;
@property (nonatomic) UISwitch *switch2;
@property (nonatomic) TXScrollLabelView *titleLabel2;

@property (nonatomic,strong) UIView *bottomview;
@property (nonatomic,strong) GatewayModel *gatewaymodel;
@end

@implementation DeviceDetailVC
{
    CGPoint _bottomPoint;
    CGPoint _beginPoint;

}
- (void)viewDidLoad {
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    _gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    [super viewDidLoad];
    [self bgImageView];
    [self bottomview];
    [self centerLine];
    [self MainLabel];
    [self deviceSwitch];
    [self TestBtn];
    [self PhoneBtn];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.bottomview addGestureRecognizer:recognizer];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottom:)];
    [self.bottomview addGestureRecognizer:tap];
    _switch1 = [[UISwitch alloc] init];
    _switch1.tag = 11;
    _switch1.hidden = YES;
    _switch1.onTintColor = RGB(5, 128, 255);
    [self.view addSubview:_switch1];
    [_switch1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.borderView.mas_bottom).offset(44);
    }];
    [_switch1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    _switch2 = [[UISwitch alloc] init];
    _switch2.tag = 22;
    _switch2.hidden = YES;
    _switch2.onTintColor = RGB(5, 128, 255);
    [self.view addSubview:_switch2];
    [_switch2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.switch1.mas_bottom).offset(44);
    }];
    [_switch2 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData) name:@"updateDeviceSuccess" object:nil];
    
    self.navigationController.navigationBar.alpha = 1;
    
    
    if([NSString isBlankString:_data.customTitle]){
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        NSDictionary* names = [dic valueForKey:@"names"];
         [self titleLabel2].scrollTitle = [NSString stringWithFormat:@"%@%@",NSLocalizedString([names objectForKey:_data.device_name], nil) ,[NSString stringWithFormat:@"%@",_data.device_ID]];
    }else{
        [self titleLabel2].scrollTitle = _data.customTitle;
    }
    if([self titleLabel2].upLabel.frame.size.width <=200){
        [[self titleLabel2] endScrolling];
    }else{
        [[self titleLabel2] beginScrolling];
    }

    
    [self setDevice];
    
    [self setPageBackground];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"管理",nil) withTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(goBack) image:@"back_white_icon" highImage:nil withTintColor:[UIColor whiteColor]];
    [self analysisStatus];
//    [self currentDevice];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.isShowTip = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAnswerOK) name:@"answer_ok" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    //移除观察者 self
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 管理按钮点击
 */
-(void)clickItem{
    deleteDeviceApi *deleteApi = [[deleteDeviceApi alloc] initWithDevTid:_gatewaymodel.devTid CtrlKey:_gatewaymodel.ctrlKey mDeviceID:[self.data.device_ID integerValue] ConnectHost:_gatewaymodel.connectHost];
    replaceDeviceApi *replaceApi = [[replaceDeviceApi alloc] initWithDevTid:_gatewaymodel.devTid CtrlKey:_gatewaymodel.ctrlKey mDeviceID:self.data.device_ID ConnectHost:_gatewaymodel.connectHost];
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        WS(ws)

        if (buttonIndex == 2) {
       
        }else if (buttonIndex == 1){


        }else if(buttonIndex == 3){

        }else{
            
        }

    } otherButtonTitles:NSLocalizedString(@"替换设备",nil),NSLocalizedString(@"删除设备",nil),NSLocalizedString(@"重命名",nil), nil];
    actionSheet.buttonFont = [UIFont systemFontOfSize:14];
    actionSheet.buttonHeight = 44.0f;
    actionSheet.buttonColor = RGB(36, 155, 255);
    actionSheet.unBlur = YES;
    [actionSheet show];
}

-(void)deleteDevice{
    [[DBDeviceManager sharedInstanced] deleteDevice:_data.device_ID withDevTid:_data.devTid];
    [MBProgressHUD showSuccess:NSLocalizedString(@"删除成功",nil) ToView:self.view];
}

///**
// 实时更新设备
// */
//- (void)currentDevice{
//    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//    DeviceListModel *_model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
//    NSDictionary *dic = @{@"action" : @"devSend",
//                          @"params" : @{
//                                  @"devTid" : _model.devTid,
//                                  @"data" : @{
//                                          @"cmdId" : @19,
//                                          @"device_ID" : @([self.data.devID intValue])
//                                          }
//                                  }
//                          };
//
//    NSDictionary *dic2 = @{@"action" : @"devSend",
//                          @"params" : @{
//                                  @"devTid" : _model.devTid,
//                                  @"data" : @{
//                                          @"cmdId" : @119,
//                                          @"device_ID" : @([self.data.devID intValue])
//                                          }
//                                  }
//                          };
//    WS(ws)
//    if (![[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
//        [[Hekr sharedInstance] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
//            if (!error) {
//                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
//                ws.data = [DeviceMapHelp ItemWithDeivce:model];
//                [ws analysisStatus];
//                [ws tarnslateBackgroundImageView];
////                if (self.isShowTip == YES) {
////                    [self showOpenDoorStatusWith:data];
////                }
//            }
//        }];
//
//        [[Hekr sharedInstance] recv:dic2 obj:self callback:^(id obj, id data, NSError *error) {
//            if (!error) {
//                NSNumber *msgId=data[@"msgId"];
//                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
//                int newa = [Encryptools getDescryption:model.device_ID withMsgId:[msgId intValue]];
//                [model setDevice_ID:newa];
//                ws.data = [DeviceMapHelp ItemWithDeivce:model];
//                [ws analysisStatus];
//                [ws tarnslateBackgroundImageView];
//                //                if (self.isShowTip == YES) {
//                //                    [self showOpenDoorStatusWith:data];
//                //                }
//            }
//        }];
//    }
//    else{
//        [[MyUdp shared] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
//            if (!error) {
//                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
//                ws.data = [DeviceMapHelp ItemWithDeivce:model];
//                [ws analysisStatus];
//                [ws tarnslateBackgroundImageView];
////                if (self.isShowTip == YES) {
////                    [self showOpenDoorStatusWith:data];
////                }
//            }
//        }];
//
//        [[MyUdp shared] recv:dic2 obj:self callback:^(id obj, id data, NSError *error) {
//            if (!error) {
//                NSNumber *msgId=data[@"msgId"];
//                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
//                int newa = [Encryptools getDescryption:model.device_ID withMsgId:[msgId intValue]];
//                [model setDevice_ID:newa];
//                ws.data = [DeviceMapHelp ItemWithDeivce:model];
//                [ws analysisStatus];
//                [ws tarnslateBackgroundImageView];
//                //                if (self.isShowTip == YES) {
//                //                    [self showOpenDoorStatusWith:data];
//                //                }
//            }
//        }];
//
//    }
//}

/**
 设置各类页面的信息
 */
-(void)setDevice{
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    NSDictionary * _names = [dic valueForKey:@"names"];
    NSString * devicename = [_names objectForKey:self.data.device_name];
    
    if ([self.data.image hasPrefix:@"no"]) {
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:YES];
        
        if([devicename isEqualToString:@"智能插座"]){
            [_deviceSwitch setHidden:NO];
        } else if ([devicename isEqualToString:@"双路开关"]) {
            //
        }
    }
    
    if([devicename isEqualToString:@"水感报警器"]||
       [devicename isEqualToString:@"SM报警器"]||
       [devicename isEqualToString:@"CO报警器"]||
       [devicename isEqualToString:@"复合型烟感"] ||
       [devicename isEqualToString:@"热感报警器"]){
        //报警类设备显示测试、电话按钮
        [_deviceSwitch setHidden:YES];

        if(self.data!=nil && ([self.data.device_name containsString:@"008"] || [self.data.device_name containsString:@"009"] || [self.data.device_name containsString:@"00A"] || [self.data.device_name containsString:@"00B"] || [self.data.device_name containsString:@"00C"]
                        || [self.data.device_name containsString:@"00D"] )){
               [_TestBtn setHidden:YES];
        }else{
        [_TestBtn setHidden:NO];
        }
     
        
    }else if([devicename isEqualToString:@"智能插座"]){
        //插座类只显示开关
        [_TestBtn setHidden:YES];
        [_PhoneBtn setHidden:YES];
        
        if (self.data.device_status.length >= 8) {
            if ([[self.data.device_status substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"FF"]||[[self.data.device_status substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"]) {
                [_deviceSwitch setOn:YES];
            }else{
                [_deviceSwitch setOn:NO];
            }
        }
    }
    else if([devicename isEqualToString:@"PIR探测器"] ||
            [devicename isEqualToString:@"门磁"] ||
            [devicename isEqualToString:@"SOS按钮"] ||
            [devicename isEqualToString:@"按键"]) {
        //探测器显示紧急电话
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:YES];

    }
    else if ([devicename isEqualToString:@"温湿度探测器"]) {
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:NO];
        [self.PhoneBtn setHidden:NO];
        
        NSString *temp = [self.data.device_status substringWithRange:NSMakeRange(4, 2)];
        NSString *one = [BatterHelp getBinaryByhex:temp];
        one = one.length < 8 ? [@"0000" stringByAppendingString:one] : one;
        one = [one substringWithRange:NSMakeRange(0, 1)];
        NSNumber *tempNum = [BatterHelp numberHexString:temp];
        
        NSString *hum = [self.data.device_status substringWithRange:NSMakeRange(6, 2)];
        NSNumber *humNum = [BatterHelp numberHexString:hum];
        if ([one isEqualToString:@"1"]) {
            int ttemp = [tempNum intValue] - 256;
            
            [_TestBtn setTitle:[NSString stringWithFormat:@"T:%d", ttemp] forState:UIControlStateNormal];
        } else {
            [_TestBtn setTitle:[NSString stringWithFormat:@"T:%@", [tempNum stringValue]] forState:UIControlStateNormal];
        }
        
        [self.PhoneBtn setTitle:[NSString stringWithFormat:@"H:%@", [humNum stringValue]] forState:UIControlStateNormal];
        
        _TestBtn.userInteractionEnabled = NO;
        self.PhoneBtn.userInteractionEnabled = NO;
    }
    else if ([devicename isEqualToString:@"门锁"]) {
        [_deviceSwitch setHidden:YES];
        [_PhoneBtn setHidden:NO];
        [_TestBtn setHidden:NO];
        [_TestBtn setTitle:NSLocalizedString(@"开锁", nil) forState:UIControlStateNormal];
    }
    else if ([devicename isEqualToString:@"气体探测器"]) {
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:NO];
        [self.PhoneBtn setHidden:NO];
    }
    else if ([devicename isEqualToString:@"双路开关"]) {
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:YES];
        [self.PhoneBtn setHidden:YES];
        [self.switch1 setHidden:NO];
        [self.switch2 setHidden:NO];
    }
}


/**
 动态改变背景图片
 */
-(void)tarnslateBackgroundImageView{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.bgImageView.layer addAnimation:transition forKey:nil];
    [self setPageBackground];

}

/**
 设备背景图片
 */
-(void)setPageBackground{
    NSString * desc = @"";
    if(self.data.device_status.length==8){
       desc = [self.data.device_status substringWithRange:NSMakeRange(4, 2)];
    }
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    NSDictionary * _names = [dic valueForKey:@"names"];
    NSString * devicename = [_names objectForKey:self.data.device_name];
    
    if ([_data.image hasPrefix:@"aq"]) {
        [_bgImageView setImage:[UIImage imageNamed:@"sbgreen_bg"]];
        if ([devicename isEqualToString:@"智能插座"]) {
            _MainLabel.text = NSLocalizedString(@"插座关",nil);
            [_deviceSwitch setOn:NO animated:YES];
        }
        else if ([devicename isEqualToString:@"门锁"]) {
            if ([desc isEqualToString:@"AA"] || [desc isEqualToString:@"60"] ) {
                _MainLabel.text = NSLocalizedString(@"正常",nil);
            } else if ([desc isEqualToString:@"AB"]) {
                _MainLabel.text = NSLocalizedString(@"已激活",nil);
            } else if ([desc isEqualToString:@"55"]) {
                _MainLabel.text = NSLocalizedString(@"远程密码开锁成功", nil);
                _MainLabel.textColor = RGB(245, 52, 35);
                _centerLine.backgroundColor = RGB(245, 52, 35);
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                return;
            } else if ([desc isEqualToString:@"56"]) {
                _MainLabel.text = NSLocalizedString(@"密码错误", nil);
                _MainLabel.textColor = RGB(245, 52, 35);
                _centerLine.backgroundColor = RGB(245, 52, 35);
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                return;
            }
            
        }
        else if ([devicename isEqualToString:@"双路开关"]) {
            NSString *switchStatus = [_data.device_status substringWithRange:NSMakeRange(6, 2)];
            if ([switchStatus isEqualToString:@"00"]) {
                [_switch1 setOn:NO animated:YES];
                [_switch2 setOn:NO animated:YES];
                [_bgImageView setImage:[UIImage imageNamed:@"sbgreen_bg"]];
                NSString *statusString = @"通道1关\n通道2关";
                [_MainLabel setTextColor:RGB(0, 191, 102)];
                [_MainLabel setText:statusString];
            }
        }
//        else if ([_data.title isEqualToString:@"门锁"]) {
//            if ([_data.desc isEqualToString:@"55"]) {
//                _MainLabel.text = NSLocalizedString(@"远程密码开锁成功", nil);
//            } else if ([_data.desc isEqualToString:@"56"]) {
//                _MainLabel.text = NSLocalizedString(@"密码错误", nil);
//            }
//            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
//            return;
//        }
        else{
            _MainLabel.text = NSLocalizedString(@"正常",nil);
        }
        _MainLabel.textColor = RGB(0, 191, 102);
        _centerLine.backgroundColor = RGB(0, 191, 102);
    }
    else if ([_data.image hasPrefix:@"gz"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];
        if ([devicename isEqualToString:@"温湿度探测器"] || [devicename isEqualToString:@"门锁"]) {
            _MainLabel.text = NSLocalizedString(@"低电压",nil);
        } else {
            _MainLabel.text = NSLocalizedString(@"故障",nil);
        }
        _MainLabel.textColor = RGB(255, 179, 0);
        _centerLine.backgroundColor = RGB(255, 179, 0);
        
    }
    else if ([_data.image hasPrefix:@"bj"]){
        
        if ([devicename isEqualToString:@"智能插座"]) {
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
            _MainLabel.text = NSLocalizedString(@"插座开",nil);
            [_deviceSwitch setOn:YES animated:YES];
        }
        else if([devicename isEqualToString:@"门磁"]){
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
            _MainLabel.text = NSLocalizedString(@"门打开",nil);
        }
        else if ([devicename isEqualToString:@"复合型烟感"]) {
            if ([desc isEqualToString:@"17"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
                _MainLabel.text = NSLocalizedString(@"测试报警", nil);
            } else if ([desc isEqualToString:@"12"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];//
                _MainLabel.text = NSLocalizedString(@"故障", nil);
            } else if ([desc isEqualToString:@"15"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];//
                _MainLabel.text = NSLocalizedString(@"免打扰", nil);
            }else if ([desc isEqualToString:@"19"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
                _MainLabel.text = NSLocalizedString(@"火灾报警", nil);
            } else if ([desc isEqualToString:@"1B"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
                _MainLabel.text = NSLocalizedString(@"静音", nil);
            }
        }
        else if ([devicename isEqualToString:@"门锁"]) {
            if ([desc isEqualToString:@"10"]) {
                _MainLabel.text = NSLocalizedString(@"非法操作", nil);
            } else if ([desc isEqualToString:@"20"]) {
                _MainLabel.text = NSLocalizedString(@"强拆", nil);
            } else if ([desc isEqualToString:@"30"]) {
                _MainLabel.text = NSLocalizedString(@"胁迫", nil);
            } else if ([desc isEqualToString:@"51"]) {
                _MainLabel.text = NSLocalizedString(@"密码开锁", nil);
            } else if ([desc isEqualToString:@"52"]) {
                _MainLabel.text = NSLocalizedString(@"卡开锁", nil);
            } else if ([desc isEqualToString:@"53"]) {
                _MainLabel.text = NSLocalizedString(@"指纹开锁", nil);
            }
            
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
        }
        else if ([devicename isEqualToString:@"双路开关"]) {
            NSString *switchStatus = [_data.device_status substringWithRange:NSMakeRange(6, 2)];
            if ([switchStatus isEqualToString:@"01"]) {
                [_switch1 setOn:YES animated:YES];
                [_switch2 setOn:NO animated:YES];
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"通道1开\n通道2关"];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(245, 52, 35) range:NSMakeRange(0, 4)];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(0, 191, 102) range:NSMakeRange(5, 4)];
                [_MainLabel setAttributedText:statusString];
            } else if ([switchStatus isEqualToString:@"02"]) {
                [_switch1 setOn:NO animated:YES];
                [_switch2 setOn:YES animated:YES];
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"通道1关\n通道2开"];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(0, 191, 102) range:NSMakeRange(0, 4)];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(245, 52, 35) range:NSMakeRange(5, 4)];
                [_MainLabel setAttributedText:statusString];
            } else if ([switchStatus isEqualToString:@"03"]) {
                [_switch1 setOn:YES animated:YES];
                [_switch2 setOn:YES animated:YES];
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                NSString *statusString = @"通道1开\n通道2开";
                [_MainLabel setText:statusString];
                [_MainLabel setTextColor:RGB(245, 52, 35)];
            }
        }
        else{
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
            _MainLabel.text = NSLocalizedString(@"报警",nil);
        }
        if (![devicename isEqualToString:@"双路开关"]) {
            _MainLabel.textColor = RGB(245, 52, 35);
        }
        _centerLine.backgroundColor = RGB(245, 52, 35);
    }
    else if ([_data.image hasPrefix:@"no"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sbgray_bg"]];
        _MainLabel.text = NSLocalizedString(@"离线",nil);
        _MainLabel.textColor = RGB(192, 203, 223);
        _centerLine.backgroundColor = RGB(192, 203, 223);
    }
}

/**
 显示设备状态
 */
- (void)analysisStatus{
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    NSDictionary * _names = [dic valueForKey:@"names"];
    NSString * devicename = [_names objectForKey:self.data.device_name];
    
    if (![self.data.image hasPrefix:@"no"]) {
        
        NSString *signal = [_data.device_status substringWithRange:NSMakeRange(0, 2)];
        if ([signal isEqualToString:@"04"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi04"]];
        }
        else if ([signal isEqualToString:@"03"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi03"]];
        }
        else if ([signal isEqualToString:@"02"]){
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi02"]];
        }
        else if ([signal isEqualToString:@"01"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        }
        else{
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        }
        
        NSString *battery = [_data.device_status substringWithRange:NSMakeRange(2, 2)];
        if (![devicename containsString:@"插座"] && ![devicename containsString:@"双路开关"]) {
            if ([battery isEqualToString:@"FF"]) {
            }
            else if ([battery isEqualToString:@"80"]){
                self.batteryLabel.text = @"0%";
            }
            else if ([battery isEqualToString:@"64"]){
                self.batteryLabel.text = @"100%";
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg100_icon"]];
                
            }else{
                self.batteryLabel.text = [NSString stringWithFormat:@"%@%%",[BatterHelp getBatterFormDevice:battery]];
                if ([[BatterHelp getBatterFormDevice:battery] intValue]<100 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 80) {
                    [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg80_icon"]];
                } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<80 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 60) {
                    [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg60_icon"]];
                } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<60 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 40) {
                    [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg40_icon"]];
                } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<40) {
                    [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg40_icon"]];
                }
            }
        }
        
        NSString *switchStatus = [_data.device_status substringWithRange:NSMakeRange(6, 2)];
        if ([devicename containsString:@"插座"]) {
            if ([switchStatus isEqualToString:@"FF"] || [switchStatus isEqualToString:@"01"]) {
                [_deviceSwitch setOn:YES animated:YES];
            }else{
                [_deviceSwitch setOn:NO animated:YES];
            }
        }
        else if ([devicename containsString:@"双路开关"]) {
            if ([switchStatus isEqualToString:@"00"]) {
                [_switch1 setOn:NO animated:YES];
                [_switch2 setOn:NO animated:YES];
                NSString *statusString = @"通道1关\n通道2关";
                [_MainLabel setText:statusString];
            } else if ([switchStatus isEqualToString:@"01"]) {
                [_switch1 setOn:YES animated:YES];
                [_switch2 setOn:NO animated:YES];
                NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"通道1开\n通道2关"];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(245, 52, 35) range:NSMakeRange(0, 4)];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(0, 191, 102) range:NSMakeRange(5, 4)];
                [_MainLabel setAttributedText:statusString];
            } else if ([switchStatus isEqualToString:@"02"]) {
                [_switch1 setOn:NO animated:YES];
                [_switch2 setOn:YES animated:YES];
                NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"通道1关\n通道2开"];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(0, 191, 102) range:NSMakeRange(0, 4)];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(245, 52, 35) range:NSMakeRange(5, 4)];
                [_MainLabel setAttributedText:statusString];
            } else if ([switchStatus isEqualToString:@"03"]) {
                [_switch1 setOn:YES animated:YES];
                [_switch2 setOn:YES animated:YES];
                NSString *statusString = @"通道1开\n通道2开";
                [_MainLabel setText:statusString];
            }
        }
    }
    else{
        [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        _batteryLabel.text = NSLocalizedString(@"",nil);
    }
}

-(void)switchAction:(id)sender {
//    UISwitch *mswitch = sender;
//    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
//
//    if (!_isSwitching) {
//        PostControllerApi *api;
//        _isSwitching = YES;
//        [MBProgressHUD showLoadToView:GetWindow];
//        __block NSObject *obj = [[NSObject alloc] init];
//
//        if (mswitch.tag == 11) {
//            if (!mswitch.isOn) {
//                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"01000000"];
//            } else if (mswitch.isOn) {
//                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"01010000"];
//            }
//        }
//        else if (mswitch.tag == 22) {
//            if (!mswitch.isOn) {
//                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"02000000"];
//            } else if (mswitch.isOn) {
//                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"02020000"];
//            }
//        }
//        else {
//            if ([mswitch isOn]) {
//                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"0101"];
//            }else{
//                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"0100"];
//            }
//        }
//
//        [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
//            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//            _isSwitching = NO;
//            [obj class];
//            obj = nil;
//        } failure:^(id data, NSError *error) {
//            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//            _isSwitching = NO;
//            [mswitch setOn:!mswitch.isOn animated:YES];
//            [obj class];
//            obj = nil;
//        }];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (_isSwitching) {
//                [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//                _isSwitching = NO;
//                [mswitch setOn:!mswitch.isOn animated:YES];
//                obj = nil;
//            }
//        });
//    }
}

- (void)testAction:(id)sender {
//    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
//    NSDictionary * _names = [dic valueForKey:@"names"];
//    NSString * devicename = [_names objectForKey:self.data.device_name];
//
//    if ([devicename isEqualToString:@"复合型烟感"]) {
//        PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"17000000"];
//        [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
//    }
//    else if ([devicename isEqualToString:@"按键"]) {
//        PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"00000100"];
//        [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
//    }
//    else if ([devicename isEqualToString:@"门锁"]) {
//        UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rememberBtn setTitle:NSLocalizedString(@"记住密码", nil) forState:UIControlStateNormal];
//        rememberBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
//        [rememberBtn setImage:[UIImage imageNamed:@"jzmm_noselect"] forState:UIControlStateNormal];
//        [rememberBtn setImage:[UIImage imageNamed:@"jzmm_select"] forState:UIControlStateSelected];
//        [rememberBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [rememberBtn setTitleColor:RGB(57, 166, 240) forState:UIControlStateNormal];
//        [rememberBtn setFrame:CGRectMake(0, 0, 150, 20)];
//        NSString *suoPsd = [[NSUserDefaults standardUserDefaults] objectForKey:@"suoPsd"];
//        if (suoPsd && suoPsd.length != 0) {
//            [rememberBtn setSelected:YES];
//        } else {
//            [rememberBtn setSelected:NO];
//        }
//        [rememberBtn addTarget:self action:@selector(rememberPassword:) forControlEvents:UIControlEventTouchUpInside];
//
//        UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [eyeBtn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
//        [eyeBtn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateSelected];
//        [eyeBtn setFrame:CGRectMake(0, 0, 20, 15)];
//        [eyeBtn addTarget:self action:@selector(lookPsd:) forControlEvents:UIControlEventTouchUpInside];
////        self.isShowTip = NO;
//
//        [LEEAlert alert].config
//        .LeeAddTitle(^(UILabel *label) {
//            label.text = NSLocalizedString(@"请输入开锁密码", nil);
//            label.textColor = RGB(57, 166, 240);
//            label.font = [UIFont systemFontOfSize:15];
//        })
//        .LeeAddTextField(^(UITextField *textField) {
//            textField.placeholder = NSLocalizedString(@"请输入开锁密码", nil);
//            textField.borderStyle = UITextBorderStyleNone;
//            textField.font = [UIFont systemFontOfSize:14];
//            textField.rightView = eyeBtn;
//            textField.secureTextEntry = YES;
//            textField.rightViewMode = UITextFieldViewModeAlways;
//            textField.text = suoPsd;
//            self.textf = textField;
//        })
//        .LeeAddCustomView(^(LEECustomView *custom) {
//            custom.positionType = LEECustomViewPositionTypeLeft;
//            custom.view = rememberBtn;
//        })
//        .LeeAddAction(^(LEEAction *action) {
//            action.type = LEEActionTypeCancel;
//            action.title = NSLocalizedString(@"取消", nil);
//            action.titleColor = [UIColor lightGrayColor];
//            action.font = [UIFont systemFontOfSize:14];
//        })
//        .LeeAddAction(^(LEEAction *action) {
//            action.type = LEEActionTypeDefault;
//            action.title = NSLocalizedString(@"确定", nil);
//            action.titleColor = RGB(57, 166, 240);
//            action.font = [UIFont systemFontOfSize:14];
//            __weak typeof(self) weakSelf = self;
//            action.clickBlock = ^{
//                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.textf.text forKey:@"suoPsd"];
//                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.device_ID intValue] DeviceStatus:[NSString stringWithFormat:@"%@00", weakSelf.textf.text]];
//                [api startWithObject:weakSelf CompletionBlockWithSuccess:^(id data, NSError *error) {
//                    NSLog(@"成功了啊");
//
//                } failure:^(id data, NSError *error) {
//                    NSLog(@"失败了啊");
//                }];
//            };
//        })
//        .LeeShow();
//
//    }
//    else{
//        PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"BB000000"];
//        [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
//    }
}

- (void)rememberPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)lookPsd:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.textf.secureTextEntry = !sender.selected;
}

- (void)phoneAction:(id)sender {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:[config objectForKey:UserInfos] error:nil];
    
    if ([NSString isBlankString:model.emergencyNumber]) {

        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.emergencyNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"未设置紧急号码",nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:nil];
        [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
}


- (void)lodaData{
    self.data = [[DBDeviceManager sharedInstanced] queryDeviceModel:self.data.device_ID withDevTid:_gatewaymodel.devTid];
    [self analysisStatus];
    [self tarnslateBackgroundImageView];
}



- (UIImageView *)wifiImgV {
    if (!_wifiImgV) {
        _wifiImgV = [[UIImageView alloc] init];
        [self.bgView addSubview:_wifiImgV];
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        NSDictionary * _names = [dic valueForKey:@"names"];
        NSString * devicename = [_names objectForKey:self.data.device_name];
        if ([devicename containsString:@"插座"]) {
            [_wifiImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(0);
                make.top.equalTo(_centerLine.mas_bottom).offset(15);
            }];
        } else {
            [_wifiImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_centerLine.mas_bottom).offset(15);
                make.centerX.equalTo(-44);
            }];
        }
        
    }
    return _wifiImgV;
}

- (UIImageView *)batteryImgV {
    if (!_batteryImgV) {
        _batteryImgV = [[UIImageView alloc] init];
        [self.bgView addSubview:_batteryImgV];
        [_batteryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(_centerLine.mas_bottom).offset(20);
        }];
    }
    return _batteryImgV;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc] init];
        [self.bgView addSubview:_batteryLabel];
        [_batteryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_centerLine.mas_bottom).offset(20);
            make.centerX.equalTo(44);
        }];
    }
    return _batteryLabel;
}

-(TXScrollLabelView *)titleLabel2{
    if(_titleLabel2 == nil){
        _titleLabel2 = [TXScrollLabelView scrollWithTitle:@"" type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
        /** Step4: 布局(Required) */
        _titleLabel2.frame = CGRectMake(30, 7, 200, 30);
        
        
        
        //偏好(Optional), Preference,if you want.
        _titleLabel2.tx_centerY = 22;
        _titleLabel2.userInteractionEnabled = NO;
        _titleLabel2.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
        _titleLabel2.scrollSpace = 10;
        _titleLabel2.font = [UIFont systemFontOfSize:15];
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
        _titleLabel2.scrollTitleColor = [UIColor whiteColor];
        _titleLabel2.backgroundColor = [UIColor clearColor];
        _titleLabel2.layer.cornerRadius = 5;
        self.navigationItem.titleView=_titleLabel2;
    }
    return _titleLabel2;
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
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        UIImageView *imagebg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbgjwhite_bg"]];
        [_bottomview addSubview:imagebg];
        [imagebg makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"设备告警", nil);
        label.font = SYSTEMFONT(14);
        [_bottomview addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(0);
        }];
        
        UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tj02_icon"]];
        [_bottomview addSubview:image1];
        [image1 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left).offset(-5);
            make.centerY.equalTo(0);
        }];

        UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow02_icon"]];
        [_bottomview addSubview:image2];
        [image2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(5);
            make.centerY.equalTo(0);
        }];
    }
    return _bottomview;
}

-(UIImageView *)bgImageView{
    if(_bgImageView==nil){
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        [_bgImageView setImage:[UIImage imageNamed:@"sbgreen_bg"]];
        [self.view addSubview:_bgImageView];
    }
    return _bgImageView;
}

-(UIView *)borderView{
    if(_borderView==nil){
        _borderView = [[UIView alloc] initWithFrame:CGRectZero];
        _borderView.layer.cornerRadius = 100.0f;
        _borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _borderView.layer.borderWidth = 1.0f;
        [self.view addSubview:_borderView];
        [_borderView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(200);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY).offset(-85);
        }];
        
    }
    return _borderView;
}

-(UIView *)bgView{
    if(_bgView==nil){
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.layer.cornerRadius = 90.0f;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.borderView addSubview:_bgView];
        [_bgView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(180);
            make.centerX.mas_equalTo(self.borderView.mas_centerX);
            make.centerY.mas_equalTo(self.borderView.mas_centerY);
        }];
    }
    return _bgView;
}

-(UIView *)centerLine{
    if(_centerLine==nil){
        _centerLine = [[UIView alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_centerLine];
        [_centerLine makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0.6);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-8);
            make.left.mas_equalTo(self.bgView.mas_left).offset(8);
            make.centerX.mas_equalTo(self.bgView.centerX);
            make.centerY.mas_equalTo(self.bgView.centerY);
        }];
    }
    return _centerLine;
}

-(UILabel *)MainLabel{
    if(_MainLabel==nil){
        _MainLabel = [[UILabel alloc] init];
        [self.bgView addSubview:_MainLabel];
        [_MainLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.centerY.mas_equalTo(self.bgView.mas_centerY).offset(-40);
        }];
    }
    return _MainLabel;
}

-(UISwitch *)deviceSwitch{
    if(_deviceSwitch==nil){
        _deviceSwitch = [[UISwitch alloc] init];
        _deviceSwitch.onTintColor = RGB(5, 128, 255);
        [self.view addSubview:_deviceSwitch];
        [_deviceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.view.centerY).offset(80);
        }];
        [_deviceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _deviceSwitch;
}

-(UIButton *)TestBtn{
    if(_TestBtn==nil){
        _TestBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _TestBtn.layer.cornerRadius = 22.0f;
        [self.view addSubview:_TestBtn];
        [_TestBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.bgView.mas_width);
            make.height.mas_equalTo(44);
            make.centerX.equalTo(0);
            make.centerY.mas_equalTo(self.view.mas_centerY).offset(120);
        }];
        [_TestBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _TestBtn;
}

-(UIButton *)PhoneBtn{
    if(_PhoneBtn==nil){
        _PhoneBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _PhoneBtn.layer.cornerRadius = 22.0f;
        [self.view addSubview:_PhoneBtn];
        [_PhoneBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.bgView.mas_width);
            make.height.mas_equalTo(44);
            make.centerX.equalTo(0);
            make.top.mas_equalTo(self.TestBtn.mas_bottom).offset(16.5);
        }];
        [_PhoneBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _TestBtn;
}


#pragma -mark method
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
//    DeviceWarningListViewController *wl = [[DeviceWarningListViewController alloc] init];
//    wl.dev_id = _data.devID;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wl];
//    [self presentViewController:nav animated:YES completion:nil];
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

-(void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onAnswerOK{
    
}
@end
