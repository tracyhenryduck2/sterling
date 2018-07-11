//
//  AutoScrollLabel.m
//  ScrollLabel
//
//  Created by shen on 17/4/10.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "AutoScrollLabel.h"


#define Lable_Buffer_Space 20
#define Default_Pixels_Per_Second 30
#define Default_Pause_Time 0.5f


@implementation AutoScrollLabel

- (void)commonInit{
    
    for (int i=0; i< Num_Lable; ++i){
        
        label[i] = [[UILabel alloc] init];
        label[i].textColor = [UIColor whiteColor];
        label[i].backgroundColor = [UIColor clearColor];
        [self addSubview:label[i]];
        
    }
    
    scrollDirection = AutoScroll_Scroll_Left;
    
    scrollSpeed = Default_Pixels_Per_Second;
    
    pauseInterval = Default_Pause_Time;
    
    bufferSpaceBetweenLabels = Lable_Buffer_Space;
    self.showsVerticalScrollIndicator = NO;
    
    self.showsHorizontalScrollIndicator = NO;
    
    self.userInteractionEnabled = NO;
}

-(id)init{
    if (self = [super init]){
        
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self commonInit];
    }
    return self;
}


#if 0
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    [NSThread sleepForTimeInterval:pauseInterval];
    
    isScrolling = NO;
    
    if ([finished intValue] == 1 && label[0].frame.size.width > self.frame.size.width){
        [self scroll];
    }
}
#else
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    isScrolling = NO;
    
    if ([finished intValue] == 1 && label[0].frame.size.width > self.frame.size.width){
        [NSTimer scheduledTimerWithTimeInterval:pauseInterval target:self selector:@selector(scroll) userInfo:nil repeats:NO];
    }
}
#endif


- (void)scroll{
    if (isScrolling){
        //		return;
    }
    isScrolling = YES;
    
    if (scrollDirection == AutoScroll_Scroll_Left){
        self.contentOffset = CGPointMake(0,0);
    }else{
        self.contentOffset = CGPointMake(label[0].frame.size.width+Lable_Buffer_Space,0);
    }
    
    [UIView beginAnimations:@"scroll" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:label[0].frame.size.width/(float)scrollSpeed];
    
    if (scrollDirection == AutoScroll_Scroll_Left){
        self.contentOffset = CGPointMake(label[0].frame.size.width+Lable_Buffer_Space,0);
    }else{
        self.contentOffset = CGPointMake(0,0);
    }
    
    [UIView commitAnimations];
}


- (void) readjustLabels{
    float offset = 0.0f;
    
    for (int i = 0; i < Num_Lable; ++i){
        [label[i] sizeToFit];
        CGPoint center;
        center = label[i].center;
        center.y = self.center.y - self.frame.origin.y;
        label[i].center = center;
        
        CGRect frame;
        frame = label[i].frame;
        frame.origin.x = offset;
        label[i].frame = frame;
        
        offset += label[i].frame.size.width + Lable_Buffer_Space;
    }
    
    CGSize size;
    size.width = label[0].frame.size.width + self.frame.size.width + Lable_Buffer_Space;
    size.height = self.frame.size.height;
    self.contentSize = size;
    
    [self setContentOffset:CGPointMake(0,0) animated:NO];
    if (label[0].frame.size.width > self.frame.size.width){
        for (int i = 1; i < Num_Lable; ++i){
            label[i].hidden = NO;
        }
        [self scroll];
    }else{
        for (int i = 1; i < Num_Lable; ++i){
            label[i].hidden = YES;
        }
        CGPoint center;
        center = label[0].center;
        center.x = self.center.x - self.frame.origin.x;
        label[0].center = center;
    }
    
}


- (void) setText: (NSString *) text{
    
    if ([text isEqualToString:label[0].text]){
        if (label[0].frame.size.width > self.frame.size.width){
            [self scroll];
        }
        return;
    }
    for (int i=0; i<Num_Lable; ++i){
        label[i].text = text;
    }
    [self readjustLabels];
}
- (NSString *) text{
    return label[0].text;
}


- (void) setTextColor:(UIColor *)color{
    
    for (int i=0; i<Num_Lable; ++i){
        label[i].textColor = color;
    }
}

- (UIColor *) textColor{
    
    return label[0].textColor;
}


- (void) setFont:(UIFont *)font{
    for (int i=0; i<Num_Lable; ++i){
        
        label[i].font = font;
    }
    [self readjustLabels];
}

- (UIFont *)font{
    return label[0].font;
}


- (void) setScrollSpeed:(float)speed{
    scrollSpeed = speed;
    [self readjustLabels];
}

- (float)scrollSpeed{
    return scrollSpeed;
}

- (void) setScrollDirection: (enum AutoScrollDirection)direction{
    scrollDirection = direction;
    [self readjustLabels];
}

- (enum AutoScrollDirection) scrollDirection{
    return scrollDirection;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
