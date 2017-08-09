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
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation OrderGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showCellWithIndexPath:(NSIndexPath*)indexPath{
    if ((indexPath.row+1)%2) {
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
