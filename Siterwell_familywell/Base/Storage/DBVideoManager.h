//
//  DBVideoManager.h
//  Siterwell_familywell
//
//  Created by Henry on 2019/1/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#ifndef DBVideoManager_h
#define DBVideoManager_h
#import "DBManager.h"
#import "VideoModel.h"


static NSString * const videotable = @"videotable";

@interface DBVideoManager:NSObject
+ (instancetype)sharedInstanced;

- (NSMutableArray *)queryAllVideo;
- (NSMutableArray *)queryAllVideoWithoutImg;
- (void)insertVideo:(VideoModel *)videoModel;
-(void)deleteVideo:(NSString *)devTid;
- (BOOL)HasVideo:(NSString *)devTid;
@end

#endif /* DBVideoManager_h */
