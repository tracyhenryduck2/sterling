//
//  SystemSceneCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SystemSceneCell.h"
@implementation SystemSceneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    self.headerImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.left).offset(10);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        
    }];
    
    self.selectSceneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectSceneBtn setImage:[UIImage imageNamed:@"noselect_icon"] forState:UIControlStateNormal];
    [self.selectSceneBtn setImage:[UIImage imageNamed:@"select_blue_icon"] forState:UIControlStateSelected];
    [self.selectSceneBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 5, 25)];
    [self addSubview:self.selectSceneBtn];
    [self.selectSceneBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(self.contentView.right).offset(0);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(70);
        make.height.equalTo(self.contentView.mas_height);
    }];

    self.color = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.color];
    self.color.backgroundColor = [UIColor redColor];
    [self.color mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.selectSceneBtn.mas_left).offset(-10);
        make.width.equalTo(60);
        make.height.equalTo(30);

    }];
}
@end
