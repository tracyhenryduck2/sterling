//
//  UserInfoModel.h
//  sHome
//
//  Created by shaop on 2017/3/7.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserInfoModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *email;

@property (nonatomic, strong) NSString<Optional> *emergencyNumber;

@property (nonatomic, strong) NSString<Optional> *firstName;

@property (nonatomic, strong) NSString<Optional> *lastName;


@end
