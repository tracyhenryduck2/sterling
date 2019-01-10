//
//  SceneCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SceneCell_h
#define SceneCell_h

@protocol CLickBtndelegate;
@interface SceneCell:UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *clickBtn;
@property (strong, nonatomic) id<CLickBtndelegate> clickdelegate;
@end


@protocol CLickBtndelegate

-(void) clickfor:(NSInteger)index;
@end
#endif /* SceneCell_h */
