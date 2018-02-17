//
//  AddressPickerView.m
//  MobileProject
//
//  Created by wujunyang on 16/8/3.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "AddressPickerView.h"

#define kAddressPickerScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kAddressPickerScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAddressPickerwindowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define kAddressPickerTopViewColor [UIColor whiteColor]


@interface AddressPickerView()
@property (nonatomic) UIWindow *rootWindow;
@end

//定义弹出高度
static const CGFloat kPickerViewHeight=250;
static const CGFloat kTopViewHeight=40;

@implementation AddressPickerView
{
    NSArray   *_provinces;
    NSArray   *_citys;
    NSArray   *_areas;
    
    NSString  *_currentProvince;
    NSString  *_currentCity;
    NSString  *_currentDistrict;
    
    NSString  *_proID;
    NSString  *_cityID;
    NSString  *_areaID;

    UIView        *_wholeView;
    UIView        *_topView;
    UIPickerView  *_pickerView;
}

+ (id)shareInstance
{
    static AddressPickerView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AddressPickerView alloc] init];
    });
    
    return shareInstance;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.currentPickState=NO;
        
        self.frame = CGRectMake(0, 0, kAddressPickerScreenWidth, kAddressPickerScreenHeight);
        self.backgroundColor=kAddressPickerwindowColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAddressPickView)];
        [self addGestureRecognizer:tap];
        
        [self createData];
        [self createView];
    }
    return self;
}


- (void)createData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"street" ofType:@"plist"];
    NSArray *data = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    _provinces = data;
    
    // 第一个省分对应的全部市
    _citys = [[_provinces objectAtIndex:0] objectForKey:@"areas"];
    // 第一个省份
    _currentProvince = [[_provinces objectAtIndex:0] objectForKey:@"city"];
    // 第一个省份对应的第一个市
    _currentCity = [[_citys objectAtIndex:0] objectForKey:@"area"];
    // 第一个省份对应的第一个市对应的第一个区
    _areas = [[_citys objectAtIndex:0] objectForKey:@"streets"];
    if (_areas.count > 0) {
        _currentDistrict = [[_areas objectAtIndex:0] objectForKey:@"street"];
    } else {
        _currentDistrict = @"";
    }
}

- (void)createView
{
    // 弹出的整个视图
    _wholeView = [[UIView alloc] initWithFrame:CGRectMake(0, kAddressPickerScreenHeight, kAddressPickerScreenWidth, kPickerViewHeight)];
    _wholeView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_wholeView];
    
    // 头部按钮视图
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAddressPickerScreenWidth, kTopViewHeight)];
    _topView.backgroundColor = kAddressPickerTopViewColor;
    [_wholeView addSubview:_topView];
    
    // 防止点击事件触发
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [_topView addGestureRecognizer:topTap];
    
    NSArray *buttonTitleArray = @[@"取消",@"确定"];
    for (int i = 0; i <buttonTitleArray.count ; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(kAddressPickerScreenWidth-50), 0, 50, kTopViewHeight);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
        [_topView addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 初始化pickerView
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight, kAddressPickerScreenWidth, kPickerViewHeight-kTopViewHeight)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_wholeView addSubview:_pickerView];
}

- (void)buttonEvent:(UIButton *)button
{
    // 点击确定回调block
    if (button.tag == 1)
    {
        if (_block) {
            _block(_currentProvince, _currentCity, _currentDistrict,_proID , _cityID , _areaID);
        }
    }
    
    [self hiddenAddressPickView];
}


- (void)showAddressPickView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _wholeView.frame = CGRectMake(0, kAddressPickerScreenHeight-kPickerViewHeight, kAddressPickerScreenWidth, kPickerViewHeight);
         
     } completion:^(BOOL finished) {
         self.currentPickState=YES;
         self.rootWindow = [UIApplication sharedApplication].keyWindow;
         [self.rootWindow addSubview:self];
     }];
}

- (void)hiddenAddressPickView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _wholeView.frame = CGRectMake(0, kAddressPickerScreenHeight, kAddressPickerScreenWidth, kPickerViewHeight);
     } completion:^(BOOL finished) {
         self.currentPickState=NO;
         [self removeFromSuperview];
     }];
}


