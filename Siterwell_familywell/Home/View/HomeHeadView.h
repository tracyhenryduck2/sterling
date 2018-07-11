//
//  HomeHeadView.h
//  Qibuer
//
//  Created by shap on 2016/11/30.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeHeadViewDelegate;

@interface HomeHeadView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<HomeHeadViewDelegate> delegate;

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) NSArray *videoArray;

@property (nonatomic , strong) NSTimer *timer;

-(id)initWithSubView:(UIView *) view;

@end

@protocol HomeHeadViewDelegate <NSObject>
- (void)cycleScrollView:(HomeHeadView *)cycleScrollView didSelectImageView:(NSInteger)index videoInfos:(NSArray *)videosArray;
@end
