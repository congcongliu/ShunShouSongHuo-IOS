//
//  StoreDeatilCell.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/9.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "StoreDeatilCell.h"
#import "CCDate.h"
#import "NSString+Tool.h"
@interface StoreDeatilCell ()
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation StoreDeatilCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)showOrderCellWithActivityModel:(ActivityModel *)activityModel{
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f 元",activityModel.order_total_price.floatValue/100.00]];
    [attriString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(attriString.length-1,1)];
    self.totalPriceLabel.attributedText = attriString;
    self.timeLabel.text = [activityModel.submit_time format:@"YYYY.MM.dd"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
