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

@property(copy,nonatomic)   NSString * devTid;
@property(nonatomic,copy)   NSString * sid;
@property(nonatomic,assign) NSInteger   eqid;
@property(nonatomic,copy)   NSString  * action;
@property(nonatomic,assign) NSInteger delay;
@end

#endif /* GS584RelationShip_h */
