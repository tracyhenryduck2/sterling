//
//  WeekCell.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/10.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef WeekCell_h
#define WeekCell_h
@interface WeekCell : UITableViewCell
@property(copy,nonatomic) NSString *week;
@property(strong,nonatomic) void (^dayCellSelected)(NSInteger tag);

@end

#endif /* WeekCell_h */
