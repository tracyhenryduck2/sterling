//
//  ModelListVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/7.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ModelListVC.h"
#import "AddSceneCell.h"
#import "SceneListItemData.h"
#import "DBDeviceManager.h"
#import "ItemDataHelp.h"
#import "SetTimeController.h"
#import "SetDelayController.h"

@interface ModelListVC()
@property (nonatomic,strong) NSMutableArray <SceneListItemData *>* itemDatas;

@end

@implementation ModelListVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    _itemDatas = [[NSMutableArray alloc] init];
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    if(_IsInput){
        SceneListItemData *item1 = [[SceneListItemData alloc] init];
        item1.title = @"定时";
        item1.custmTitle = NSLocalizedString(@"定时", nil);
        item1.type = @"time";
        item1.image = @"blue_clock_icon";
        [_itemDatas addObject:item1];
        
        SceneListItemData *item2 = [[SceneListItemData alloc] init];
        item2.title = @"点击执行";
        item2.type = @"click";
        item2.custmTitle = NSLocalizedString(@"点击执行", nil);
        item2.image = @"blue_hand_icon";
        [_itemDatas addObject:item2];
       NSMutableArray *deviceArray = [[DBDeviceManager sharedInstanced] queryAllDevice:currentgateway2];
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"enableShowDevice" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        NSArray *array = dic[@"inDevice"];
        NSString *namePath2 = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
        NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:namePath2];
        NSDictionary *dic_name = [dic2 objectForKey:@"names"];
        for (ItemData *model in deviceArray) {
            
            for (NSString *name in array) {

                if ([[dic_name objectForKey:model.device_name] isEqualToString:name]) {
                    SceneListItemData *item = [ItemDataHelp ItemDataToSceneListItemData:model];
                    [_itemDatas addObject:item];
                    break;
                }
            }
        }
    }else{
        SceneListItemData *item1 = [[SceneListItemData alloc] init];
        item1.title = @"手机通知";
        item1.type = @"phone";
        item1.custmTitle = NSLocalizedString(@"手机通知", nil);
        item1.image = @"blue_phone_icon";
        [_itemDatas addObject:item1];
        
        SceneListItemData *item2 = [[SceneListItemData alloc] init];
        item2.title = @"延时";
        item1.type = @"delay";
        item2.custmTitle = NSLocalizedString(@"延时", nil);
        item2.image = @"blue_ys_icon";
        [_itemDatas addObject:item2];
        NSMutableArray *deviceArray = [[DBDeviceManager sharedInstanced] queryAllDevice:currentgateway2];
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"enableShowDevice" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        NSArray *array = dic[@"outDevice"];
        NSString *namePath2 = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
        NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:namePath2];
        NSDictionary *dic_name = [dic2 objectForKey:@"names"];
        for (ItemData *model in deviceArray) {
            
            for (NSString *name in array) {
                
                if ([[dic_name objectForKey:model.device_name] isEqualToString:name]) {
                    SceneListItemData *item = [ItemDataHelp ItemDataToSceneListItemData:model];
                    [_itemDatas addObject:item];
                    break;
                }
            }
        }
    }
    [self initview];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)initview{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    self.datalistView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.datalistView.backgroundColor = [UIColor whiteColor];
    [self.datalistView registerClass:[AddSceneCell class] forCellWithReuseIdentifier:@"addsceneItemCell"];
    self.datalistView.delegate = self;
    self.datalistView.dataSource = self;
    self.datalistView.scrollEnabled = NO;
    [self.view addSubview:self.datalistView];
    [self.datalistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemDatas.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddSceneCell *cell = (AddSceneCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"addsceneItemCell" forIndexPath:indexPath];
    SceneListItemData *data = [_itemDatas objectAtIndex:indexPath.row];
    cell.image_custom.image = [UIImage imageNamed:data.image];
    cell.customtitle.text = data.custmTitle;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SceneListItemData *data = [_itemDatas objectAtIndex:indexPath.row];
    if([data.type isEqualToString:@"click"]){
        if (_delegate) {
                    [_delegate sendNext:data];
            }
        [self.navigationController popViewControllerAnimated:YES];
    }else if([data.type isEqualToString:@"time"]){
        SetTimeController *vc = [[SetTimeController alloc] init];
        vc.title = NSLocalizedString(@"定时", nil);
        [self.navigationController pushViewController:vc animated:YES];
    }else if([data.type isEqualToString:@"delay"]){
        SetDelayController *vc = [[SetDelayController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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



@end
