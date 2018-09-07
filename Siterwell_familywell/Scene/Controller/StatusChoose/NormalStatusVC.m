//
//  NormalStatusVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/7.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "NormalStatusVC.h"

@interface NormalStatusVC()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView *pickview;
@property(nonatomic,strong)NSArray *workmodelist;
@end
@implementation NormalStatusVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];

    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"sceneDeviceStatus" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    
    if(!_data){
        [MBProgressHUD showError:NSLocalizedString(@"您所选的设备未支持", nil) ToView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else{
        _workmodelist = [dic objectForKey:_data.title];
        if (!_workmodelist) {
            [MBProgressHUD showError:NSLocalizedString(@"您所选的设备未支持", nil) ToView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self pickview];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

#pragma -mark lazy
-(UIPickerView *)pickview{
    if(_pickview == nil){
        _pickview = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _pickview.delegate = self;
        _pickview.dataSource = self;
        [self.view addSubview:_pickview];
        [_pickview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(5);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(Main_Screen_Width);
            make.height.equalTo(80);
        }];
    }
    return nil;
}

#pragma -mark delegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {

    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _workmodelist.count;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

        return 80;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  NSLocalizedString([_workmodelist objectAtIndex:row], nil);
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
