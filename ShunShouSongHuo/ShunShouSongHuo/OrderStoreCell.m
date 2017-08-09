//
//  OrderStoreCell.m
//  AgilePOPs
//
//  Created by CongCong on 2017/7/21.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "OrderStoreCell.h"
#import "CCUserData.h"
#import "UserLocation.h"
#import "NSString+Tool.h"
#import <MAMapKit/MAMapKit.h>
#import "UIColor+CustomColors.h"

@interface OrderStoreCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;



@end

@implementation OrderStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showStoreCellWithModel:(OrderStoreModel*)storeModel andIndexPath:(NSIndexPath *)indexPath{
    self.storeNameLabel.text = storeModel.name;
    self.addressLabel.text = storeModel.address;
    [self setDistanceWithModel:storeModel];
    
    if (indexPath.row%2) {
        self.backgroundColor = ColorFromRGB(0xf5f5f5);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setDistanceWithModel:(OrderStoreModel*)model{
    
    NSNumber *lat = model.location[1];
    NSNumber *log = model.location[0];
    MAMapPoint point1 = MAMapPointForCoordinate([[UserLocation defaultUserLoaction] userLoaction]);
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat.floatValue,log.floatValue));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    if (distance>1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f%@",distance/1000.00,NSLocalizedString(@"kilometre", nil)];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%.0f%@",distance,NSLocalizedString(@"meters", nil)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
