//
//  VoiceReamarkCell.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VoiceReamarkCallBack)(NSString *voiceFile,NSInteger voiceTime);

@interface VoiceReamarkCell : UICollectionViewCell
- (void)showVoiceCellWithCallBack:(VoiceReamarkCallBack)callback;
@end
