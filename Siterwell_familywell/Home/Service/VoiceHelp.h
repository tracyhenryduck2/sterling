//
//  VoiceHelp.h
//  sHome
//
//  Created by shaop on 2017/3/13.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceHelp : NSObject
/**
 播放音效
 urlString：音效路径
 soundIDName：音效缓存key
 */
+ (void)playAudioWithUrl:(NSString *)urlString soundIDName:(NSString *)soundIDName;

/**
 播放bound中的音效
 name：音效名称
 */
+ (void)playMainBoundAudioWithName:(NSString *)name;

/**
 播放沙盒document中的音效
 name：音效名称
 */
+ (void)playDocumnetAudioWithName:(NSString *)name;

/**
 播放系统声音
 soundID:声音id
 系统声音id:http://iphonedevwiki.net/index.php/AudioServices
 */
+ (void)playSystemAudioWithSoundID:(UInt32)soundID;

/**
 停止沙盒document中的音效
 name：音效名称
 */
+ (void)disposeSystemSoundIDWithName:(NSString *)name;
@end
