//
//  OrderGoodCell.m
//  AgilePOPs
//
//  Created by CongCong on 2017/7/21.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "OrderGoodCell.h"
#import "NSString+Tool.h"
#import "UIColor+CustomColors.h"

@interface OrderGoodCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@end

@implementation OrderGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showCellWithIndexPath:(NSIndexPath*)indexPath andGoodModel:(GoodModel*)goodModel{
    if ((indexPath.row+1)%2) {
        self.backgroundColor = ColorFromRGB(0xf5f5f5);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    self.titleLabel.text = goodModel.goods_name;
    self.countUnitLabel.text = [NSString stringWithFormat:@"%@ / %@",goodModel.goods_spec,goodModel.goods_unit];
    self.totalCountLabel.text = [NSString stringWithFormat:@"x %ld",goodModel.count.integerValue];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
