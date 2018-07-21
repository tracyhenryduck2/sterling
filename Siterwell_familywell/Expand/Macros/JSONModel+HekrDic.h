//
//  JSONModel+HekrDic.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/21.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JSONModel (HekrDic)
-(id)initWithHekrDictionary:(NSDictionary *)dic error:(NSError **)error;
@end
