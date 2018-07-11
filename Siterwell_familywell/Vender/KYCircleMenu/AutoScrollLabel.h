//
//  AutoScrollLabel.h
//  ScrollLabel
//
//  Created by shen on 17/4/10.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Num_Lable 2

enum AutoScrollDirection {
    
    AutoScroll_Scroll_Right,
    AutoScroll_Scroll_Left,
};


@interface AutoScrollLabel : UIScrollView<UIScrollViewDelegate>{
    
    UILabel *label[Num_Lable];
    enum AutoScrollDirection scrollDirection;
    float scrollSpeed;
    NSTimeInterval pauseInterval;
    int bufferSpaceBetweenLabels;
    bool isScrolling;
    
}
@property(nonatomic,retain) UIColor *textColor;

@property(nonatomic, retain) UIFont *font;

- (void)readjustLabels;
- (void) setText:(NSString *)text;
- (NSString *)text;
- (void)scroll;

@end
