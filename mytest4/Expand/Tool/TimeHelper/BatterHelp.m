//
//  BatterHelp.m
//  sHome
//
//  Created by shaop on 2017/1/19.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BatterHelp.h"

@implementation BatterHelp

static unsigned char auchCRCHi[] = {
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
    0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1,
    0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1,
    0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40,
    0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1,
    0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40,
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
    0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40,
    0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1,
    0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
    0x80, 0x41, 0x00, 0xC1, 0x81, 0x40
};

static unsigned char auchCRCLo[] = {
    0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06,
    0x07, 0xC7, 0x05, 0xC5, 0xC4, 0x04, 0xCC, 0x0C, 0x0D, 0xCD,
    0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09,
    0x08, 0xC8, 0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A,
    0x1E, 0xDE, 0xDF, 0x1F, 0xDD, 0x1D, 0x1C, 0xDC, 0x14, 0xD4,
    0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3,
    0x11, 0xD1, 0xD0, 0x10, 0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3,
    0xF2, 0x32, 0x36, 0xF6, 0xF7, 0x37, 0xF5, 0x35, 0x34, 0xF4,
    0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A,
    0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38, 0x28, 0xE8, 0xE9, 0x29,
    0xEB, 0x2B, 0x2A, 0xEA, 0xEE, 0x2E, 0x2F, 0xEF, 0x2D, 0xED,
    0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26,
    0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0, 0xA0, 0x60,
    0x61, 0xA1, 0x63, 0xA3, 0xA2, 0x62, 0x66, 0xA6, 0xA7, 0x67,
    0xA5, 0x65, 0x64, 0xA4, 0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F,
    0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68,
    0x78, 0xB8, 0xB9, 0x79, 0xBB, 0x7B, 0x7A, 0xBA, 0xBE, 0x7E,
    0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5,
    0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71,
    0x70, 0xB0, 0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92,
    0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C,
    0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B,
    0x99, 0x59, 0x58, 0x98, 0x88, 0x48, 0x49, 0x89, 0x4B, 0x8B,
    0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
    0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42,
    0x43, 0x83, 0x41, 0x81, 0x80, 0x40
};

+(NSString *)getBatterFormDevice:(NSString *)batter{
    if (batter.length == 2) {
//        batter = [self getBinaryByhex:batter];
//        batter = [batter substringWithRange:NSMakeRange(1, 7)];
//        batter = [self getDecimalBybinary:batter];
        batter = [NSString stringWithFormat:@"%@",[self numberHexString:batter]];
    }else{
        batter = @"";
    }
    
    return batter;
}



+ (NSString *)getCRCCode:(unsigned char [])code lenght:(int)length{
    
    unsigned char CRCHi = 0;
    unsigned char CRCLo = 0;
    
    int index = 0,CRCIndex;
    unsigned char uchCRCHi = 0xff;
    unsigned char UchCRCLo = 0xff;
    
    while (index < length) {
        unsigned char charCode = code[index];
        
        CRCIndex = uchCRCHi ^ charCode;
        uchCRCHi = (unsigned char)(UchCRCLo ^auchCRCHi[CRCIndex]);
        UchCRCLo = auchCRCLo[CRCIndex];
        
        index++;
    }
    
    CRCLo = uchCRCHi;
    int crcLo = (int)CRCLo;
    NSString *crcLo1 = [self gethexBybinary:crcLo];
    if (crcLo1.length < 2) {
        crcLo1 = [@"0" stringByAppendingString:crcLo1];
    }
    CRCHi = UchCRCLo;
    int crcHi = (int)CRCHi;
    NSString *crcHi1 = [self gethexBybinary:crcHi];
    if (crcHi1.length < 2) {
        crcHi1 = [@"0" stringByAppendingString:crcHi1];
    }
    
    return [NSString stringWithFormat:@"%@%@",crcHi1 , crcLo1];
}



