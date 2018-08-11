//
//  SceneHeader.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/8/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneHeaderView.h"

@implementation SceneHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self iniview];
    }
    return self;
}

-(void)iniview{
    _tittle = [[UILabel alloc] init];
    _tittle.text = NSLocalizedString(@"情景列表", nil);
    [self addSubview:_tittle];
    [_tittle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    _btn_add_scene = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_add_scene setImage:[UIImage imageNamed:@"add_list_icon"] forState:UIControlStateNormal];
    [self addSubview:_btn_add_scene];
    [_btn_add_scene mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(Main_Screen_Width);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}


@end
