//
//  BeforeConfigurationVC.m
//  Siterwell_familywell
//
//  Created by tracyhenry on 2018/11/5.
//  Copyright © 2018 iMac. All rights reserved.
//

#import "BeforeConfigurationVC.h"
#import "WifiConfigureVC.h"

@interface BeforeConfigurationVC ()

@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UIButton *btn;
@end

@implementation BeforeConfigurationVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"网关配置", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self imageview];
    [self label1];
    [self label2];
    [self btn];
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 12; i++) {
        UIImage *imageName = [UIImage imageNamed:[NSString stringWithFormat:@"config%d",i]];
        [frames addObject:imageName];
    }
    _imageview.animationImages = frames;
    _imageview.animationDuration = 11.0f;
    [_imageview startAnimating];
}

#pragma -mark lazy
-(UIImageView *)imageview{
    if(_imageview==nil){
        _imageview = [[UIImageView alloc] init];
        
        [self.view addSubview:_imageview];
        [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(219, 182));
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-70);
        }];
    }
    
    return _imageview;
}

-(UILabel *)label1{
    if(_label1==nil){
        _label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label1.text = NSLocalizedString(@"网关上电5秒后,长按网关按钮三秒以上", nil);
        //自动折行设置
        _label1.lineBreakMode = NSLineBreakByWordWrapping;
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.numberOfLines = 0;
        [self.view addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.imageview.mas_bottom).offset(20);
        }];
    }
    return _label1;
}

-(UILabel *)label2{
    if(_label2==nil){
        _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label2.text = NSLocalizedString(@"请确认网关蓝灯闪烁，然后点击下一步", nil);
        //自动折行设置
        _label2.lineBreakMode = NSLineBreakByWordWrapping;
        _label2.textAlignment = NSTextAlignmentCenter;
        _label2.textColor = LightYellow;
        _label2.numberOfLines = 0;
        [self.view addSubview:_label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(_label1.mas_bottom).offset(20);
        }];
    }
    return _label2;
}

-(UIButton *)btn{
    if(_btn==nil){
        _btn = [[UIButton alloc] initWithFrame:CGRectZero];
        _btn.backgroundColor = ThemeColor;
        _btn.layer.cornerRadius = 10;
        [_btn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(200);
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.label2.mas_bottom).offset(20);
        }];
    }
    return _btn;
}

#pragma -mark method
-(void)next{
    WifiConfigureVC *vc =[[WifiConfigureVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