+ (NSString *)getDeviceCRCCode:(NSString *)msg{
    unsigned char CRCHi = 0;
    unsigned char CRCLo = 0;
    int msgLength = (int)msg.length;

    int index = 0,CRCIndex;
    unsigned char uchCRCHi = 0xff;
    unsigned char uchCRCLo = 0xff;
    
    while (index<msgLength){
        unsigned char charCode =  [msg characterAtIndex:index];
        
        CRCIndex = uchCRCHi ^charCode;
        uchCRCHi = (unsigned char) (uchCRCLo ^auchCRCHi[CRCIndex]);
        uchCRCLo = auchCRCLo[CRCIndex];
        
        index++;
    }
    
    CRCLo = uchCRCHi;
    int crcLo = (int)CRCLo;
    NSString *crcLo1 = [self gethexBybinary:crcLo];
    if (crcLo1.length < 2) {
        crcLo1 = [@"0" stringByAppendingString:crcLo1];
    }
    CRCHi = uchCRCLo;
    int crcHi = (int)CRCHi;
    NSString *crcHi1 = [self gethexBybinary:crcHi];
    if (crcHi1.length < 2) {
        crcHi1 = [@"0" stringByAppendingString:crcHi1];
    }
    
    return [NSString stringWithFormat:@"%@%@",crcHi1 , crcLo1];
}

+ (NSString *)getTimerSceneCRCCode:(NSString *)msg{
    
    unsigned char CRCHi = 0;
    unsigned char CRCLo = 0;
    int msgLength = (int)[msg length]/2;
    char content[msgLength];
    for(int i = 0; i< msgLength ; i ++){
        
        NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([[msg substringWithRange:NSMakeRange(0,2)] UTF8String],0,16)];
    
        
        int cycleNumber = [temp10 intValue];
        content[i] = (char)cycleNumber;

        msg = [msg substringFromIndex:2];
    }
    
    int index = 0,CRCIndex;
    unsigned char uchCRCHi = 0xff;
    unsigned char uchCRCLo = 0xff;
    
    while (index<msgLength){
        unsigned char charCode =  content[index];
        
        CRCIndex = uchCRCHi ^charCode;
        uchCRCHi = (unsigned char) (uchCRCLo ^auchCRCHi[CRCIndex]);
        uchCRCLo = auchCRCLo[CRCIndex];
        
        index++;
    }
    
    CRCLo = uchCRCHi;
    int crcLo = (int)CRCLo;
    NSString *crcLo1 = [self gethexBybinary:crcLo];
    if (crcLo1.length < 2) {
        crcLo1 = [@"0" stringByAppendingString:crcLo1];
    }
    CRCHi = uchCRCLo;
    int crcHi = (int)CRCHi;
    NSString *crcHi1 = [self gethexBybinary:crcHi];
    if (crcHi1.length < 2) {
        crcHi1 = [@"0" stringByAppendingString:crcHi1];
    }
    
    return [NSString stringWithFormat:@"%@%@",crcHi1 , crcLo1];
}

/**
 字符串转十六进制
 
 @param string 字符串
 @return 十六进制
 */
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
} 


/**
 十六进制转二进制

 @param hex 十六进制
 @return 二进制
 */
+(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"A"];
    
    [hexDic setObject:@"1011" forKey:@"B"];
    
    [hexDic setObject:@"1100" forKey:@"C"];
    
    [hexDic setObject:@"1101" forKey:@"D"];
    
    [hexDic setObject:@"1110" forKey:@"E"];
    
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binaryString = [[NSString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
    }
    return binaryString;
}

/**
 十进制转二进制

 @param decimal 二进制
 @return 十进制
 */
+ (NSString *)getBinaryBydecimal:(NSInteger)decimal
{
    NSInteger num = decimal;//[decimal intValue];
    NSInteger remainder = 0;      //余数
    NSInteger divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

/**
 二进制转十进制

 @param binary 二进制
 @return 十进制
 */
+ (NSString *)getDecimalBybinary:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}

/**
 十六进制转十进制
 @param aHexString 十六进制
 @return 十进制
 */
+ (NSNumber *) numberHexString:(NSString *)aHexString

{
    
    // 为空,直接返回.
    if (nil == aHexString)
        
    {
        return nil;
    }

    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    
    unsigned long long longlongValue;
    
    [scanner scanHexLongLong:&longlongValue];
    
    //将整数转换为NSNumber,存储到数组中,并返回.
    
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    return hexNumber;
    
}


/**
 十进制转十六进制

 @param tmpid 十进制
 @return 十六进制
 */
+ (NSString *)gethexBybinary:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;  
        }  
        
    }  
    return str;  
}

+ (NSData *)hexStringToData:(NSString *)hexString {
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


@end
