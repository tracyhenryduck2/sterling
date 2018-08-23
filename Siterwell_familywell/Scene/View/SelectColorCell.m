//
//  SelectColorCell.m
//  sHome
//
//  Created by Apple on 2017/6/4.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SelectColorCell.h"
#import "colorItemCell.h"

@implementation SelectColorCell
{
    NSArray *colors;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    colors = @[[UIImage imageNamed:@"nocolore_sk"], HEXCOLOR(0x33a7ff), HEXCOLOR(0xc968ed), HEXCOLOR(0xf067bb), HEXCOLOR(0x53f6ab), HEXCOLOR(0xa5f7b2), HEXCOLOR(0xf56735), HEXCOLOR(0x4d94ff), HEXCOLOR(0x11da28)];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    self.colorsView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
    self.colorsView.backgroundColor = [UIColor whiteColor];
    [self.colorsView registerClass:[colorItemCell class] forCellWithReuseIdentifier:@"colorItemCell"];
    self.colorsView.delegate = self;
    self.colorsView.dataSource = self;
    self.colorsView.scrollEnabled = NO;
    [self.contentView addSubview:self.colorsView];
    [self.colorsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    colorItemCell *cell = (colorItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"colorItemCell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];
    cell.baseColorView.layer.borderWidth = 1.0;
    cell.baseColorView.layer.borderColor = [UIColor whiteColor].CGColor;
    if (_oldIndexPath != nil&&_oldIndexPath.row == indexPath.row) {
        cell.baseColorView.layer.borderColor = RGB(255, 0, 0).CGColor;
        _oldIndexPath = indexPath;
    }
    
    if ([[colors objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]) {
        
        [cell.colorImageView setImage:[UIImage imageNamed:@"nocolore_sk"]];
        
    }else{
        cell.colorImageView.image = nil;
        cell.colorImageView.backgroundColor = [colors objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(Main_Screen_Width/5-10),35.0f};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 10,5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
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

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    colorItemCell *oldCell = (colorItemCell*)[collectionView cellForItemAtIndexPath:_oldIndexPath];
    oldCell.baseColorView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    colorItemCell *cell = (colorItemCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.baseColorView.layer.borderColor = RGB(255, 0, 0).CGColor;
    
    _oldIndexPath = indexPath;
    
    [self selectedColor:indexPath];
}

- (void)selectedColor:(NSIndexPath*)indexPath{
    
    NSString *colorSelected = @"F8";
    switch (indexPath.row) {
        case 0:
            colorSelected = @"F8";
            break;
        case 1:
            colorSelected = @"F1";
            break;
        case 2:
            colorSelected = @"F2";
            break;
        case 3:
            colorSelected = @"F3";
            break;
        case 4:
            colorSelected = @"F4";
            break;
        case 5:
            colorSelected = @"F5";
            break;
        case 6:
            colorSelected = @"F6";
            break;
        case 7:
            colorSelected = @"F7";
            break;
        case 8:
            colorSelected = @"F0";
            break;
            
        default:
            break;
    }
    self.colorSelected(colorSelected);
}

//编辑时默认值设置
- (void)setCurrtetColor:(NSString *)currtetColor{
    
    NSIndexPath *indexPath = nil;
    
    if ([currtetColor isEqualToString:@"00"]&&currtetColor ==nil) {
        
    }else if ([currtetColor isEqualToString:@"F8"]) {
        
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
    }else if ([currtetColor isEqualToString:@"F1"]){
        
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
    }else if ([currtetColor isEqualToString:@"F2"]){
        
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        
    }else if ([currtetColor isEqualToString:@"F3"]){
        
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        
    }else if ([currtetColor isEqualToString:@"F4"]){
        
        indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        
    }else if ([currtetColor isEqualToString:@"F5"]){
        
        indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        
    }else if ([currtetColor isEqualToString:@"F6"]){
        
        indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        
    }else if ([currtetColor isEqualToString:@"F7"]){
        
        indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        
    }else if ([currtetColor isEqualToString:@"F0"]){
        
        indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
        
    }
    
    _oldIndexPath = indexPath;
    
    [self.colorsView reloadData];
    
}

@end
