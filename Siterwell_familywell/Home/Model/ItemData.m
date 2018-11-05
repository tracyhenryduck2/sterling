//
//  ItemData.m
//  ShelfCollectionView
//
//  Created by king.wu on 8/18/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import "ItemData.h"
#import "BatterHelp.h"

@interface ItemData()

@end

@implementation ItemData


-(instancetype) initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    
    if(self=[super initWithDictionary:dict error:err]){

    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title DevID:(NSInteger)devID DevType:(NSString *)devtype Code:(NSString *)code{
    self = [super init];
    if (self){
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"device" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        _names = [dic valueForKey:@"names"];
        _pictures = [dic valueForKey:@"pictures"];

        self.customTitle = title;
        self.device_ID = [NSNumber numberWithInteger: devID];
        self.device_status = code;
        self.device_name = devtype;
        self.image = [self getImage:code name:devtype];

    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder

{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    free(ivars);
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
            
        }
        free(ivars);
    } 
    return self;
}

- (NSString *)getImage:(NSString *)status name:(NSString *)devtype {
    if (status.length ==8 && devtype.length == 4) {
        NSString *battery = [status substringWithRange:NSMakeRange(2, 2)];
        NSString *switchStatus = [status substringWithRange:NSMakeRange(6, 2)];
        status = [status substringWithRange:NSMakeRange(4, 2)];
        
        if ([[_names objectForKey:devtype] isEqualToString:@"智能插座"]) {
            if ([switchStatus isEqualToString:@"01"]) {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"bj"];
            } else if ([switchStatus isEqualToString:@"00"]) {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"aq"];
            } else {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"no"];
            }
        }
        else if ([[_names objectForKey:devtype]  isEqualToString:@"双路开关"]) {
            if ([switchStatus isEqualToString:@"00"]) {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"aq"];
            } else if ([switchStatus isEqualToString:@"01"] || [switchStatus isEqualToString:@"02"] || [switchStatus isEqualToString:@"03"]) {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"bj"];
            } else {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"no"];
            }
        }
        else if ([[_names objectForKey:devtype]  isEqualToString:@"温湿度探测器"]) {
            if ([[BatterHelp numberHexString:switchStatus] intValue] > 100) {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"no"];
            } else {
                if ([[BatterHelp getBatterFormDevice:battery] intValue] <= 15) {
                    return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"gz"];
                } else {
                    return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"aq"];
                }
            }
        }
        else if ([[_names objectForKey:devtype]  containsString:@"调光模块"]) {
            if ([[BatterHelp numberHexString:switchStatus] intValue] > 100 || [[BatterHelp numberHexString:switchStatus] intValue] < 0) {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"no"];
            } else {
                if ([[BatterHelp getBatterFormDevice:battery] intValue] <= 15) {
                    return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"gz"];
                } else {
                    return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"aq"];
                }
            }
        }
        
        else if ([status isEqualToString:@"66"]||
                 [status isEqualToString:@"50"]||
                 
                 [status isEqualToString:@"17"]||
                 [status isEqualToString:@"18"]||
                 [status isEqualToString:@"19"]||
                 [status isEqualToString:@"1A"]||
                 [status isEqualToString:@"1B"]||
                 [status isEqualToString:@"BB"]||
                 
                 [status isEqualToString:@"10"]||
                 [status isEqualToString:@"20"]||
                 [status isEqualToString:@"30"]||
                 [status isEqualToString:@"51"]||
                 [status isEqualToString:@"52"]||
                 [status isEqualToString:@"53"]  ){
            return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"bj"];
        }
        else if ([status isEqualToString:@"55"] || [status isEqualToString:@"56"]) {
            if ([[_names objectForKey:devtype]  isEqualToString:@"门锁"]) {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"aq"];
            } else {
                return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"bj"];
            }
        }
        
        else if (([status isEqualToString:@"11"]||
                  [status isEqualToString:@"12"]||
                  [status isEqualToString:@"13"]||
                  [status isEqualToString:@"14"]||
                  [status isEqualToString:@"15"]||
                  [status isEqualToString:@"16"]) && ([[_names objectForKey:devtype]  isEqualToString:@"复合型烟感"]) ) {
            return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"gz"];
        }
        
        else if ([status isEqualToString:@"AA"] || [status isEqualToString:@"01"] || [status isEqualToString:@"02"] || [status isEqualToString:@"04"] || [status isEqualToString:@"08"] || [status isEqualToString:@"60"] || [status isEqualToString:@"AB"]){
            //电量
            if (![battery isEqualToString:@"80"] && ![battery isEqualToString:@"64"]) {
                battery = [BatterHelp getBatterFormDevice:battery];
                if ([battery intValue] <= 15) {
                    return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"gz"];
                } else {
                    return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"aq"];
                }
            }
            
            return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"aq"];
        }
        else if([[_names objectForKey:devtype]  containsString:@"温控器"]){
            
                battery = [BatterHelp getBatterFormDevice:battery];
                if ([battery intValue] <= 15) {
                    return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"gz"];
                } else {
                    int ds = [[BatterHelp numberHexString:status] intValue];
                    int sta = (0x1F) & ds;
                    if(sta>=5 && sta <=30){
                        return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"aq"];
                    }else{
                         return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"no"];
                    }
                }
            
            
        }
        else if ([status isEqualToString:@"40"]) {
            return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"gz"];
        }
        else {
            return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"no"];
        }
    }
    return [NSString stringWithFormat:[_pictures objectForKey:devtype],@"no"];
}


@end

