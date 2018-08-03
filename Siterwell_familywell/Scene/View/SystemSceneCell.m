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
    self.headerImageView.backgroundColor = [UIColor redColor];
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
    [self.contentView addSubview:self.selectSceneBtn];
    [self.selectSceneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(40);
        make.height.equalTo(40);
        make.left.equalTo(self.titleLabel.right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.selectSceneBtn setEnabled:NO];
//    self.color = [[UIView alloc] init];
//    [self.contentView addSubview:self.color];
//    [self.color mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.
//        
//    }];
}
@end
