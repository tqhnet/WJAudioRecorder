//
//  WJAudioRecorder.m
//  WJAudioRecorder
//
//  Created by tqh on 2018/5/7.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "WJAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#define kRecordAudioFile @"myRecord.caf"
#import "WJAudioRecorder+Mp3.h"

@interface WJAudioRecorder()<AVAudioRecorderDelegate>

@property (nonatomic,strong) AVAudioRecorder * audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer   * audioPlayer;//音频播放器，用于播放录音
@property (nonatomic,strong) NSTimer         * timer;//录音声波监控；
@property (nonatomic,assign) CGFloat progress;

@end

@implementation WJAudioRecorder

- (void)dealloc {
    [self.timer invalidate];
    self.timer  = nil;
}

#pragma mark - public

- (void)startRecorder {
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
        self.timer.fireDate = [NSDate distantPast];
    }
}

- (void)pauseRecorder {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

- (void)resumeRecorder {
    //没有停止都可以继续录制
    [self startRecorder];
}

- (void)stopRecorder {
    [self.audioRecorder stop];
    self.timer.fireDate = [NSDate distantFuture];
    self.progress = 0;
}

#pragma mark - 事件监听

-(void)audioPowerChange
{
    [self.audioRecorder updateMeters];//跟新检测值
    float power = [self.audioRecorder averagePowerForChannel:0];//获取第一个通道的音频，注音音频的强度方位-160到0
    CGFloat progerss = (1.0/160)*(power+160);
    self.progress = progerss;
    NSLog(@"音频震动...%f",progerss);
    NSLog(@"时间....%f",self.audioRecorder.currentTime);
}

#pragma mark -<AVAudioRecorderDelegate>

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
//    [self getSavePath];
     NSLog(@"录音完成!");
//    NSString *file = [NSString stringWithContentsOfURL:[self getSavePath] encoding:NSUTF8StringEncoding error:nil];
    NSString *file = [self getSavePathString];
    NSLog(@"file:path:%@",file);
    //进行转码
    NSString *path = [WJAudioRecorder audioCAFtoMP3:file];
    if (path) {
        NSLog(@"转码成功");
    }
}
#pragma mark - private

/**设置音频会话*/
-(void)setAudioSession
{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    //设置为播放和录制状态，以便在录制完成之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**录音文件路径*/
-(NSURL *)getSavePath
{
    NSString * urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
//    NSLog(@"file:path:%@",urlStr);
    NSURL * url = [NSURL fileURLWithPath:urlStr];
    return url;
}

- (NSString *)getSavePathString {
    NSString * urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    return urlStr;
}

/***取得录音文件的设置*/
-(NSDictionary *)getAudioSettion
{
    NSMutableDictionary * dicM = [NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般的录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道，需要录制为双声道才能转mp3
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    //每个采样点位数，分为8，16，24，32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //。。。。是他设置
    return dicM;
}

#pragma mark - 懒加载


-(AVAudioRecorder * )audioRecorder
{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL * url =[self getSavePath];
        //创建录音格式设置
        NSDictionary * setting = [self getAudioSettion];
        //创建录音机
        NSError * error = nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要控制声波则必须设置为YES
        if(error)
        {
            NSLog(@"创建录音机对象发生错误，错误信息是：%@",error.localizedDescription);
            return nil;
        }
        
    }
    return _audioRecorder;
    
}

//播放器
- (AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        NSURL * url = [self getSavePath];
        NSError * error = nil;
        _audioPlayer =[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程出错：错误信息是：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

-(NSTimer * )timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - others

@end
