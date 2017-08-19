//
//  OrderGoodCell.h
//  AgilePOPs
//
//  Created by CongCong on 2017/7/21.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
@interface OrderGoodCell : UITableViewCell
- (void)showCellWithIndexPath:(NSIndexPath*)indexPath andGoodModel:(GoodModel*)goodModel;
@end
