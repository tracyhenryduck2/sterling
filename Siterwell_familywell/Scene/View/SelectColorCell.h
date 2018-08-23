//
//  SelectColorCell.h
//  sHome
//
//  Created by Apple on 2017/6/4.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectColorCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *colorsView;
@property (strong, nonatomic) NSIndexPath *oldIndexPath;
@property (strong, nonatomic) NSString *currtetColor;
@property (strong, nonatomic) void (^colorSelected)(NSString *color);

@end
