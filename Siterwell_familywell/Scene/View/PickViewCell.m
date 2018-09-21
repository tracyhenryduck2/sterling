//
//  PickViewCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/10.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "PickViewCell.h"

@interface PickViewCell()

@property(nonatomic,strong) NSMutableArray *hourlist;

@property(nonatomic,strong) NSMutableArray *minlist;

@end

@implementation PickViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initdata];
        [self initview];
    }
    return self;
}

-(void)initdata{
    _hourlist = [NSMutableArray new];
    for(int i=0;i<23;i++){
        [_hourlist addObject:[NSString stringWithFormat:@"%d",i ]];
    }
    
    _minlist = [NSMutableArray new];
    for(int i=0;i<59;i++){
        [_minlist addObject:[NSString stringWithFormat:@"%d",i ]];
    }
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
    
    return 3;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0){
      return  _hourlist.count;
    }else if(component == 1){
        return 1;
    }else{
      return _minlist.count;
    }
    
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
    if(component == 0){
        return [_hourlist objectAtIndex:row];
    }else if(component == 1){
        return @":";
    }else{
        return [_minlist objectAtIndex:row];
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
