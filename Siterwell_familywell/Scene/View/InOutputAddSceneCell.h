//
//  InOutputAddSceneCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/30.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef InOutputAddSceneCell_h
#define InOutputAddSceneCell_h
typedef NS_OPTIONS(NSUInteger, AddSceneCellType) {
    Output = 1,
    intput = 2
};

@interface InOutputAddSceneCell : UITableViewCell<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *datalistView;
@property (assign,nonatomic) AddSceneCellType cellType;
@property (nonatomic,strong) NSMutableArray *itemdatas;
@property (nonatomic,strong) RACSubject *delegate;
@end

#endif /* InputAddSceneCell_h */
