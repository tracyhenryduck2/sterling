//
//  Single.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/16.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef Single_h
#define Single_h
@interface Single:NSObject

@property (nonatomic,assign) int command;

+(instancetype)sharedInstanced;

@end

#endif /* Single_h */
