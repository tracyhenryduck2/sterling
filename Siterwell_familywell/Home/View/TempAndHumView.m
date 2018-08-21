//
//  TempAndHumView.m
//  sHome
//
//  Created by CY on 2018/3/26.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "TempAndHumView.h"
#import "BatterHelp.h"

@implementation TempAndHumView {
    UILabel *nameLb;
    UILabel *tempLb;
    UILabel *humLb;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    nameLb = [[UILabel alloc] init];
    nameLb.textColor = [UIColor whiteColor];
    nameLb.font = [UIFont systemFontOfSize:16];
    [self addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(70);
    }];
    
    tempLb = [[UILabel alloc] init];
    tempLb.textColor = [UIColor whiteColor];
    tempLb.font = [UIFont systemFontOfSize:40];
    [self addSubview:tempLb];
    [tempLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(40);
        make.right.equalTo(-50);
    }];
    
    humLb = [[UILabel alloc] init];
    humLb.font = [UIFont systemFontOfSize:40];
    humLb.textColor = [UIColor whiteColor];
    [self addSubview:humLb];
    [humLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(40);
        make.left.equalTo(50);
    }];
}

- (void)setItemData:(ItemData *)itemData {
    
    if([NSString isBlankString:itemData.customTitle]){
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        NSDictionary* names = [dic valueForKey:@"names"];
        nameLb.text  = [NSString stringWithFormat:@"%@ %ld", NSLocalizedString([names objectForKey:itemData.device_name], nil),[itemData.device_ID integerValue]];
    }else{
        nameLb.text = itemData.customTitle;
    }
    
    NSString *tempstr = [itemData.device_status substringWithRange:NSMakeRange(4, 2)];
    NSString *one = [BatterHelp getBinaryByhex:tempstr];
    one = one.length < 8 ? [@"0000" stringByAppendingString:one] : one;
    one = [one substringWithRange:NSMakeRange(0, 1)];
    NSNumber *tempNum = [BatterHelp numberHexString:tempstr];
    
    NSString *humstr = [itemData.device_status substringWithRange:NSMakeRange(6, 2)];
    NSNumber *humNum = [BatterHelp numberHexString:humstr];
    if ([one isEqualToString:@"1"]) {
        int ttemp = [tempNum intValue] - 256;
        tempLb.text = [NSString stringWithFormat:@"%d℃", ttemp];
    } else {
        tempLb.text = [NSString stringWithFormat:@"%@℃", [tempNum stringValue]];
    }
    humLb.text = [NSString stringWithFormat:@"%@%%", [humNum stringValue]];
}

@end
