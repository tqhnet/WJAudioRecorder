//
//  WJAudioRecorder.h
//  WJAudioRecorder
//
//  Created by tqh on 2018/5/7.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

/**音频录音,可能需要播放顺便写了*/
@interface WJAudioRecorder : NSObject

/***录制方法*/
- (void)startRecorder;
- (void)pauseRecorder;
- (void)resumeRecorder;
- (void)stopRecorder;



@end
