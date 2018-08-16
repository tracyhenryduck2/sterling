//
//  BookCollectionViewCell.m
//  ShelfCollectionView
//
//  Created by king.wu on 8/12/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import "BookCollectionViewCell.h"

@interface BookCollectionViewCell ()



@end

@implementation BookCollectionViewCell


+ (instancetype)loadFromNib{

    return [[[NSBundle mainBundle]loadNibNamed:@"BookCollectionViewCell" owner:nil options:nil]objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initCellWithItemData:(ItemData *)itemData{

    
    if([itemData.customTitle isEqualToString:@""]){
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        NSDictionary* names = [dic valueForKey:@"names"];
          self.numberIndexLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString([names objectForKey:itemData.devType], nil) ,[NSString stringWithFormat:@"%ld",itemData.devID]];
    }else{
        self.numberIndexLabel.text = itemData.customTitle;
    }
    self.mainImageView.image = [UIImage imageNamed:itemData.image];

}

- (void)prepareForReuse{
    [self.numberIndexLabel setText:@""];
}

@end
