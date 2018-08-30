//
//  Encryptools.m
//  sHome
//
//  Created by TracyHenry on 2018/8/15.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "Encryptools.h"

@implementation Encryptools

+(int)getDescryption:(int)input withMsgId:(int)msgid{
    
    int a = input ^ 0x1234;
    a= a ^ msgid;
    a = ~a;
    int output = 65536 + a ;
    Byte ds = (Byte)output;
    return ds;
}
@end
