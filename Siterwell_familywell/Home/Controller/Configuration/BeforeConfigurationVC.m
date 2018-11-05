//
//  BeforeConfigurationVC.m
//  Siterwell_familywell
//
//  Created by tracyhenry on 2018/11/5.
//  Copyright © 2018 iMac. All rights reserved.
//

#import "BeforeConfigurationVC.h"

@interface BeforeConfigurationVC ()

@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@end

@implementation BeforeConfigurationVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"网关配置", nil);
}

#pragma -mark lazy
-(UIImageView *)imageview{
    if(_imageview==nil){
        _imageview = [[UIImageView alloc] init];
        [_imageview setImage:[UIImage imageNamed:@""]];
        [self.view addSubview:_imageview];
        [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(30);
        }];
    }
    
    return _imageview;
}
@end
