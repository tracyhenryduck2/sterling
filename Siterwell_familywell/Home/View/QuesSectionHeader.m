//
//  QuesSectionHeader.m
//  SiterLink
//
//  Created by CY on 2017/6/12.
//  Copyright © 2017年 CY. All rights reserved.
//

#import "QuesSectionHeader.h"


@implementation QuesSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
        [self.contentView addGestureRecognizer:tap];
        [self accsBtn];
    }
    return self;
}

- (void)headerClick {
    if (self.headerClickBlock) {
        self.headerClickBlock(self.section);
    }
    self.accsBtn.selected = !self.accsBtn.selected;
}

-(TXScrollLabelView *)quesLB{
    if(_quesLB == nil){
        _quesLB = [TXScrollLabelView scrollWithTitle:@"" type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
        /** Step4: 布局(Required) */
        _quesLB.frame = CGRectMake(10, 7, 300, 30);
        
        //偏好(Optional), Preference,if you want.
        _quesLB.tx_centerY = 22;
        _quesLB.userInteractionEnabled = NO;
        _quesLB.scrollInset = UIEdgeInsetsMake(0, 0 , 0, 0);
        _quesLB.scrollSpace = 10;
        _quesLB.font = [UIFont systemFontOfSize:15];
        _quesLB.textAlignment = NSTextAlignmentLeft;
        _quesLB.scrollTitleColor = [UIColor blackColor];
        _quesLB.backgroundColor = [UIColor clearColor];
        _quesLB.layer.cornerRadius = 5;
        [self addSubview:_quesLB];
    }
    return _quesLB;
}



- (UIButton *)accsBtn {
    if (!_accsBtn) {
        _accsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accsBtn setBackgroundColor:[UIColor clearColor]];
        [_accsBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
        [_accsBtn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateSelected];
        [self addSubview:_accsBtn];
        [_accsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-19);
            make.centerY.equalTo(0);
        }];
        
    }
    return _accsBtn;
}

@end
