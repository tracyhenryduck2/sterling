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
}


@end
