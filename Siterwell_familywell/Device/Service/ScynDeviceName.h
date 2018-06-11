//
//  ScynDeviceName.h
//  sHome
//
//  Created by shap on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface ScynDeviceName : BaseDriveApi
-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Device:(NSMutableArray *)deviceArray ConnectHost:(NSString *)connecthost;
@end
