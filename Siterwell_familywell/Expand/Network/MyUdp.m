//
//  MyUdp.m
//  TestUdp
//
//  Created by shap on 2017/3/30.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "MyUdp.h"
#import "GCDAsyncUdpSocket.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ESP_NetUtil.h"
#import "AppStatusHelp.h"
#import "DBGatewayManager.h"

static MyUdp *_UDP = nil;

@interface MyUdp()<NSCopying,NSMutableCopying, GCDAsyncUdpSocketDelegate>{
    GCDAsyncUdpSocket  *_asyncUdpSocket;
}
@property (nonatomic, strong) NSData *data;

@end

@implementation MyUdp

+(instancetype)shared{
    if (_UDP == nil) {
        _UDP = [[MyUdp alloc] init];
        [_UDP initUdp];
        
    }
    return _UDP;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_UDP == nil) {
        _UDP = [super allocWithZone:zone];
    }
    return _UDP;
}


-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

- (void)initUdp{
    _asyncUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    [_asyncUdpSocket enableBroadcast:YES error:&err];
    [_asyncUdpSocket bindToPort:1025 error:&err];
    
    if (err) {//监听错误打印错误信息
        NSLog(@"error:%@",err);
    }else {//监听成功则开始接收信息
        [_asyncUdpSocket beginReceiving:&err];
    }
}

- (void)sendGetTokenWithDeviceID:(NSString *)deviceId {
    NSError *err = nil;
    if ([_asyncUdpSocket isClosed]) {
        [_asyncUdpSocket enableBroadcast:YES error:&err];
        [_asyncUdpSocket bindToPort:1025 error:&err];
    }
    [_asyncUdpSocket beginReceiving:&err];
    if (deviceId) {
        NSData *data = [[[@"IOT_KEY?" stringByAppendingString:deviceId] stringByAppendingString:@":SITER1"] dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"\n\n\n\n\n发送到了\%@\n\n\n\n\n",[AppStatusHelp getWifiIP]);
            [_asyncUdpSocket sendData:data toHost:[AppStatusHelp getWifiIP] port:1025 withTimeout:-1 tag:0x00012];
        }
    
}

- (void)sendSwitchServer:(NSString *)ipaddress withDeviceID:(NSString *)deviceId {
    NSError *err = nil;
    if ([_asyncUdpSocket isClosed]) {
        [_asyncUdpSocket enableBroadcast:YES error:&err];
        [_asyncUdpSocket bindToPort:1025 error:&err];
    }
    [_asyncUdpSocket beginReceiving:&err];
    
    NSData *data = [[[@"IOT_SWITCH:" stringByAppendingString:deviceId] stringByAppendingString:@":SITER1"] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"发送切换服务器命令%@",[[@"IOT_SWITCH:" stringByAppendingString:deviceId] stringByAppendingString:@":SITER1"]);
    NSLog(@"\n\n\n\n\n发送IOT_SWITCH到了\%@\n\n\n\n\n",ipaddress);
    [_asyncUdpSocket sendData:data toHost:ipaddress port:1025 withTimeout:-1 tag:0x00012];
}


- (void)sendGetTokenEmptynNew:(NSString *)ipaddress withDeviceID:(NSString *)deviceId {
    NSError *err = nil;
    if ([_asyncUdpSocket isClosed]) {
        [_asyncUdpSocket enableBroadcast:YES error:&err];
        [_asyncUdpSocket bindToPort:1025 error:&err];
    }
    [_asyncUdpSocket beginReceiving:&err];
    NSData *data = [[[@"IOT_KEY?" stringByAppendingString:deviceId] stringByAppendingString:@":SITER1"] dataUsingEncoding:NSUTF8StringEncoding];
    [_asyncUdpSocket sendData:data toHost:ipaddress port:1025 withTimeout:-1 tag:0x00012];
}


- (void)senData:(NSDictionary *)dics{
    NSLog(@"内网发送信息：%@",dics);
    NSError *err = nil;
    if ([_asyncUdpSocket isClosed]) {
        [_asyncUdpSocket enableBroadcast:YES error:&err];
        [_asyncUdpSocket bindToPort:1025 error:&err];
    }
    NSString *str = [self convertToJsonData:dics];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    if ([config objectForKey:@"ipV4"]) {
        NSString *ip = [config objectForKey:@"ipV4"];
            NSLog(@"内网发送目标ip：%@",ip);
        [_asyncUdpSocket sendData:data toHost:ip port:1025 withTimeout:1 tag:0x00012];
    }else{
                    NSLog(@"内网发送目标2ip：%@",[AppStatusHelp getWifiIP]);
        [_asyncUdpSocket sendData:data toHost:[AppStatusHelp getWifiIP] port:1025 withTimeout:1 tag:0x00012];
    }
}

