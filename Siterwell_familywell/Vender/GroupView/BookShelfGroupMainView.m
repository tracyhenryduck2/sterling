//
//  BookShelfGroupMainView.m
//  ShelfCollectionView
//
//  Created by king.wu on 8/18/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import "BookShelfGroupMainView.h"
#import "BookCollectionViewCell.h"
#import "BookShelfGroupViewFlowLayout.h"
#import "DeviceDetailVC.h"

@interface BookShelfGroupMainView ()<BookShelfGroupViewDataSource, BookShelfGroupViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *groupTitleTextFiled;

@property (weak, nonatomic) IBOutlet UIView *tabExitView;

@property (nonatomic, strong)BookShelfGroupViewFlowLayout *groupFlowLayout;
@property (nonatomic, strong)NSMutableArray* allGroupItems;


@end


@implementation BookShelfGroupMainView

+ (instancetype)loadFromNib{
    return [[[NSBundle mainBundle]loadNibNamed:@"BookShelfGroupMainView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib{
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BookCollectionViewCell"];
    self.collectionView.layer.cornerRadius = 35.0f;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    
    self.collectionView.backgroundColor = RGBA(255, 255, 255, 0.6);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleExitTapGesture:)];
    [self.tabExitView addGestureRecognizer:tapGestureRecognizer];
    
    self.groupTitleTextFiled.layer.cornerRadius = 6.0f;
    self.groupTitleTextFiled.backgroundColor = RGBA(0, 0, 0, 0.6);
    CGRect frame = self.groupTitleTextFiled.frame;
    frame.size.width = 10;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.groupTitleTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.groupTitleTextFiled.leftView = leftview;

    self.groupFlowLayout = [[BookShelfGroupViewFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:self.groupFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.allGroupItems = [[NSMutableArray alloc]init];
}

-(void)reloadData{
    [_collectionView reloadData];
}


/**
 *  打开分组界面的初始化方法
 *
 *  @param groupedItemData 分组里包含的所有的数据
 *  @param snapView        从书架选中的书籍的截图，不为nil, 表面最后一个item被选中，要能直接进行拖动
 * 
 *  （注：初始化时，groupedItemData的最后一项必须是要被进行分组的itemData）
 */
- (void)initWithItemsData:(NSArray *)groupedItemData snapView:(UIView *)snapView{
    [self.allGroupItems removeAllObjects];
    [self.allGroupItems addObjectsFromArray:groupedItemData];
    

    if (snapView != nil){
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.allGroupItems.count - 1 inSection:0];
        [self.groupFlowLayout initSelectSnapShotViewIfNeeded:snapView selectedIndexPath:lastIndexPath];
    }
}

//分组界面完全打开了（分组界面打开有个动画过程）
- (void)didOpened{

    [self.groupFlowLayout setCanExit];
}


- (void)dealloc{
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;

    self.delegate = nil;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.allGroupItems count];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCollectionViewCell" forIndexPath:indexPath];
    cell.numberIndexLabel.textColor = [UIColor whiteColor];
    [cell initCellWithItemData:[self.allGroupItems objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    
    id sourceObject = [self.allGroupItems objectAtIndex:sourceIndexPath.row];
    [self.allGroupItems removeObjectAtIndex:sourceIndexPath.row];
    [self.allGroupItems insertObject:sourceObject atIndex:destinationIndexPath.row];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    float width = collectionView.bounds.size.width /3-1;
    float height = collectionView.bounds.size.width /3;
    return  CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark - BookShelfGroupViewDelegateFlowLayout
//begin movement
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout beginMovementForItemAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseRecv" object:nil];
}

//end movement
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout endMovementForItemAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"countineRecv" object:nil];

}

//当拖动的item不再collectionView范围内时，取消分组
- (void)cancelGroupSelectedItemAtIndexPath:(NSIndexPath *)itemIndexPath withSnapShotView:(UIView *)snapShotView{
    
    id itemData = [self.allGroupItems objectAtIndex:itemIndexPath.row];
    [self cancelGroupWithItemData:itemData withSnapShotView:snapShotView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"点击" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:cancelAction];
//    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    id itemData = [self.allGroupItems objectAtIndex:indexPath.row];
    ItemData *data = itemData;
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    NSDictionary * _names = [dic valueForKey:@"names"];
    NSString * devicename = [_names objectForKey:data.device_name];
    if ([devicename isEqualToString:@"情景开关"]) {

    }
    else if ([devicename isEqualToString:@"调光模块"]) {

    }
    else if ([devicename isEqualToString:@"温控器"]) {
    }
    else {
        DeviceDetailVC *vc = [[DeviceDetailVC alloc ] init];
        vc.data = itemData;
        [self.subvc.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - gesture
- (void)handleExitTapGesture:(UITapGestureRecognizer *)recognizer{
    
    [self finishedGroup];
}


//进行分组时，分组界面需要利用书架界面传过来的手势进行处理。
#pragma mark - BookShelfCollectionViewGestureDelegate

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer inGestureView:(UIView*)view{
   
    [self.groupFlowLayout handleLongPressGesture:gestureRecognizer];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer inGestureView:(UIView *)view{
    
    [self.groupFlowLayout handlePanGesture:gestureRecognizer];
}


#pragma mark - exit group view
- (void)finishedGroup{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(finishGroupInGroupViewWithGroupData:)]){
        [self.delegate finishGroupInGroupViewWithGroupData:self.allGroupItems];
    }
}

- (void)cancelGroupWithItemData:(id)itemData withSnapShotView:(UIView *)snapShotView{
    
    NSMutableArray *groupItems = [NSMutableArray arrayWithArray:self.allGroupItems];
    [groupItems removeObject:itemData];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cancelGroupInGroupViewWithItemData:withGroupData:withSnapShotView:)]){
        [self.delegate cancelGroupInGroupViewWithItemData:itemData withGroupData:groupItems withSnapShotView:snapShotView];
    }
}

@end
