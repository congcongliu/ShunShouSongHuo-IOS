//
//  GoodDetailCell.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/10.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "GoodDetailCell.h"
#import "UIColor+CustomColors.h"

@interface GoodDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@end


@implementation GoodDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showCellWithModel:(GoodModel*)goodModel indexPath:(NSIndexPath*)indexPath{
    self.titleLabel.text = goodModel.goods_name;
    self.countUnitLabel.text = [NSString stringWithFormat:@"%@ / %@",goodModel.goods_spec,goodModel.goods_unit];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",goodModel.price.floatValue/100.00];
    self.subtotalLabel.text = [NSString stringWithFormat:@"￥%.2f",goodModel.subtotal.floatValue/100.00];
    self.totalCountLabel.text = [NSString stringWithFormat:@"x %ld",goodModel.count.integerValue];
    if (indexPath.row%2) {
        self.backgroundColor = ColorFromRGB(0xf5f5f5);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
