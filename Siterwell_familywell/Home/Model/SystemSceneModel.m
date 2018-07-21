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
        if (self.sence_group!=nil && (self.answer_content.length >= 32 || (self.answer_content.length == 6 && [[self.answer_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]))) {
            self.systemname = [self getNameFromContent];
            self.sid = [self getSidFromContent];
            self.color = [self getSceneColor];
            self.dev584Count = [self getDev584_countFromContent];
            self.dev584List = [self getDev584List:self.dev584Count];
            self.sceneCount = [self getSceneCountFromContent];
            self.sceneRelationShip = [self getSceneRelationShipList:self.sceneCount withGS584Count:self.dev584Count];
        }
    }
    return self;
}


- (NSString *)getNameFromContent{
    NSString *result = @"";
    if (self.answer_content.length >= 32){
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *nameString = [self.answer_content substringWithRange:NSMakeRange(6, 32)];
        NSData *data = [self hexStringToData:nameString];
        result = [[NSString alloc] initWithData:data encoding:enc];
        result = [result stringByReplacingOccurrencesOfString:@"@" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"$" withString:@""];

    }
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
    
    if(self.answer_content.length >= 32){
    
    NSNumber *count = [BatterHelp numberHexString:[self.answer_content substringWithRange:NSMakeRange(38, 4)]];
    
    int lenth = [count intValue]*2;
    
    if (self.answer_content!=nil&&(38 + 4 + lenth) < [self.answer_content length]) {
        
        NSString *color = [self.answer_content substringWithRange:NSMakeRange(38 + 4 + lenth, 2)];
        
        NSString *colors = @"F0F1F2F3F4F5F6F7F8";
        if ([colors rangeOfString:color].location != NSNotFound) {
            return color;
        }else{
            return  [@"F0F1F2F3F4F5F6F7F8" substringWithRange:NSMakeRange(2*[self.sence_group intValue], 2)];
        }
    }else{
        return  [@"F0F1F2F3F4F5F6F7F8" substringWithRange:NSMakeRange(2*[self.sence_group intValue], 2)];
    }
    }else{
        return  [@"F0F1F2F3F4F5F6F7F8" substringWithRange:NSMakeRange(2*[self.sence_group intValue], 2)];
    }
}

- (NSNumber *)getDev584_countFromContent {
    if(self.answer_content.length >= 32){
        NSString *count = [self.answer_content substringWithRange:NSMakeRange(38, 2)];
        count = [NSString stringWithFormat:@"%lu",strtoul([[count substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

        NSNumber *numTemp = [numberFormatter numberFromString:count];
        return numTemp;
    }else{
        return [NSNumber numberWithInt:0];
    }

}

- (NSNumber *)getSceneCountFromContent {
    if(self.answer_content.length >= 32){
        NSString *count = [self.answer_content substringWithRange:NSMakeRange(40, 2)];
        count = [NSString stringWithFormat:@"%lu",strtoul([[count substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

        NSNumber *numTemp = [numberFormatter numberFromString:count];
        return numTemp;
    }else{
        return [NSNumber numberWithInt:0];
    }

}

-(NSMutableArray <GS584RelationShip *>*)getDev584List:(NSNumber *)count{
    if(self.answer_content.length>=42 && count >0){
        NSMutableArray<GS584RelationShip *> *ds = [[NSMutableArray alloc] init];
        for (int i = 0; i < [count intValue]; i++) {
            GS584RelationShip * ship = [[GS584RelationShip alloc] init];
            [ship setSid:self.sence_group];
            NSString *gs584 = [self.answer_content substringWithRange:NSMakeRange(42+14*i, 14)];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *numTemp = [numberFormatter numberFromString:[NSString stringWithFormat:@"%lu",strtoul([[gs584 substringWithRange:NSMakeRange(0, 4)] UTF8String], 0, 16)]];
            [ship setEqid:numTemp];


            [ship setAction:[NSString stringWithFormat:@"%lu",strtoul([[gs584 substringWithRange:NSMakeRange(4, 8)] UTF8String], 0, 16)]];
            [ship setDelay:0];
            [ds addObject:ship];
        }
        return ds;
    }else{
        return [[NSMutableArray alloc] init];
    }
}

-(NSMutableArray <SceneRelationShip *>*) getSceneRelationShipList:(NSNumber *) count withGS584Count:(NSNumber *)gs584count{
    if(self.answer_content.length>=42 && count >0){
        NSMutableArray<SceneRelationShip *> *ds = [[NSMutableArray alloc] init];
        for(int i = 0; i < [count intValue]; i++){


            if (42+[gs584count intValue]*14+i*2+2 <= self.answer_content.length) {
                SceneRelationShip *ship = [[SceneRelationShip alloc] init];
                [ship setSid:self.sence_group];
                NSString *scene_id = [self.answer_content substringWithRange:NSMakeRange(6+32+4+([gs584count intValue]*14)+(i*2), 2)];
                scene_id = [NSString stringWithFormat:@"%lu",strtoul([[scene_id substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
                [ship setMid:scene_id];
                [ds addObject:ship];
            }

        }
        return ds;
    }else{

        return  [[NSMutableArray alloc] init];
    }
}

@end
