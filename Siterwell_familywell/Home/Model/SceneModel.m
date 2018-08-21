//
//  SceneModel.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneModel.h"
#import "BatterHelp.h"
#import "SceneListItemData.h"
#import "DBDeviceManager.h"
#import "ItemDataHelp.h"
@implementation SceneModel

-(instancetype) initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    
    if(self=[super initWithDictionary:dict error:err]){
        if(self.scene_content.length>38){
            self.scene_name = [self getNameFromConetent];
        }
    }
    return self;
}

- (NSString *)getNameFromConetent{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *nameString = [self.scene_content substringWithRange:NSMakeRange(6, 32)];
    NSData *data = [self hexStringToData:nameString];
    NSString *result = [[NSString alloc] initWithData:data encoding:enc];
    result = [result stringByReplacingOccurrencesOfString:@"@" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"$" withString:@""];
    return result;
}

- (NSData *)hexStringToData:(NSString *)hexString {
    int j=0;
    Byte bytes[16];
    ///3ds key的Byte 数组， 128位
    for(int i=0; i<[hexString length]; i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:16];
    
    return newData;
}

+ (NSString *)getCRCFromContent:(NSString *)answer_content{
    
    if(answer_content.length <= 38){
        return @"0000";
    }else{
        
        int totalLengrh = (int)strtoul([[answer_content substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16);
        unsigned char byte[totalLengrh];
        byte[0] = (unsigned char)strtoul([[answer_content substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
        byte[1] = (unsigned char)strtoul([[answer_content substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16);
        byte[2] = (unsigned char)strtoul([[answer_content substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
        
        int j=3;
        
        NSString *name = [answer_content substringWithRange:NSMakeRange(6, 32)];
        for(int i=0; i<[name length]; i++)
        {
            byte[j] = [name characterAtIndex:i];
            j++;
        }
        
        NSString *status = [answer_content substringWithRange:NSMakeRange(38, answer_content.length - 38)];
        for (int i = 0; i < status.length/2; i++) {
            byte[j] = (unsigned char)strtoul([[status substringWithRange:NSMakeRange(i*2, 2)] UTF8String],0,16);
            j++;
        }
        
        NSString *content = [BatterHelp getCRCCode:byte lenght:totalLengrh];
        
        return content;
    }
    
}

- (NSMutableArray *)getInDeviceArray:(NSString *)devTid{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *week = [self.scene_content substringWithRange:NSMakeRange(40, 2)];
    NSString *hour = [self.scene_content substringWithRange:NSMakeRange(42, 2)];
    NSString *minute = [self.scene_content substringWithRange:NSMakeRange(44, 2)];
    
    if (![week isEqualToString:@"00"]) {
        SceneListItemData *timeItem = [[SceneListItemData alloc] init];
        timeItem.week = week;
        timeItem.hour = [NSString stringWithFormat:@"%ld",strtoul([hour UTF8String],0,16)];
        timeItem.minute = [NSString stringWithFormat:@"%ld",strtoul([minute UTF8String],0,16)];
        timeItem.image = @"blue_clock_icon";
        timeItem.type = @"time";
        timeItem.custmTitle = [NSString stringWithFormat:@"%@:%@",timeItem.hour,timeItem.minute];
        [array addObject:timeItem];
    }
    
    NSString *click = [self.scene_content substringWithRange:NSMakeRange(46, 2)];
    if ([click isEqualToString:@"AB"]) {
        SceneListItemData *clickItem = [[SceneListItemData alloc] init];
        clickItem.type = @"click";
        clickItem.image = @"blue_hand_icon";
        clickItem.custmTitle = NSLocalizedString(@"点击执行", nil);
        self.isShouldClick = @"AB";
        [array addObject:clickItem];
    }else{
        self.isShouldClick = @"00";
    }
    
    NSString *number = [self.scene_content substringWithRange:NSMakeRange(50, 2)];
    int deviceNumber = (int)strtoul([number UTF8String],0,16);
    for (int i = 0; i<deviceNumber; i++) {
        NSString *deviceString = [self.scene_content substringWithRange:NSMakeRange(54+(i*12), 12)];
        NSString *deviceId = [deviceString substringWithRange:NSMakeRange(0, 4)];
        NSInteger device_ID = strtoul([deviceId UTF8String],0,16);
        NSString *deviceCount = [deviceString substringWithRange:NSMakeRange(4, 8)];
        ItemData *devicemodel = [[DBDeviceManager sharedInstanced] queryDeviceModel:[NSNumber numberWithInteger:device_ID] withDevTid:devTid];
        SceneListItemData *deviceItem = [ItemDataHelp ItemDataToSceneListItemData:devicemodel];
        deviceItem.action = deviceCount;
        [array addObject:deviceItem];
    }
    
    return array;
}

- (NSMutableArray *)getOutDeviceArray:(NSString *)devTid{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    //通知
    NSString *noti = [self.scene_content substringWithRange:NSMakeRange(48, 2)];
    if ([noti isEqualToString:@"AC"]) {
        SceneListItemData *clickItem = [[SceneListItemData alloc] init];
        clickItem.type = @"phone";
        clickItem.custmTitle = NSLocalizedString(@"手机通知", nil);
        clickItem.image = @"blue_phone_icon";
        [array addObject:clickItem];
    }
    
    NSString *out_number = [self.scene_content substringWithRange:NSMakeRange(50, 2)];
    int out_deviceNumber = (int)strtoul([out_number UTF8String],0,16);
    
    NSString *number = [self.scene_content substringWithRange:NSMakeRange(52, 2)];
    int deviceNumber = (int)strtoul([number UTF8String],0,16);
    
    for (int i = 0; i<deviceNumber; i++) {
        NSString *deviceString = [self.scene_content substringWithRange:NSMakeRange(54+(12*(out_deviceNumber))+(i*16), 16)];
        
        NSString *minute = [deviceString substringWithRange:NSMakeRange(0, 2)];
        NSString *second = [deviceString substringWithRange:NSMakeRange(2, 2)];
        
        if (![minute isEqualToString:@"00"] || ![second isEqualToString:@"00"]) {
            SceneListItemData *delyItem = [[SceneListItemData alloc] init];
            delyItem.minute = [NSString stringWithFormat:@"%ld",strtoul([minute UTF8String],0,16)];
            delyItem.second = [NSString stringWithFormat:@"%ld",strtoul([second UTF8String],0,16)];
            delyItem.image = @"blue_ys_icon";
            delyItem.custmTitle = [NSString stringWithFormat:@"%@:%@",delyItem.minute,delyItem.second];
            [array addObject:delyItem];
        }
        NSString *deviceId = [deviceString substringWithRange:NSMakeRange(4, 4)];
        NSInteger deviceId2 =strtoul([deviceId UTF8String],0,16);
        NSString *deviceCount = [deviceString substringWithRange:NSMakeRange(8, 8)];
        if ([deviceId isEqualToString:@"0"]) {
            SceneListItemData *deviceItem = [[SceneListItemData alloc] init];
            deviceItem.type = @"gateway";
            deviceItem.eqid = [NSNumber numberWithInt:0];
            deviceItem.custmTitle = NSLocalizedString(@"网关", nil);
            deviceItem.action = deviceCount;
              [array addObject:deviceItem];
            
        }else{
            ItemData * data = [[DBDeviceManager sharedInstanced] queryDeviceModel:[NSNumber numberWithInteger:deviceId2] withDevTid:devTid];
            SceneListItemData *deviceItem = [ItemDataHelp ItemDataToSceneListItemData:data];
            deviceItem.action = deviceCount;
            [array addObject:deviceItem];
        }

    }
    
    return array;
}

@end
