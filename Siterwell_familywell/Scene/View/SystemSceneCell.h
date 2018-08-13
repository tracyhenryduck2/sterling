//
//  SystemSceneCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SystemSceneCell_h
#define SystemSceneCell_h

@protocol CLickdelegate;
@interface SystemSceneCell: UITableViewCell
@property (strong, nonatomic) UIView *color;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *selectSceneBtn;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) id<CLickdelegate> clickdelegate;
@end

@protocol CLickdelegate

-(void) click:(NSInteger)index;
@end
#endif /* SystemSceneCell_h */
