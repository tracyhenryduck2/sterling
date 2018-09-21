//
//  ItemData.h
//  ShelfCollectionView
//
//  Created by king.wu on 8/18/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel+HekrDic.h"
@interface ItemData : JSONModel



@property(nonatomic,strong) NSNumber * device_ID;
@property(nonatomic,strong) NSString * device_name;
@property(nonatomic,strong) NSString * device_status;
@property(nonatomic,strong) NSString<Ignore> * customTitle;
@property (nonatomic,strong)NSString<Ignore> *devTid;
@property (nonatomic, strong)NSString<Ignore> *image;
@property (nonatomic, strong)NSDictionary<Ignore> *names;
@property (nonatomic, strong)NSDictionary<Ignore> *pictures;

- (instancetype)initWithTitle:(NSString *)title DevID:(NSInteger)devID DevType:(NSString *)devtype Code:(NSString *)code;
@end
