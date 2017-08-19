//
//  PhotoReamarkCell.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakePhotosObjectModel.h"
@interface PhotoReamarkCell : UICollectionViewCell
- (void)showTakePhotoCellWithMinNumber:(NSInteger)minNumber andMaxNumber:(NSInteger)maxNumber;
- (void)showCellWithNewModel:(TakePhotosObjectModel *)model;
@end
