//
//  ScynDeviceApi.m
//  sHome
//
//  Created by shaop on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ScynDeviceApi.h"
#import "DeviceModel.h"
#import "BatterHelp.h"

@implementation ScynDeviceApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSArray *_deviceArray;
    NSString *_connectHost;
}

-(id)initWithDrivce:(NSString *)devTid andCtrlKey:(NSString *)ctrlkey DeviceStatus:(NSArray *)device_status ConnectHost:(NSString *)connecthost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlkey;
        _deviceArray = device_status;
        _connectHost = connecthost;
    }
    return self;
}


-(NSString *)getCRCContent{
    
    int maxId = 0;
    for (DeviceModel *data in _deviceArray) {
        if ([data.device_ID intValue] > maxId) {
            maxId = [data.device_ID intValue];
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
        for (DeviceModel *data in _deviceArray) {
            if ([data.device_ID intValue] == i) {
                NSString * name = [BatterHelp getDeviceCRCCode:data.device_status];
                
                content = [content stringByAppendingString:name];
                hasDevice = YES;
                break;
            }
        }
        if (!hasDevice) {
            content = [content stringByAppendingString:@"0000"];
        }
    }
    
    return content;
}

-(id)requestArgumentConnectHost{
    return _connectHost;
}


-(id)requestArgumentCommand{
    return @{
             @"action":@"appSend",
             @"params": @{
                     @"devTid":_devTid,
                     @"ctrlKey":_ctrlKey,
                     @"data":@{
                             @"cmdId":@29,
                             @"device_status":[self getCRCContent]
                             }
                     }
             };
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
