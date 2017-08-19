//
//  TextReamarkCell.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextRemarkCallBack)(NSString *textString);

@interface TextReamarkCell : UICollectionViewCell

- (void)showTextCellWithTextString:(NSString *)textString andTextRemarkCallBack:(TextRemarkCallBack)callback;

@end
