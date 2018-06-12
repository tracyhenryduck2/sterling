//
//  RegistCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "RegistCell.h"

@implementation RegistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (IBAction)hidenAction:(id)sender {
    UIButton *btn = sender;
    _titleTextField.secureTextEntry = !_titleTextField.secureTextEntry;
    if (_titleTextField.isSecureTextEntry) {
        [btn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateNormal];
    }
}

@end
