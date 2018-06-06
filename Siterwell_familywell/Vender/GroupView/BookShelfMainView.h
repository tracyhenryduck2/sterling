//
//  BookShelfMainView.h
//  ShelfCollectionView
//
//  Created by king.wu on 8/24/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfModel.h"

/**
 *  书架主界面
 */
@interface BookShelfMainView : UIView

@property (nonatomic ,strong) UIViewController *subVC;
@property (nonatomic ,strong) ShelfModel *model;

@property (nonatomic, strong) RACSubject *delegate;

+ (instancetype)loadFromNib;

- (void)initWithData:(NSArray *)itemDatas;
- (void)reloadData;
- (void)stopScycn;
- (void)startScycn;
@end
