//
//  QuesSectionHeader.h
//  SiterLink
//
//  Created by CY on 2017/6/12.
//  Copyright © 2017年 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXScrollLabelView.h"
@interface QuesSectionHeader : UITableViewHeaderFooterView

@property (nonatomic) TXScrollLabelView *quesLB;

@property (nonatomic) UIButton *accsBtn;

@property (nonatomic) NSInteger section;

@property (nonatomic, copy) void(^headerClickBlock)(NSInteger section);

@end
