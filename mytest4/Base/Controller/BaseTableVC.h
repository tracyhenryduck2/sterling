//
//  BaseTableVC.h
//  sHome
//
//  Created by shaop on 2016/12/17.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableVC : UITableViewController
- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage withTintColor:(UIColor *)color;
- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title withTintColor:(UIColor *)color;
@end
