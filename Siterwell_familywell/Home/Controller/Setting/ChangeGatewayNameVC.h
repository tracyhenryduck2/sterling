//
//  ChangeGatewayNameVC.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef ChangeGatewayNameVC_h
#define ChangeGatewayNameVC_h
@interface ChangeGatewayNameVC : BaseVC
@property(nonatomic,assign) NSString *devTid;
@property(nonatomic,assign) NSString *ctrlKey;
@property(nonatomic,strong) RACSubject *delegate;

@end

#endif /* ChangeGatewayNameVC_h */
