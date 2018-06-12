//
//  VerifyCodeAlertView.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "VerifyCodeAlertView.h"

@interface VerifyCodeAlertView ()

@end

@implementation VerifyCodeAlertView
{
    UIView   *_mainView;
    NSString *_title;
    NSString *_content;
    NSString *_cancelTitle;
    NSString *_determineTitle;
    UIWebView *imgWebView;
    id _target;
}

- (instancetype)initWithTarget:(id)target Title:(NSString *)title Content:(NSString *)content CancelButtonTitle:(NSString *)cancelTitle DetermineButtonTitle:(NSString *)determineTitle toView:(UIView *)view{
    if (self = [super init]) {
        _title = title;
        _content = content;
        _cancelTitle = cancelTitle;
        _determineTitle = determineTitle;
        _target = target;
        _mainView = view;
    }
    return self;
}

- (void)clickCancel{
    if (_clickCancelButton) {
        _clickCancelButton();
    }
    [self removeFromSuperview];
}

- (void)clickDetermine{
    if (_clickDetermineButton) {
        _clickDetermineButton();
    }
    [self removeFromSuperview];
}

- (void)cy_clickCancelButton:(void (^)())cancel determineButton:(void (^)())determine {
    _clickCancelButton = cancel;
    _clickDetermineButton = determine;
}

- (void)cy_alertShow {
    //背景
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.frame = _mainView.frame;
    [_mainView addSubview:self];
    
    //alert主体
    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 4.5;
    [self addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(-50);
        make.height.equalTo(200);
        make.width.equalTo(280);
        make.centerX.equalTo(0);
    }];
    
    //图形验证码
    imgWebView = [UIWebView new];
    [imgWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSString stringWithFormat:Hekr_getImage,ApiMap[@"uaa-openapi.hekr.me"],Hekr_rid].cy_URL]];
    [alertView addSubview:imgWebView];
    [imgWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(40);
        make.width.equalTo(160);
        make.top.equalTo(55);
        make.centerX.equalTo(0);
    }];
    
    UIButton *reBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [alertView addSubview:reBtn];
    [reBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.width.top.equalTo(imgWebView);
    }];
    [reBtn addTarget:self action:@selector(reLoadImgCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    //标题
    UILabel *titleLabel;
    if (_title) {
        titleLabel = [UILabel new];
        titleLabel.text = _title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = RGB(51, 51, 51);
        [alertView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(0);
            make.top.equalTo(17.5);
            make.left.equalTo(imgWebView);
        }];
    }
    
    //输入框
    UITextField *tf = [UITextField new];
    tf.keyboardType = UIKeyboardTypeASCIICapable;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.font = SYSTEMFONT(14);
    tf.placeholder = NSLocalizedString(@"请输入图形验证码", nil);
    tf.tintColor = ThemeColor;
    [alertView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.centerX.equalTo(imgWebView);
        make.top.equalTo(imgWebView.mas_bottom).offset(10);
    }];
    self.captchaTF = tf;
    
    UILabel *line = [UILabel new];
    line.backgroundColor = ThemeColor;
    [tf addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(tf);
        make.height.equalTo(2);
    }];
    
    //取消 确定
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancleBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [cancleBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deterBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [deterBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    deterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [deterBtn addTarget:self action:@selector(clickDetermine) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView addSubview:cancleBtn];
    [alertView addSubview:deterBtn];
    
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.bottom.equalTo(0);
        make.top.equalTo(tf.mas_bottom).offset(5);
    }];
    
    [deterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.bottom.width.equalTo(cancleBtn);
        make.left.equalTo(cancleBtn.mas_right).offset(50);
    }];
    
}

//重新加载图形验证码
- (void)reLoadImgCaptcha {
    [imgWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSString stringWithFormat:Hekr_getImage,ApiMap[@"uaa-openapi.hekr.me"],Hekr_rid].cy_URL]];
}

@end
