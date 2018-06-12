//
//  VerifyCodeAlertView.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyCodeAlertView : UIView

@property (nonatomic) UITextField *captchaTF;

@property (nonatomic, copy) void(^clickCancelButton)();

@property (nonatomic, copy) void(^clickDetermineButton)();

//初始化方法
- (instancetype)initWithTarget:(id)target Title:(NSString *)title Content:(NSString *)content CancelButtonTitle:(NSString *)cancelTitle DetermineButtonTitle:(NSString *)determineTitle toView:(UIView *)view;

//弹出窗口
- (void)cy_alertShow;

- (void)cy_clickCancelButton:(void (^)())cancel determineButton:(void (^)())determine;

@end
