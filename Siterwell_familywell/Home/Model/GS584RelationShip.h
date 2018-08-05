//
//  GS584RelationShip.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef GS584RelationShip_h
#define GS584RelationShip_h
@interface GS584RelationShip:JSONModel

@property(strong,nonatomic)   NSString * devTid;
@property(nonatomic,strong)   NSString * sid;
@property(nonatomic,assign) NSNumber * eqid;
@property(nonatomic,strong)   NSString  * action;
@property(nonatomic,assign) NSInteger delay;
@end

#endif /* GS584RelationShip_h */
