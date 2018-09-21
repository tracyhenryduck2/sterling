//
//  ModelListVC.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/7.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef ModelListVC_h
#define ModelListVC_h
@interface ModelListVC:BaseVC<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *datalistView;
@property (nonatomic,assign) BOOL IsInput;
@property (nonatomic,strong) RACSubject *delegate;

@end

#endif /* ModelListVC_h */
