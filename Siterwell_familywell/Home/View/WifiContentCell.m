//
//  WifiContentCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "WifiContentCell.h"
@implementation WifiContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    

    self.image_title = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.image_title];
    [self.image_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(30);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    self.labeltitle = [[UILabel alloc] init];
    [self.contentView addSubview:self.labeltitle];
    [self.labeltitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image_title.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.field = [[UITextField alloc] initWithFrame:CGRectZero];
    self.field.backgroundColor = [UIColor clearColor];// 设置背景颜色
    self.field.alpha = 1.0;// 设置透明度，范围从0.0-1.0之间
    self.field.placeholder = NSLocalizedString(@"请输入密码", nil);
    
    [self.contentView addSubview:self.field];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.image_title.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-40);
    }];
    
    self.hidenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hidenBtn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
    [self.hidenBtn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateSelected];
    self.hidenBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.hidenBtn];
    [self.hidenBtn addTarget:self action:@selector(tips:) forControlEvents:UIControlEventTouchUpInside];
    [self.hidenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.and.height.equalTo(30);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    self.field.secureTextEntry = YES;
    [_hidenBtn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
}

-(void)tips:(UIButton *)sender{
    _field.secureTextEntry = !_field.secureTextEntry;
    if (_field.isSecureTextEntry) {
        [_hidenBtn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
    }else{
        [_hidenBtn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateNormal];
    }
}


@end
