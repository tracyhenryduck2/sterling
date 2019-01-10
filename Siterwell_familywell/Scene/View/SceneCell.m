//
//  SceneCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneCell.h"
@implementation SceneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = SYSTEMFONT(25);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.left).offset(10);
    }];

    self.detailLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        
    }];
    
    self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickBtn.frame = CGRectMake(250,5,100,30);
    [self.clickBtn setTitle:NSLocalizedString(@"点击", nil) forState:UIControlStateNormal];
    self.clickBtn.backgroundColor = ThemeColor;
    self.clickBtn.titleLabel.font = SYSTEMFONT(12);
    //关键语句
    self.clickBtn.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
    [self.contentView addSubview:self.clickBtn];
    [self.clickBtn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(100);
        make.height.equalTo(30);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
}

-(void) tap :(UIButton *) sender{
    NSInteger tag = sender.tag;
    [self.clickdelegate clickfor:tag];
}
@end
