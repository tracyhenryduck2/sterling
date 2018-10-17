//
//  EditPhoneCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "EditPhoneCell.h"
@implementation EditPhoneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    
    self.field = [[UITextField alloc] initWithFrame:CGRectZero];
    self.field.backgroundColor = [UIColor clearColor];// 设置背景颜色
    self.field.alpha = 1.0;// 设置透明度，范围从0.0-1.0之间
    self.field.placeholder = NSLocalizedString(@"请输入紧急号码", nil);
    
    [self.contentView addSubview:self.field];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-40);
    }];
    
}



@end

