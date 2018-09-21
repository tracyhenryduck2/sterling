//
//  PickViewCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/10.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef PickViewCell_h
#define PickViewCell_h
@interface PickViewCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIPickerView *pickview;

@end

#endif /* PickViewCell_h */
