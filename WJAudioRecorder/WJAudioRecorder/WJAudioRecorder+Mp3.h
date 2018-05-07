//
//  WJAudioRecorder+Mp3.h
//  WJAudioRecorder
//
//  Created by tqh on 2018/5/7.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "WJAudioRecorder.h"

@interface WJAudioRecorder (Mp3)
/**
 PCM转换MP3
 PCM转换MP3配置
 + (NSDictionary *)getAudioSettingWithPCM {
 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
 //设置录音格式
 [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
 //设置录音采样率，8000是电话采样率，对于一般录音已经够了
 [dic setObject:@(44100.0) forKey:AVSampleRateKey];
 //设置通道,这里采用双声道
 [dic setObject:@(1) forKey:AVNumberOfChannelsKey];
 //每个采样点位数,分为8、16、24、32
 [dic setObject:@(16) forKey:AVLinearPCMBitDepthKey];
 //是否使用浮点数采样
 [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
 //....其他设置等
 return dic;
 }
 */
+ (NSString *)audioPCMtoMP3:(NSString *)wavPath;

/**
 CAF转换MP3
 CAF转换MP3配置
 + (NSDictionary *)getAudioSettingWithCAF {
 NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
 [NSNumber numberWithInt:AVAudioQualityMin],
 AVEncoderAudioQualityKey,
 [NSNumber numberWithInt:16],
 AVEncoderBitRateKey,
 [NSNumber numberWithInt:2],
 AVNumberOfChannelsKey,
 [NSNumber numberWithFloat:44100.0],
 AVSampleRateKey,
 nil];
 
 return setting;
 }
 */
+ (NSString *)audioCAFtoMP3:(NSString *)wavPath;

@end
