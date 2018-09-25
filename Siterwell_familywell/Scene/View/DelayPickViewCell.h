//
//  DelayPickViewCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/10.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DelayPickViewCell_h
#define DelayPickViewCell_h
@interface DelayPickViewCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIPickerView *pickview;

@end

#endif /* PickViewCell_h */
