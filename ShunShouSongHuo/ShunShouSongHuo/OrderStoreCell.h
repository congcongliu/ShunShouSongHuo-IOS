//
//  OrderStoreCell.h
//  AgilePOPs
//
//  Created by CongCong on 2017/7/21.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderStoreModel.h"
@interface OrderStoreCell : UITableViewCell
- (void)showStoreCellWithModel:(OrderStoreModel*)storeModel andIndexPath:(NSIndexPath *)indexPath;
@end
