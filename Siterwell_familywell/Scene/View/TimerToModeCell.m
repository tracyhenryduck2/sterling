//
//  TimerToModeCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "TimerToModeCell.h"
#import "DBSystemSceneManager.h"

@interface TimerToModeCell()



@end

@implementation TimerToModeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initdata];
        [self initview];
    }
    return self;
}

-(void)initdata{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    _modelist = [[DBSystemSceneManager sharedInstanced] queryAllSystemScene:currentgateway2];
    
    
}

-(void)initview{
    _pickview = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _pickview.delegate = self;
    _pickview.dataSource = self;
    [self.contentView addSubview:_pickview];
    [_pickview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.equalTo(240);
        make.height.equalTo(160);
    }];
}

#pragma -mark delegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
        return  _modelist.count;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if(component == 1){
        return 5;
    }
    return 80;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    SystemSceneModel *ss = [_modelist objectAtIndex:row];
    if([ss.sence_group intValue] == 0){
        return NSLocalizedString(@"在家", nil);
    }else if([ss.sence_group intValue] == 1){
        return NSLocalizedString(@"离家", nil);
    }else if([ss.sence_group intValue] == 2){
        return NSLocalizedString(@"睡眠", nil);
    }else{
        return ss.systemname;
    }
    
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = RGB(245, 103, 53);
        }
    }
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.textColor = RGB(245, 103, 53);
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

@end
