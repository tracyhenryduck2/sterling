//
//  VoiceHelp.m
//  sHome
//
//  Created by shaop on 2017/3/13.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "VoiceHelp.h"
#import <AudioToolbox/AudioToolbox.h>

static NSMutableDictionary *soundIDs;

@implementation VoiceHelp
+ (void)playAudioWithUrl:(NSString *)urlString soundIDName:(NSString *)soundIDName
{
    SystemSoundID soundID = 0;
    
    if (!soundIDs)
    {
        soundIDs = [NSMutableDictionary dictionary];
    }
    else
    {
        soundID = (SystemSoundID)[soundIDs[soundIDName] integerValue];
    }
    
    if (soundID == 0)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)url, &soundID);
        soundIDs[soundIDName] = [NSString stringWithFormat:@"%zd",soundID];
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeAudioWithUrl:(NSString *)urlString soundIDName:(NSString *)soundIDName
{
    SystemSoundID soundID = 0;
    
    if (!soundIDs)
    {
        soundIDs = [NSMutableDictionary dictionary];
    }
    else
    {
        soundID = (SystemSoundID)[soundIDs[soundIDName] integerValue];
    }
    
    if (soundID == 0)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)url, &soundID);
        soundIDs[soundIDName] = [NSString stringWithFormat:@"%zd",soundID];
    }
    soundIDs = nil;
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(soundID);
}

+ (void)disposeSystemSoundIDWithName:(NSString *)name{
    NSString *url = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
    [self disposeAudioWithUrl:url soundIDName:name];
    
}

+ (void)playSystemAudioWithSoundID:(UInt32)soundID
{
    AudioServicesPlaySystemSound(soundID);
}

+ (void)playMainBoundAudioWithName:(NSString *)name
{
    NSString *url = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
    
    [self playAudioWithUrl:url soundIDName:name];
}


+ (void)playDocumnetAudioWithName:(NSString *)name
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *url = [documents stringByAppendingPathComponent:name];
    [self playAudioWithUrl:url soundIDName:name];
}


@end
