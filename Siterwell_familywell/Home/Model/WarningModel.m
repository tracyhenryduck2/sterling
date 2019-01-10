//
//  WarningModel.m
//  sHome
//
//  Created by CY on 2017/11/25.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "WarningModel.h"

@implementation WarningModel

+(NSString *)getAlertWithDevType:(NSString *)type status:(NSString *) statusa{
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    dic = [dic objectForKey:@"names"];
    NSString *battery = [statusa substringWithRange:NSMakeRange(2, 2)];
    NSString *status = [statusa substringWithRange:NSMakeRange(4, 2)];
    if([@"门磁" isEqualToString:[dic objectForKey:type]]){
        if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"门打开", nil);
        }else if([@"AA" isEqualToString:status]){
            if([[BatterHelp numberHexString:battery] integerValue] <= 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"门关闭", nil);
            }
        }else if([@"66" isEqualToString:status]){
            return  NSLocalizedString(@"门没有关", nil);
        }else if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] <= 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    } else if([@"SOS按钮" isEqualToString:[dic objectForKey:type]]){
        if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"求救", nil);
        }else if([@"66" isEqualToString:status] || [@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else if([@"AA" isEqualToString:status]){
            if([[BatterHelp numberHexString:battery] integerValue] <= 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"正常", nil);
            }
        }else{
            if([[BatterHelp numberHexString:battery] integerValue] <= 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"PIR探测器" isEqualToString:[dic objectForKey:type]]){
        if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"有人移动报警", nil);
        }else if([@"AA" isEqualToString:status]){
            if([[BatterHelp numberHexString:battery] integerValue] <= 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"正常", nil);
            }
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            if([[BatterHelp numberHexString:battery] integerValue] <= 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"SM报警器" isEqualToString:[dic objectForKey:type]]){
        if([@"BB" isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] <= 15 && [@"AA" isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"CO报警器" isEqualToString:[dic objectForKey:type]]){
        if([@"BB" isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] <= 15 && [@"AA" isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"水感报警器" isEqualToString:[dic objectForKey:type]]){
        if([@"BB" isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] <= 15 && [@"AA" isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"温湿度探测器" isEqualToString:[dic objectForKey:type]]){
        if([@"AA" isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] <= 15){
            return NSLocalizedString(@"低电压", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"复合型烟感" isEqualToString:[dic objectForKey:type]]){
        if([@"17" isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([@"19" isEqualToString:status]){
            return  NSLocalizedString(@"火灾报警", nil);
        }else if([@"12" isEqualToString:status]){
            return  NSLocalizedString(@"故障", nil);
        }else if([@"15" isEqualToString:status]){
            return  NSLocalizedString(@"免打扰", nil);
        }else if([@"1B" isEqualToString:status]){
            return  NSLocalizedString(@"静音", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            if([@"AA" isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] <= 15){
                return NSLocalizedString(@"低电压", nil);
            }else
                return NSLocalizedString(@"报警", nil);
        }
    }else if([@"气体探测器" isEqualToString:[dic objectForKey:type]]){
        if([@"BB" isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] <= 15 && [@"AA" isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"热感报警器" isEqualToString:[dic objectForKey:type]]){
        if([@"BB" isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] <= 15 && [@"AA" isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"情景开关" isEqualToString:[dic objectForKey:type]]){
        if([@"55" isEqualToString:status]){
            return  NSLocalizedString(@"求救", nil);
        }else if([@"66" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else{
            if([@"AA" isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] <= 15){
                return NSLocalizedString(@"低电压", nil);
            }else
                return NSLocalizedString(@"报警", nil);
        }
    }else if([@"门锁" isEqualToString:[dic objectForKey:type]]){
        if([@"50" isEqualToString:status]){
            return  NSLocalizedString(@"开锁", nil);
        }else if([@"51" isEqualToString:status]){
            return  NSLocalizedString(@"密码开锁", nil);
        }else if([@"52" isEqualToString:status]){
            return  NSLocalizedString(@"卡开锁", nil);
        }else if([@"53" isEqualToString:status]){
            return  NSLocalizedString(@"指纹开锁", nil);
        }else if([@"10" isEqualToString:status]){
            return  NSLocalizedString(@"非法操作", nil);
        }else if([@"20" isEqualToString:status]){
            return  NSLocalizedString(@"强拆", nil);
        }else if([@"30" isEqualToString:status]){
            return  NSLocalizedString(@"胁迫", nil);
        }else if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else{
            if([@"AA" isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] <= 15){
                return NSLocalizedString(@"低电压", nil);
            }else
                return NSLocalizedString(@"报警", nil);
        }
    }else if([@"智能插座" isEqualToString:[dic objectForKey:type]]){
        if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"双路开关" isEqualToString:[dic objectForKey:type]]){
        if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"按键" isEqualToString:[dic objectForKey:type]]){
        if([@"AA" isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] <= 15){
            return NSLocalizedString(@"低电压", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"调光模块" isEqualToString:[dic objectForKey:type]]){
        if([@"AA" isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] <= 15){
            return NSLocalizedString(@"低电压", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else{
        return NSLocalizedString(@"报警", nil);
    }
}



@end
