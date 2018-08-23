//
//  colorItemCell.m
//  sHome
//
//  Created by Apple on 2017/6/4.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "colorItemCell.h"

@implementation colorItemCell



-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.baseColorView = [[UIView alloc] init];
    [self.contentView addSubview:self.baseColorView];
    [self.baseColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.colorImageView = [[UIImageView alloc] init];
    
    [self.baseColorView addSubview:self.colorImageView];
    [self.colorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseColorView.mas_right).offset(0);
        make.left.equalTo(self.baseColorView.mas_left).offset(0);
        make.top.equalTo(self.baseColorView.mas_top).offset(0);
        make.bottom.equalTo(self.baseColorView.mas_bottom).offset(0);
    }];
}

@end
