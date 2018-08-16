//
//  ItemData.h
//  ShelfCollectionView
//
//  Created by king.wu on 8/18/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ItemData : NSObject

@property (nonatomic, strong, readonly)NSString *image;
@property (nonatomic, strong, readonly)NSString *devType;
@property (nonatomic, assign, readonly)NSInteger devID;
@property (nonatomic, strong, readonly)NSString *statuCode;
@property (nonatomic, strong, readwrite)NSString *customTitle;

- (instancetype)initWithTitle:(NSString *)title DevID:(NSInteger)devID DevType:(NSString *)devtype Code:(NSString *)code;
@end
