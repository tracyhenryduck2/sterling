//
//  GatewayListView.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/16.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "GatewayListView.h"
@implementation GatewayListView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = SYSTEMFONT(15);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        
    }];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = SYSTEMFONT(12);
    self.subtitleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
    self.selectImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.right).offset(-10);
        make.width.equalTo(20);
        make.height.equalTo(20);
    }];
    
    self.online_status = [[UILabel alloc] init];
    self.online_status.font = SYSTEMFONT(12);
    self.online_status.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.online_status];
    [self.online_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.selectImageView.mas_left).offset(-10);
    }];
}


@end
