//
//  CYMarquee.m
//  sHome
//
//  Created by CY on 2018/3/26.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "CYMarquee.h"
#import "WeatherView.h"
#import "TempAndHumView.h"

@interface CYMarquee () <UIScrollViewDelegate>

@property (nonatomic) NSTimer *timer;

@property (nonatomic) WeatherView *w;

@property (nonatomic) UIScrollView *scroll;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation CYMarquee

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupIB];
    }
    return self;
}

- (void)setupIB {
    UIImageView *back = [[UIImageView alloc] initWithFrame:self.bounds];
    [back setImage:[UIImage imageNamed:@"index_bg"]];
    [self addSubview:back];
    
    self.page = 1;
    [self addTimer];
}

- (void)toNextView {
    if (self.page == self.pageCount) {
        self.page = 0;
    } else {
        self.page += 1;
    }
    CGFloat x = self.page * self.scroll.frame.size.width;
    if (self.page == 0) {
        [self.scroll setContentOffset:CGPointMake(x, 0) animated:NO];
    } else {
        [self.scroll setContentOffset:CGPointMake(x, 0) animated:YES];
    }
}

- (void)addTimer {
    self.page = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(toNextView)userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        _timer = nil;
    }
}


- (WeatherView *)w {
    if (!_w) {
        _w = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.frame.size.height)];
        [self.scroll addSubview:_w];
    }
    return _w;
}

- (void)setModel:(NewWeatherModel *)model {
    self.w.model = model;
}

- (void)setAddress:(NSString *)address {
    self.w.address = address;
}
- (void)setTempAndHumArray:(NSArray<ItemData *> *)tempAndHumArray {
    self.page = 0;
    [self.scroll setContentSize:CGSizeMake(Main_Screen_Width * (tempAndHumArray.count + 1), self.frame.size.height)];
    [self removeTimer];
    for (UIView *subView in self.scroll.subviews) {
        if ([subView isKindOfClass:[TempAndHumView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (int i = 1; i <= tempAndHumArray.count; i++) {
        TempAndHumView *thv = [[TempAndHumView alloc] initWithFrame:CGRectMake(i * Main_Screen_Width, 0, Main_Screen_Width, self.frame.size.height)];
        thv.itemData = tempAndHumArray[i-1];
        [self.scroll addSubview:thv];
    }
    self.pageCount = tempAndHumArray.count;
    [self addTimer];
}


- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.pagingEnabled = YES;
        _scroll.bounces = NO;
        [self addSubview:_scroll];
    }
    return _scroll;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}


@end
