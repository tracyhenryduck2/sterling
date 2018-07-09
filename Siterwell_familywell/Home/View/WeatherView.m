//
//  WeatherView.m
//  
//
//  Created by TracyHenry on 2018/7/9.
//

#import "WeatherView.h"

@implementation WeatherView {
    UIImageView *weaIcon;
    UILabel *addressLb;
    UILabel *lb1;
    UILabel *lb2;
    UILabel *lb3;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupLocWeather];
    }
    return self;
}

- (void)setupLocWeather {
    weaIcon = [[UIImageView alloc] init];
    [self addSubview:weaIcon];
    [weaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(40);
        make.left.equalTo(10);
        make.width.height.equalTo(40);
    }];
    
    addressLb = [[UILabel alloc] init];
    //    addressLb.text = self.address;
    addressLb.font = [UIFont boldSystemFontOfSize:20];
    addressLb.textColor = [UIColor whiteColor];
    [self addSubview:addressLb];
    [addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(64);
    }];
    
    lb1 = [[UILabel alloc] init];
    //    lb1.text = self.model.weather;
    lb1.textColor = [UIColor whiteColor];
    lb1.font = [UIFont systemFontOfSize:14];
    [self addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weaIcon.mas_right).offset(10);
        make.centerY.equalTo(-20+40);
    }];
    
    lb2 = [[UILabel alloc] init];
    //    lb2.text = [NSString stringWithFormat:NSLocalizedString(@"空气湿度：%@%%", nil), self.model.humidity];
    lb2.textColor = [UIColor whiteColor];
    lb2.font = [UIFont systemFontOfSize:14];
    [self addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lb1);
        make.centerY.equalTo(40+5);
    }];
    
    lb3 = [[UILabel alloc] init];
    //    lb3.text = [NSString stringWithFormat:@"%d℃", (int)(self.model.temp.floatValue - 273.16)];
    lb3.textColor = [UIColor whiteColor];
    lb3.font = [UIFont boldSystemFontOfSize:55];
    [self addSubview:lb3];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(weaIcon);
    }];
}

- (void)setModel:(NewWeatherModel *)model {
    self.model = model;
    [weaIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://openweathermap.org/themes/openweathermap/assets/vendor/owm/img/widgets/%@.png", model.icon]] placeholderImage:[UIImage imageNamed:@"weather_icon"]];
    lb1.text = model.weather;
    lb2.text = [NSString stringWithFormat:NSLocalizedString(@"空气湿度：%@%%", nil), model.humidity];
    lb3.text = [NSString stringWithFormat:@"%d℃", (int)(model.temp.floatValue - 273.16)];
}

- (void)setAddress:(NSString *)address {
    addressLb.text = address;
}

@end
