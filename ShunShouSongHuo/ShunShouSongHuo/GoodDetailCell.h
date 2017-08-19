//
//  GoodDetailCell.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/10.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
@interface GoodDetailCell : UITableViewCell
- (void)showCellWithModel:(GoodModel*)goodModel indexPath:(NSIndexPath*)indexPath;
@end
