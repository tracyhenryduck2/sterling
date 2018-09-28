//
//  TimerSwitchCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef TimerSwitchCell_h
#define TimerSwitchCell_h
@interface TimerSwitchCell:UITableViewCell

@property (strong, nonatomic) void (^click)(int tag);
-(void)setWeek:(NSString *)week;
@end

#endif /* TimerSwitchCell_h */
