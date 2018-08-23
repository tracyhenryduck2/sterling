//
//  AddSystemScenCell.m
//  sHome
//
//  Created by shaop on 2017/2/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AddSystemScenCell.h"

@implementation AddSystemScenCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    self.idLabel = [[UILabel alloc] init];
    self.idLabel.font=SYSTEMFONT(15);
    self.idLabel.textColor = [UIColor darkGrayColor];
    self.idLabel.adjustsFontSizeToFitWidth=YES;
    [self.contentView addSubview:self.idLabel];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.left).offset(10);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.left).offset(40);
        
    }];
    
    self.selectSceneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectSceneBtn setImage:[UIImage imageNamed:@"noselect_icon"] forState:UIControlStateNormal];
    [self.selectSceneBtn setImage:[UIImage imageNamed:@"select_blue_icon"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectSceneBtn];
    [self.selectSceneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);

    }];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
