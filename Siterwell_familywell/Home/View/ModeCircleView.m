//
//  ModeCircleView.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/11.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ModeCircleView.h"

@interface ModeCircleView()

@property (nonatomic,strong) UIImageView *backImage;
@property (nonatomic,strong) UILabel *text_label2;
@property (nonatomic,strong) AutoScrollLabel *text_label;
@property (nonatomic,strong) UIImageView *img_label;

@end

@implementation ModeCircleView

#pragma mark -super
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUI];
    }
    return self;
}

-(instancetype)init{
    if(self = [super init]){
        [self setUI];
    }
    return self;
}

#pragma mark -method
-(void) setUI{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 60.0f/2;
     self.backgroundColor = [UIColor whiteColor];
    _backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle_icon00"]]; //把oneImage添加到oneImageView上
    _backImage.frame = CGRectMake(0, 0, 60, 60); // 设置图片位置和大小，如果设置了frame，那么它这是的位置将不起作用
    _backImage.alpha = 1.0; // 设置透明度
    [self addSubview:_backImage];
    
    if(!_img_label){
        _img_label =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home01_icon"]];
        [self addSubview:_img_label];
        [_img_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 26));
            make.centerX.equalTo(self);
            make.top.mas_equalTo(self.top).offset(5);
        }];
    }

    
    if(!_text_label2){
        _text_label2 = [[UILabel alloc] init];
        _text_label2.text = @"";
        [self addSubview:_text_label2];
        [_text_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 21));
            make.centerX.equalTo(self);
            make.top.mas_equalTo(_img_label.bottom).offset(3);
        }];
    }

    
    if(!_text_label){
        _text_label = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(0, 0, 42, 21)];
        _text_label.font = [UIFont systemFontOfSize:13.0f];
        _text_label.textColor = RGB(53, 167, 255);
        _text_label.text = @"";
        [_text_label2 addSubview:_text_label];
    }

}

-(void)setLabel:(SystemSceneModel *)sceneModel{
    
    if([sceneModel.sid integerValue] == 0){
            [_img_label setImage:[UIImage imageNamed:@"home01_icon"]];
    }else if([sceneModel.sid integerValue] == 1){
              [_img_label setImage:[UIImage imageNamed:@"away01_icon"]];
    }else if([sceneModel.sid integerValue] == 2){
             [_img_label setImage:[UIImage imageNamed:@"sleep01_icon"]];
    }else{
           [_img_label setImage:[UIImage imageNamed:@"home01_icon"]];
    }
    

}

-(void)setText:(NSString *)text{
        [_text_label setText:text];
}

@end
