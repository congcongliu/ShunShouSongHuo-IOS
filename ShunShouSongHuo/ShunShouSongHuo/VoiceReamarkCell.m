//
//  VoiceReamarkCell.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "VoiceReamarkCell.h"
#import "CCAlert.h"
#import "CCButton.h"
#import "Constant.h"
#import "LVRecordTool.h"
#import "NSString+Tool.h"
#import "UIAlertCategory.h"
#import "UIColor+CustomColors.h"

@interface VoiceReamarkCell ()<LVRecordToolDelegate>{
    NSString *_voiceName;
    NSString *_voiceFilePath;
    UIButton *_playButton;
    UIButton *_markVioceButton;
}
@property (nonatomic, strong) LVRecordTool *recordTool;
@property (nonatomic, assign) BOOL isRecordSucceed;
@property (nonatomic, copy  ) VoiceReamarkCallBack callback;
@end

@implementation VoiceReamarkCell

- (void)showVoiceCellWithCallBack:(VoiceReamarkCallBack)callback{
    self.callback = callback;
}

- (LVRecordTool*)recordTool{
    if (!_recordTool) {
        _recordTool = [LVRecordTool sharedRecordTool];
        _recordTool.delegate = self;
//        [_recordTool playRecordingFile];//预热
        [self.recordTool startRecording];
        [self.recordTool stopRecording];
    }
    return _recordTool;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self.recordTool playFileWithFilePath:@""];
    }
    return self;
}

- (void)initSubviews{
    
    self.clipsToBounds = YES;
    _markVioceButton = [CCButton ButtonCornerradius:22.5 title:@"长按 录音" titleColor:[UIColor blackColor] titleSeletedColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:18] normalBackGrondImage:[UIImage imageNamed:@"f7f7f7"]  seletedImage:nil target:nil action:nil];
    _markVioceButton.frame = self.bounds;
    
    [_markVioceButton setBackgroundImage:[UIImage imageNamed:@"7f7f7f"] forState:UIControlStateHighlighted];
    [_markVioceButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [self addSubview:_markVioceButton];
    
    // 录音按钮
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchDragCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [_markVioceButton addTarget:self action:@selector(recordBtnDidTouchRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(self.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
    [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"cccccc"] forState:UIControlStateSelected];
    _playButton.clipsToBounds = YES;
    _playButton.layer.cornerRadius = self.frame.size.height/2;
    _playButton.layer.borderWidth = 2;
    _playButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self addSubview:_playButton];
    [_playButton addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = YES;
}

- (void)recordSucceed:(BOOL)succeed{
    if (succeed) {
        _playButton.hidden = NO;
        _markVioceButton.frame = CGRectMake(0, 0, self.frame.size.width - self.frame.size.height -15 , self.frame.size.height);
    }else{
        _markVioceButton.frame = self.bounds;
        _playButton.hidden = YES;
    }
    
}

#pragma mark - 录音按钮事件
- (void)recordBtnDidTouchRepeat:(UIButton *)recordBtn{
    if ([self.recordTool.recorder isRecording]){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self lockVoiceButton];
                toast_showInfoMsg(@"已取消录音", 200);
            });
        });
    }
}

- (void)lockVoiceButton{
    _voiceName = @"";
    _playButton.hidden = YES;
    _markVioceButton.enabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(voiceButtonCancelLock) userInfo:nil repeats:NO];
    if (self.callback) {
        self.callback(_voiceName,0);
    }
}

- (void)voiceButtonCancelLock{
    
    if ([self.recordTool.recorder isRecording]){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
            dispatch_async(dispatch_get_main_queue(), ^{
                _playButton.hidden = YES;
//                [_voiceView stopRecord];
            });
        });
    }
    _markVioceButton.enabled = YES;
}
- (void)recordBtnDidTouchDragEnter:(UIButton *)recordBtn {
//    [_voiceView setStatus:@"上滑取消录音"];
    toast_showInfoMsg(@"上滑取消录音", 200);
}
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
//    [_voiceView setStatus:@"松开取消录音"];
    toast_showInfoMsg(@"松开取消录音", 200);
}

