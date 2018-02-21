//
//  BaseVC.h
//  Qibuer
//
//  Created by shap on 2016/11/25.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController
- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage withTintColor:(UIColor *)color;
- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title withTintColor:(UIColor *)color;

@end
