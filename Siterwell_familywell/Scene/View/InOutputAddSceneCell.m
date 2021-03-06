//
//  InputAddSceneCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/30.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "InOutputAddSceneCell.h"
#import "AddSceneCell.h"
#import "SceneListItemData.h"
@implementation InOutputAddSceneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    self.datalistView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
    self.datalistView.backgroundColor = [UIColor whiteColor];
    [self.datalistView registerClass:[AddSceneCell class] forCellWithReuseIdentifier:@"addsceneItemCell"];
    self.datalistView.delegate = self;
    self.datalistView.dataSource = self;
    self.datalistView.scrollEnabled = NO;
    [self.contentView addSubview:self.datalistView];
    [self.datalistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemdatas.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddSceneCell *cell = (AddSceneCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"addsceneItemCell" forIndexPath:indexPath];
    SceneListItemData *data = [_itemdatas objectAtIndex:indexPath.row];
    cell.image_custom.image = [UIImage imageNamed:data.image];
    cell.customtitle.text = data.custmTitle;
    cell.tag = indexPath.row;
    if(![data.type isEqualToString:@"add"]){
        UILongPressGestureRecognizer *lpGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readyToDeleteItem:)];
        lpGes.minimumPressDuration = 0.8f;
        [cell addGestureRecognizer:lpGes];
    }else{
        NSArray<UIGestureRecognizer *> *gesArray = cell.gestureRecognizers;
        for (int i = 0; i < gesArray.count; i++) {
            [cell removeGestureRecognizer:gesArray[i]];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SceneListItemData *data = [_itemdatas objectAtIndex:indexPath.row];
    if (_delegate) {
       [_delegate sendNext:data];
    }
    
    if(_indexdelegate){
        
        [_indexdelegate sendNext: [NSNumber numberWithInteger:indexPath.row] ];
    }

}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){Main_Screen_Width/3,Main_Screen_Width/4};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma -mark method
- (void)readyToDeleteItem:(UILongPressGestureRecognizer *)ges {
    
    AddSceneCell *cell = (AddSceneCell *)[ges view];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确定删除", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_longclickdelegate) {
            NSString *tag = [NSString stringWithFormat:@"%ld",(long)cell.tag];
            [_longclickdelegate sendNext:tag];
        }
    }]];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}
@end