#pragma mark ------> 开始录音
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
    if ([self showCanotRecord]) {
        if ([self.recordTool.recorder isRecording]){
            [self.recordTool stopRecording];
        }
        self.recordTool.recorder = nil;
        _playButton.selected = NO;
        [self.recordTool startRecording];
        //        [_voiceView setStatus:@"正在录音...."];
        //        [_voiceView show];
    }
}
- (BOOL)showCanotRecord{
    
    __block BOOL bCanRecord = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    if (!bCanRecord) {
        UIAlertCategory * a = [[UIAlertCategory alloc] initWithTitle:@"你拒绝了拍照权限,请你去设置->隐私->麦克风" WithMessage:@"允许顺手送货使用你的麦克风"];
        [a addButton:ALERT_BUTTON_OK WithTitle:@"我知道了" WithAction:^(void *action) {
            NSURL* url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
                [[UIApplication sharedApplication] openURL:url];
        }];
        [a show];
    }
    return bCanRecord;
}
// 点击
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
//    double currentTime = self.recordTool.recorder.currentTime;
//    NSLog(@"%lf", currentTime);
//    if (currentTime < 2) {
////        [self lockVoiceButton];
//        toast_showInfoMsg(@"说话时间太短", 200);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self.recordTool stopRecording];
////            [self.recordTool destructionRecordingFile];
////            if (_voiceName&&![_voiceName isEmpty]) {
////                [self recordSucceed:YES];
////            }else{
////                [self recordSucceed:NO];
////            }
//        });
//    } else {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self.recordTool stopRecording];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 已成功录音
////                [_voiceView stopRecord];
//                _voiceName = self.recordTool.fileName;
//                _voiceFilePath = self.recordTool.filePath;
//                NSData *voiceData = [NSData dataWithContentsOfFile:_voiceFilePath];
//                NSLog(@"%ld",voiceData.length);
//                toast_showInfoMsg(@"录音成功", 200);
//                [self recordSucceed:YES];
//                NSLog(@"voiceFile:--------->%@",_voiceName);
//                if (self.callback) {
//                    self.callback(_voiceName, currentTime);
//                }
//            });
//        });
//    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        double currentTime = self.recordTool.recorder.currentTime;
        NSLog(@"%lf", currentTime);
        [self.recordTool stopRecording];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (currentTime < 2) {
                toast_showInfoMsg(@"说话时间太短", 200);
            }else{
                _voiceName = self.recordTool.fileName;
                _voiceFilePath = self.recordTool.filePath;
                NSData *voiceData = [NSData dataWithContentsOfFile:_voiceFilePath];
                NSLog(@"%ld",voiceData.length);
                toast_showInfoMsg(@"录音成功", voiceData.length);
                [self recordSucceed:YES];
                NSLog(@"voiceFile:--------->%@",_voiceName);
                if (self.callback) {
                    self.callback(_voiceName, currentTime);
                }
            }
        });
    });
}

// 手指从按钮上移除
- (void)recordBtnDidTouchDragCancel:(UIButton *)recordBtn {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self lockVoiceButton];
            toast_showInfoMsg(@"已取消录音", 200);
        });
    });
}

#pragma mark - 播放录音
- (void)playVoice:(UIButton*)voiceButton{
    voiceButton.selected = !voiceButton.selected;
    if (voiceButton.selected) {
        [self.recordTool playFileWithFilePath:_voiceFilePath];
    }else{
        [self.recordTool stopPlaying];
    }
}
#pragma mark ------->LVRecordTool Delegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no{
    NSLog(@"LVRecord :  ---->%d",no);
//    [_voiceView showVoiceImageWith:no];
}
- (void)recordTool:(LVRecordTool *)recordTool didStopPlayingFlag:(BOOL)succefuly{
    _playButton.selected = NO;
}





@end
