//
//  VideoModel.h
//  Siterwell_familywell
//
//  Created by Henry on 2019/1/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#ifndef VideoModel_h
#define VideoModel_h
@interface VideoModel:JSONModel

@property(strong,nonatomic)   NSString * devid;
@property(nonatomic,strong)   NSString * name;
@property(nonatomic,strong)   NSString * img;
@end

#endif /* VideoModel_h */
