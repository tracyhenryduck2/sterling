//
//  ErrorModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/11.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ErrorModel : JSONModel

@property (nonatomic, assign) long code;

@property (nonatomic , strong) NSString<Optional> *desc;

@property (nonatomic, strong) NSString<Ignore> *userinfo;

@end
