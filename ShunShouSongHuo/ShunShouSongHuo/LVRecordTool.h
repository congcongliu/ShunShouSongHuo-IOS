//
//  LVRecordTool.h
//  RecordAndPlayVoice
//
//  Created by PBOC CS on 15/3/14.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class LVRecordTool;
@protocol LVRecordToolDelegate <NSObject>

@optional
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no;
- (void)recordTool:(LVRecordTool *)recordTool didStopPlayingFlag:(BOOL)succefuly;
@end

@interface LVRecordTool : NSObject
@property (nonatomic, copy)NSString *filePath;
@property (nonatomic, copy)NSString *fileName;

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;

/** 开始录音 */
- (void)startRecording;

/** 停止录音 */
- (void)stopRecording;

/** 播放录音文件 */
- (void)playRecordingFile;
- (void)playFileWithFilePath:(NSString *)filePath;
/** 停止播放录音文件 */
- (void)stopPlaying;


/** 销毁录音文件 */
- (void)destructionRecordingFile;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;

/** 更新图片的代理 */
@property (nonatomic, assign) id<LVRecordToolDelegate> delegate;

@end
