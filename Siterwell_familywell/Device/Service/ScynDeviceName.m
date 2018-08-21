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
        if (data.device_ID && [data.device_ID intValue] > maxId) {
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
        for (ItemData *data in _deviceArray) {
            if (data.device_ID && [data.device_ID intValue] == i) {
                
                NSString *name = data.customTitle;

                if([name isEqualToString:@""]){
                    content = [content stringByAppendingString:@"0000"];
                    hasDevice = YES;
                    break;
                }else{
                    name = [NameHelper getASCIIFromName:name];
                
                    
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
                             @"cmdId":@SyncDeviceName,
                             @"answer_content":[self getCRCContent]
                             }
                     }
             };
}

- (id)requestArgumentConnectHost{
    return _connecthost;
}



@end
