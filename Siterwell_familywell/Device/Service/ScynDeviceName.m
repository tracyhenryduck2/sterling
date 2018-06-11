//
//  ScynDeviceName.m
//  sHome
//
//  Created by shap on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ScynDeviceName.h"
#import "ItemData.h"
#import "BatterHelp.h"

@implementation ScynDeviceName
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSMutableArray *_deviceArray;
    NSString *_connecthost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Device:(NSMutableArray *)deviceArray ConnectHost:(NSString *)connecthost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _deviceArray = deviceArray;
        _connecthost = connecthost;
    }
    return self;
}

-(NSString *)getCRCContent{
    
    int maxId = 0;
    for (ItemData *data in _deviceArray) {
        if (data.devID && data.devID > maxId) {
            maxId = (int)data.devID ;
        }
    }
    NSString *content = @"";
    content = [NSString stringWithFormat:@"%@",[BatterHelp gethexBybinary:(maxId*2 +2)]];
    int length = (int)content.length;
    
    for (int i = 0; i < 4 - length; i++) {
        content = [@"0" stringByAppendingString:content];
    }
    
    for (int i = 1 ; i<=maxId; i++) {
        bool hasDevice = NO;
        for (ItemData *data in _deviceArray) {
            if (data.devID && data.devID == i) {
                
                NSString *name = data.customTitle;

                if([name isEqualToString:@""]){
                    content = [content stringByAppendingString:@"0000"];
                    hasDevice = YES;
                    break;
                }else{
                    NSString *nameString = @"";
                    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    NSData *namedata = [name dataUsingEncoding:enc];
                    NSInteger countf = 15 - namedata.length;
                    for(int i = 0 ; i < countf ; i++){
                        nameString = [nameString stringByAppendingString:@"@"];
                    }
                    name = [NSString stringWithFormat:@"%@%@%@",nameString,name,@"$"];
                    namedata = [name dataUsingEncoding:enc];
                    name = [self convertDataToHexStr:namedata];
                    
                    
                    unsigned char byte[name.length];
                    
                    int j=0;
                    
                    for(int i=0; i<[name length]; i++)
                    {
                        byte[j] = [name characterAtIndex:i];
                        j++;
                    }
                    
                    name = [BatterHelp getCRCCode:byte lenght:(int)name.length];
                    
                    content = [content stringByAppendingString:name];
                    hasDevice = YES;
                    break;
                }

            }
        }
        if (!hasDevice) {
            content = [content stringByAppendingString:@"0000"];
        }
    }
    
    return content;
}

- (id)requestArgumentCommand {
    return @{
             @"action": @"appSend",
             @"params": @{
                     @"devTid": _devTid,
                     @"ctrlKey": _ctrlKey,
                     @"data": @{
                             @"cmdId":@30,
                             @"answer_content":[self getCRCContent]
                             }
                     }
             };
}

- (NSString *)requestArgumentHost{
    return _connecthost;
}

- (NSString *)convertDataToHexStr:(NSData *)data {
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
