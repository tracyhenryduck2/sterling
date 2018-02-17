//
//  UITableView+NoData.m
//  HuanBao
//
//  Created by shaop on 16/8/26.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "UITableView+NoData.h"

@implementation UITableView(NoData)

-(void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount{
    if (rowCount == 0) {
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
                
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


@end