#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_citys count];
            break;
        case 2:
            
            return [_areas count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return [[_provinces objectAtIndex:row] objectForKey:@"city"];
            break;
        case 1:
            return [[_citys objectAtIndex:row] objectForKey:@"area"];
            break;
        case 2:
            if ([_areas count] > 0) {
                return [[_areas objectAtIndex:row] objectForKey:@"street"];
                break;
            }
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView selectRow:row inComponent:component animated:YES];
    
    switch (component)
    {
        case 0:
            
            _citys = [[_provinces objectAtIndex:row] objectForKey:@"areas"];
            [_pickerView selectRow:0 inComponent:1 animated:YES];
            [_pickerView reloadComponent:1];
            
            _areas = [[_citys objectAtIndex:0] objectForKey:@"streets"];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            [_pickerView reloadComponent:2];
            
            _currentProvince = [[_provinces objectAtIndex:row] objectForKey:@"city"];
            _currentCity = [[_citys objectAtIndex:0] objectForKey:@"area"];
            
            _proID = [[_provinces objectAtIndex:row] objectForKey:@"id"];
            _cityID = [[_citys objectAtIndex:0] objectForKey:@"id"];
            if ([_areas count] > 0) {
                _currentDistrict = [[_areas objectAtIndex:0] objectForKey:@"street"];
                _areaID = [[_areas objectAtIndex:0] objectForKey:@"id"];
            } else{
                _currentDistrict = @"";
                _areaID = @"";
            }
            break;
            
        case 1:
            
            _areas = [[_citys objectAtIndex:row] objectForKey:@"streets"];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            [_pickerView reloadComponent:2];
            
            _currentCity = [[_citys objectAtIndex:row] objectForKey:@"area"];
            _cityID = [[_citys objectAtIndex:row] objectForKey:@"id"];
            if ([_areas count] > 0) {
                _currentDistrict = [[_areas objectAtIndex:0] objectForKey:@"street"];
                _areaID = [[_areas objectAtIndex:0] objectForKey:@"id"];
            } else {
                _currentDistrict = @"";
                _areaID = @"";
            }
            break;
            
        case 2:
            
            if ([_areas count] > 0) {
                _currentDistrict = [[_areas objectAtIndex:row] objectForKey:@"street"];
                _areaID = [[_areas objectAtIndex:row] objectForKey:@"id"];
            } else{
                _currentDistrict = @"";
                _areaID = @"";
            }
            break;
            
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

#pragma mark 默认绑定设置

-(void)configDataProvince:(NSString *)provinceName City:(NSString *)cityName Town:(NSString *)townName
{
    NSString *provinceStr = provinceName;
    NSString *cityStr = cityName;
    NSString *districtStr = townName;
    
    int oneColumn=0, twoColumn=0, threeColum=0;
    
    // 省份
    for (int i=0; i<_provinces.count; i++)
    {
        if ([provinceStr isEqualToString:[_provinces[i] objectForKey:@"city"]]) {
            oneColumn = i;
        }
    }
    
    // 用来记录是某个省下的所有市
    NSArray *tempArray = [_provinces[oneColumn] objectForKey:@"areas"];
    // 市
    for  (int j=0; j<[tempArray count]; j++)
    {
        if ([cityStr isEqualToString:[tempArray[j] objectForKey:@"area"]])
        {
            twoColumn = j;
            break;
        }
    }
    
    // 区
    for (int k=0; k<[[tempArray[twoColumn] objectForKey:@"streets"] count]; k++)
    {
        if ([districtStr isEqualToString:[tempArray[twoColumn] objectForKey:@"streets"][k]])
        {
            threeColum = k;
            break;
        }
    }
    
    [self pickerView:_pickerView didSelectRow:oneColumn inComponent:0];
    [self pickerView:_pickerView didSelectRow:twoColumn inComponent:1];
    [self pickerView:_pickerView didSelectRow:threeColum inComponent:2];
}

@end

