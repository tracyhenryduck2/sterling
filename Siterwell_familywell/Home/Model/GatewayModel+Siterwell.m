//
//  DeviceModel+DeviceModel_Siterwell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "GatewayModel+Siterwell.h"

@implementation GatewayModel (Siterwell)

-(void) setIsChoice:(NSInteger)IsChoice{
    self.IsChoice = IsChoice;
}

-(NSInteger)IsChoice{
    return self.IsChoice;
}
@end
