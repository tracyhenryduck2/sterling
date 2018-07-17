//
//  SystemSceneModel.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SystemSceneModel.h"
#import "BatterHelp.h"
@implementation SystemSceneModel

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    
    if (self = [super initWithDictionary:dict error:err]) {
        if (self.answer_content.length >= 32) {
            self.systemname = [self getNameFromContent];
            self.sid = [self getSidFromContent];
            self.color = [self getSceneColor];
        }
    }
    return self;
}


- (NSString *)getNameFromContent{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *nameString = [self.answer_content substringWithRange:NSMakeRange(6, 32)];
    NSData *data = [self hexStringToData:nameString];
    NSString *result = [[NSString alloc] initWithData:data encoding:enc];
    result = [result stringByReplacingOccurrencesOfString:@"@" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"$" withString:@""];
    return result;
}

- (NSString *)getSidFromContent{
    NSString *mid = [self.answer_content substringWithRange:NSMakeRange(4, 2)];
    
    mid = [NSString stringWithFormat:@"%lu",strtoul([[mid substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
    
    return mid;
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

- (NSString *)getSceneColor{
    
    NSNumber *count = [BatterHelp numberHexString:[self.answer_content substringWithRange:NSMakeRange(38, 4)]];
    
    int lenth = [count intValue]*2;
    
    if (self.answer_content!=nil&&(38 + 4 + lenth) < [self.answer_content length]) {
        
        NSString *color = [self.answer_content substringWithRange:NSMakeRange(38 + 4 + lenth, 2)];
        
        NSString *colors = @"F0F1F2F3F4F5F6F7F8";
        if ([colors rangeOfString:color].location != NSNotFound) {
            return color;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

@end
