//
//  HomeHeadView.m
//  Qibuer
//
//  Created by shap on 2016/11/30.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "HomeHeadView.h"


@implementation HomeHeadView
{
    UIPageControl    *_pageControl; //分页控件
    NSMutableArray *_curImageArray; //当前显示的图片数组
    NSInteger          _curPage;    //当前显示的图片位置
//    NSTimer           *_timer;      //定时器
}

-(id)initWithSubView:(UIView *)view{
    if (self = [super init]) {
        [self setupUI];

        //初始化数据，当前图片默认位置是0
        _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _curPage = 0;
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        
        [self setupUI];
        
        //初始化数据，当前图片默认位置是0
        _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _curPage = 0;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupUI];
        
        //初始化数据，当前图片默认位置是0
        _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _curPage = 0;
    }
    return self;
}

-(void)setupUI{
    
    WS(ws)
    
    _scrollView = [UIScrollView new];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left);
        make.right.equalTo(ws.mas_right);
        make.top.equalTo(ws.mas_top);
        make.bottom.equalTo(ws.mas_bottom).offset(-36);
    }];
    

    [self setImages];

    //分页控件
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPageIndicatorTintColor = RGB(99, 163, 255);
    _pageControl.pageIndicatorTintColor = RGB(203, 203, 203);
    [self addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(ws.mas_left);
        make.right.equalTo(ws.mas_right).offset(-13);
        make.bottom.equalTo(ws.mas_bottom).offset(-13);
        make.height.equalTo(@10);
    }];
    
}

-(void)setImages{

    WS(ws)

    UIView *contView = [UIView new];
    [_scrollView addSubview:contView];

    [contView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.scrollView);
        make.height.equalTo(ws.scrollView.mas_height);
    }];
    
    for (int i=0; i<[_curImageArray count]; i++) {
        
        
//        NSString *imagePath = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:vInfo.devid].imagePath;
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
        
//         NSLog(@"koyang=======koyang====koyang=666666666666==imagePath=%@=====%@===%@",imagePath,vInfo.devid,vInfo.name);

        UIImageView *imageView1 = [UIImageView new];
        [contView addSubview:imageView1];
        imageView1.tag = i+20;
        imageView1.userInteractionEnabled = YES;
        
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(contView.mas_left);
            }else{
                make.left.equalTo([contView viewWithTag:(i + 20 - 1)].mas_right);
            }
            make.height.equalTo(contView.mas_height);
            make.top.equalTo(contView.mas_top);
            make.width.equalTo(ws.mas_width);
        }];
        
        UILabel *nameLbl = [UILabel new];
        [imageView1 addSubview:nameLbl];
        
        nameLbl.textColor = RGB(53, 167, 255);
        nameLbl.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(imageView1.mas_bottom).offset(-10.0f);
            make.left.mas_equalTo(imageView1.mas_left).offset(10.0f);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(150);
        }];
        
        //判断本地图片是否存在
        [imageView1 setImage:[UIImage imageNamed:@"lbt_01"]];
        
        if ([@"lbt_01" isEqualToString:[_curImageArray objectAtIndex:i][@"devid"]]) {
            nameLbl.text = NSLocalizedString(@"无视频，点击添加", nil);
        }else{
            nameLbl.text = [_curImageArray objectAtIndex:i][@"name"];
        }
        
        UIImageView *playIcon = [UIImageView new];
        [contView addSubview:playIcon];
        
        [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imageView1);
            make.width.and.height.mas_equalTo(60);
        }];
        [playIcon setImage:[UIImage imageNamed:@"video_play_icon"]];
        
        //tap手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView1 addGestureRecognizer:tap];
        
    }
    if (_curImageArray.count > 0){
        [contView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo((UIImageView*)[contView viewWithTag:([_curImageArray count] - 1 + 20)].mas_right);
        }];
    }
    [_scrollView setContentOffset:CGPointMake(self.mj_size.width*_curPage, 0)];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    int index = scrollView.contentOffset.x/self.mj_size.width;
    
    if (index > _curPage) {
        
        _curPage = index;
        [scrollView setContentOffset:CGPointMake(self.mj_size.width*_curPage, 0)];
    }else if (index < _curPage){
        _curPage --;
    }
}


//停止滚动的时候回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //设置scrollView偏移位置
//    [scrollView setContentOffset:CGPointMake(self.mj_size.width, 0) animated:YES];
    //设置页数
    _pageControl.currentPage = _curPage;
}

- (void)reloadData
{
    //设置页数
    _pageControl.currentPage = _curPage;
    //根据当前页取出图片
    [self getDisplayImagesWithCurpage:_curPage];
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.scrollView subviews];
    if ([subViews count] > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //创建imageView
    [self setImages];

}

- (void)setVideoArray:(NSMutableArray *)videoArray
{
    _videoArray = videoArray;
    //设置分页控件的总页数
    _pageControl.numberOfPages = videoArray.count;
    //刷新图片
    [self reloadData];
    
//    _scrollView.contentOffset = CGPointMake(self.mj_size.width*2, 0);

    
    //开启定时器
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
    
    //判断图片长度是否大于1，如果一张图片不开启定时器
//    if ([imageArray count] > 1) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:10000000000.0 target:self selector:@selector(timerScrollImage) userInfo:nil repeats:NO];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate date]];
//    }
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page
{
    //取出开头和末尾图片在图片数组里的下标
    NSInteger front = page - 1;
    NSInteger last = page + 1;
    
    //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
    if (page == 0) {
        front = [self.videoArray count]-1;
    }
    
    //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
    if (page == [self.videoArray count]-1) {
        last = 0;
    }
    
    //如果当前图片数组不为空，则移除所有元素
    if ([_curImageArray count] > 0) {
        [_curImageArray removeAllObjects];
    }
    
    //当前图片数组添加图片
    for (int i = 0; i < [self.videoArray count]; i++) {
//
//        VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
//        NSDictionary *videoDic = (NSDictionary *)self.videoArray[i];
//        vInfo.devid = videoDic[@"devid"];
//        vInfo.name = videoDic[@"name"];
        [_curImageArray addObject:(NSDictionary *)self.videoArray[i]];
    }
}

-(void)timerScrollImage{
    //刷新图片
    [self reloadData];
    
    //设置scrollView偏移位置
    [self.scrollView setContentOffset:CGPointMake(self.mj_size.width*2, 0) animated:YES];
}

-(void)tapImage:(id *)sender{
    //设置代理
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectImageView:videoInfos:)]) {
        [_delegate cycleScrollView:self didSelectImageView:_curPage videoInfos:_curImageArray];
    }
}

- (void)dealloc
{
    //代理指向nil，关闭定时器
    self.scrollView.delegate = nil;
//    [_timer invalidate];
}
@end
