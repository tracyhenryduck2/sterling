//
//  TimerToModeCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef TimerToModeCell_h
#define TimerToModeCell_h
@interface TimerToModeCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIPickerView *pickview;
@property(nonatomic,strong) NSMutableArray *modelist;
@end

#endif /* TimerToModeCell_h */
