//
//  NameHelper.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/31.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "NameHelper.h"

@implementation NameHelper

+(NSString *) getASCIIFromName:(NSString *)name {
    

    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *namedata = [name dataUsingEncoding:enc];
    
    NSInteger countf = 15 - namedata.length;
    NSString *nameString = @"";
    for(int i = 0 ; i < countf ; i++){
        nameString = [nameString stringByAppendingString:@"@"];
    }
    name = [NSString stringWithFormat:@"%@%@%@",nameString,name,@"$"];
    namedata = [name dataUsingEncoding:enc];
    
    return [self convertDataToHexStr:namedata];
}

+(NSString *) getNameFromASCII:(NSString *)Ascii {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSData *data = [BatterHelp hexStringToData:Ascii];
    NSString *result = [[NSString alloc] initWithData:data encoding:enc];
    result = [result stringByReplacingOccurrencesOfString:@"@" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"$" withString:@""];
    return result;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

@end
