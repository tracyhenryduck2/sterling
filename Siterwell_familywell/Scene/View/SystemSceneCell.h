//
//  SystemSceneCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SystemSceneCell_h
#define SystemSceneCell_h
@interface SystemSceneCell: UITableViewCell
@property (weak, nonatomic) UIView *color;
@property (strong, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIButton *selectSceneBtn;
@property (strong, nonatomic) UIImageView *headerImageView;

@end

#endif /* SystemSceneCell_h */
