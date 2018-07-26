//
//  ItemDataHelp.h
//  sHome
//
//  Created by shaop on 2017/1/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemData.h"
#import "SceneListItemData.h"

@interface ItemDataHelp : NSObject

/**
 ItemData转SceneListItemData

 @param data ItemData
 @return SceneListItem
 */
+ (SceneListItemData *)ItemDataToSceneListItemData:(ItemData *)data;

+(NSString *)SceneContentWithOutputArray:(NSMutableArray *)outarray inputAraary:(NSMutableArray *)inarray type:(NSInteger)type name:(NSString *)name sceneid:(NSString *)sceneid;

+ (BOOL)isAddSceneId:(NSString *)sceneId;

@end
