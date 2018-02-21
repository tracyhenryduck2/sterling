//
//  UITableView+NoData.h
//  HuanBao
//
//  Created by shaop on 16/8/26.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(NoData)

-(void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
