//
//  connectWifiVC.h
//  sHome
//
//  Created by shaop on 2016/12/21.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseVC.h"

@interface connectWifiVC : BaseVC

@property (nonatomic , copy) NSString *apSsid;

@property (nonatomic , copy) NSString *apPwd;

@property (nonatomic , assign) BOOL isFromeSeeting;

@end
