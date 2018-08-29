//
//  AddSceneCell.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/8/29.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "AddSceneCell.h"

@implementation AddSceneCell

-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.image_custom = [[UIImageView alloc] init];
    [self.contentView addSubview:self.image_custom];
    [self.image_custom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.customtitle = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.customtitle];
    [self.customtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image_custom.mas_bottom).offset(3);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}


@end
