//
//  TimerSwitchCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "TimerSwitchCell.h"
#import "BatterHelp.h"

@interface TimerSwitchCell()
@property (strong, nonatomic) UILabel *day1;
@property (strong, nonatomic) UILabel *HM;
@property (strong, nonatomic) UILabel *to;
@property (strong, nonatomic) UILabel *sceneName;
@end

@implementation TimerSwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    self.HM = [[UILabel alloc] init];
    self.HM.font = SYSTEMFONT(19);
    [self.contentView addSubview:self.HM];
    self.HM.text = @"00:00";
    [self.HM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.left).offset(10);
    }];
    
    self.to = [[UILabel alloc] init];
    [self.contentView addSubview:self.to];
    self.to.font = SYSTEMFONT(14);
    self.to.text = NSLocalizedString(@"切换到", nil);
    [self.to mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.HM.mas_centerY);
        make.left.equalTo(self.HM.mas_right).offset(5);
        
    }];
    
    self.sceneName = [[UILabel alloc] init];
    [self.contentView addSubview:self.sceneName];
    self.sceneName.font = SYSTEMFONT(19);
    self.sceneName.text = NSLocalizedString(@"在家", nil);
    [self.sceneName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.to.mas_centerY);
        make.left.equalTo(self.to.mas_right).offset(5);
        
    }];
    
    self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clickBtn setImage:[UIImage imageNamed:@"off02_btn"] forState:UIControlStateNormal];
    [self.clickBtn setImage:[UIImage imageNamed:@"on02_icon"] forState:UIControlStateSelected];
    self.clickBtn.backgroundColor = [UIColor clearColor];
    self.clickBtn.titleLabel.font = SYSTEMFONT(12);
    [self.contentView addSubview:self.clickBtn];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(50);
        make.height.equalTo(self.contentView.mas_height);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    [self.clickBtn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    self.day1 = [[UILabel alloc] init];
    self.day1.font = SYSTEMFONT(12);
    [self.contentView addSubview:self.day1];
    [self.day1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.contentView.left).offset(10);
    }];

}

-(void)setTime:(NSString *)hour withMin:(NSString *)min{
    self.HM.text = [NSString stringWithFormat:@"%@:%@",hour,min ];
}

-(void)setSceneGroup:(NSString *)name{
    self.sceneName.text = name;
}

-(void)setEnable:(NSNumber *)enable{
    if([enable intValue]==1){
        [self.clickBtn setSelected:YES];
    }else{
        [self.clickBtn setSelected:NO];
    }
}

-(void)setWeek:(NSString *)week{
    NSString *binstring = [BatterHelp getBinaryByhex:week];
    NSString *ss = @"";
    for(int i=0;i<7;i++){
       NSString * wei = [binstring substringWithRange:NSMakeRange(7-i-1, 1)];
        
        switch (i) {
            case 0:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周一", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 1:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周二", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 2:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周三", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 3:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周四", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 4:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周五", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 5:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周六", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
            case 6:
                if([wei isEqualToString:@"1"]){
                    ss = [ss stringByAppendingString:NSLocalizedString(@"周日", nil)];
                    ss = [ss stringByAppendingString:@"、"];
                }
                break;
                
            default:
                break;
        }
    }
   NSRange range = [ss rangeOfString:@"、" options:NSBackwardsSearch];
   ss = [ss substringWithRange:NSMakeRange(0, range.location)];
   
   self.day1.text = ss;
}

-(void)tap:(UIButton *)sender{
    int tag = (int)sender.tag;
    self.click(tag);
}
@end