- (void)recvSwitchServerObj:(id)obj Callback:(void(^)(id obj, id data, NSError *error)) block{
    NSObject __weak *sobj = obj;
    
    [RACObserve(self, data) subscribeNext:^(id x) {
        if (sobj) {
            NSString *str = [[NSString alloc] initWithData:x encoding:NSUTF8StringEncoding];
            if ([str rangeOfString:@"ST_answer_OK"].location != NSNotFound) {
                block(sobj,str,nil);
            }
        }
    }];
}

- (void)recvTokenObj:(id)obj Callback:(void(^)(id obj, id data, NSError *error)) block{
    NSObject __weak *sobj = obj;
    
    [RACObserve(self, data) subscribeNext:^(id x) {
        if (sobj) {
            NSString *str = [[NSString alloc] initWithData:x encoding:NSUTF8StringEncoding];
            if ([str rangeOfString:@"NAME:"].location != NSNotFound) {
                block(sobj,str,nil);
            }
        }
    }];
}

- (void)recv:(id)filter obj:(id)obj callback:(void(^)(id obj, id data, NSError *error)) block{
    
    NSObject __weak *sobj = obj;
    @weakify(self)
    [RACObserve(self, data) subscribeNext:^(id x) {
        if (sobj) {
            @strongify(self)
            NSString *receiveStr = [[NSString alloc]initWithData:x encoding:NSUTF8StringEncoding];
            NSLog(@"内网收到数据：%@",receiveStr);
            NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (jsonDict!= nil && [self checkDic:jsonDict WithDic:filter]) {
                block(sobj,jsonDict,nil);
            }
        }
    }];
    

}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{

    
    
    if ([GCDAsyncUdpSocket isIPv4Address:address]) {
        NSString *strAddress = [GCDAsyncUdpSocket hostFromAddress:address];
        NSString *localAddress = [ESP_NetUtil getLocalIPv4];
        
        //NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        if(strAddress  && ![strAddress isEqualToString:localAddress]){
            self.data = data;
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if([str rangeOfString:@"NAME:"].location != NSNotFound && [str rangeOfString:@"BIND:"].location != NSNotFound)
            {
                NSRange startRange1 = [str rangeOfString:@"NAME:"];
                NSRange endRange1 = [str rangeOfString:@"BIND:"];
                NSRange range1 = NSMakeRange(startRange1.location + startRange1.length, endRange1.location - startRange1.location - startRange1.length);
                NSString *result1 = [str substringWithRange:range1];
                result1 = [result1 substringWithRange:NSMakeRange(0, [result1 length] - 1)];
                NSString *devTid = result1;
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                NSString * currentgateway2 = [config objectForKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
                GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
                if ([devTid isEqualToString:gatewaymodel.devTid]) {
                    [config setObject:[GCDAsyncUdpSocket hostFromAddress:address] forKey:@"ipV4"];
                    [config synchronize];
                }
            }else if([str rangeOfString:@"devSend"].location !=NSNotFound){
                   NSLog(@"内网收到原始数据：%@",str);
                 NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                NSString * currentgateway2 = [config objectForKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
                GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
                 NSString *gatewayId = dic[@"params"][@"devTid"];
                
                if ([gatewayId isEqualToString:gatewaymodel.devTid]) {
                    //返回应答
                    NSData *dataa = [@"APP_answer_OK" dataUsingEncoding:NSUTF8StringEncoding];
                    [_asyncUdpSocket sendData:dataa toHost:[GCDAsyncUdpSocket hostFromAddress:address] port:1025 withTimeout:-1 tag:0x00012];
                }
                
            }

        }
    }

}


- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError * _Nullable)error{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config objectForKey:[NSString stringWithFormat:CurrentGateway,[config objectForKey:@"UserName"]]];
    GatewayModel *gatewaymodel = [[DBGatewayManager sharedInstanced] queryForChosedGateway:currentgateway2];
    if(gatewaymodel!=nil){
            [self sendGetTokenWithDeviceID:gatewaymodel.devTid];
    }

}


- (BOOL)checkDic:(NSDictionary *)dic WithDic:(NSDictionary *)dic2{
    __block BOOL flag = YES;
    [dic2 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([[dic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                if (![self checkDic:[dic objectForKey:key] WithDic:obj]) {
                    flag = NO;
                }
            }else{
                flag = NO;
            }
        }else{
            if (![self haveKeyAndObj:dic Key:key obj:obj]) {
                flag = NO;
            }
        }
    }];
    return flag;
}


- (BOOL) haveKeyAndObj:(NSDictionary *)dic Key:(id)skey obj:(id)sobj{
    __block BOOL flag = NO;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqual:skey] && [obj isEqual:sobj]) {
            flag = YES;
        }
    }];
    return flag;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}

@end
