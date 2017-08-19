//
//  PopStorePointsList.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//
#define kAllMissionCellHeight 125.0
#define kPopHeaderHight 36.0
#import "Constant.h"
#import <SDAutoLayout.h>
#import "UserLocation.h"
#import "UIButton+Block.h"
#import "StorePointCell.h"
#import <MAMapKit/MAMapKit.h>
#import "PopStorePointsList.h"
@interface PopStorePointsList ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tabView;
    UILabel *_headerLable;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation PopStorePointsList
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTabVies];
    }
    return self;
}
- (void)initTabVies{
    _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, kPopHeaderHight, SYSTEM_WIDTH, kAllMissionCellHeight*2)];
    _tabView.delegate = self;
    _tabView.dataSource= self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.scrollEnabled = NO;
    _tabView.rowHeight = 65;
    [_tabView registerNib:[UINib nibWithNibName:@"StorePointCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StorePointCell"];
    [self addSubview:_tabView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SYSTEM_WIDTH, kPopHeaderHight)];
    headerView.backgroundColor = UIColorFromRGB(0xffce04)
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor blackColor];
    [headerView addSubview:lineView];

    _headerLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SYSTEM_WIDTH-30, kPopHeaderHight)];
    _headerLable.font = [UIFont boldSystemFontOfSize:12];
    _headerLable.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:_headerLable];
    
    [self addSubview:headerView];
}
#pragma mark -------- > TabView  dataSource  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StorePointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StorePointCell" forIndexPath:indexPath];
    OrderStoreModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell showOrderCellWithStore:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)tabelFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton * naviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    naviButton.clipsToBounds = YES;
    naviButton.layer.cornerRadius = 20;
    naviButton.layer.borderColor = [UIColor blackColor].CGColor;
    naviButton.layer.borderWidth = 2;
    naviButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [naviButton setTitle:[NSString stringWithFormat:@"导航%@",[self getDistance]] forState:UIControlStateNormal];
    [naviButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [naviButton setBackgroundImage:[UIImage imageNamed:@"F5F5F5"] forState:UIControlStateHighlighted];
    [naviButton addTarget:self action:@selector(naviButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:naviButton];
    
    UIButton * detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.clipsToBounds = YES;
    detailButton.layer.cornerRadius = 20;
    detailButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [detailButton setTitle:@"门店订单" forState:UIControlStateNormal];
    
    detailButton.backgroundColor = UIColorFromRGB(0xFF3B30);
    [detailButton setBackgroundImage:[UIImage imageNamed:@"cc2f27"] forState:UIControlStateHighlighted];
    [detailButton addTarget:self action:@selector(deatilButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:detailButton];
    
    naviButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(footerView)
    .leftSpaceToView(footerView,15)
    .widthIs((SYSTEM_WIDTH-45)/2);
    
    detailButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(footerView)
    .leftSpaceToView(naviButton,15)
    .rightSpaceToView(footerView,15);

    return footerView;
}


- (void)naviButtonClick{
    if ([self.delegate respondsToSelector:@selector(didSelectNaviWithStoreModel:)]) {
        [self.delegate didSelectNaviWithStoreModel:self.dataArray[0]];
    }
}

- (void)deatilButtonClick{
    if ([self.delegate respondsToSelector:@selector(didSelectDetailWithStoreModel:)]) {
        [self.delegate didSelectDetailWithStoreModel:self.dataArray[0]];
    }
}

- (void)showPopViewWith:(OrderStoreModel *)model andPopStoreListDelegate:(id<PopStoreListDelegate>)delegate;{
    self.delegate = delegate;
    [self addNewModel:model];
    _tabView.tableFooterView = [self tabelFooterView];
}


- (void)addNewModel:(id)model{
    
    self.dataArray = [NSMutableArray arrayWithObject:model];
    [_tabView reloadData];
    /**
     *  动画
     */
    _headerLable.text = NSLocalizedString(@"sf_store_info", nil);
    if (self.isShow) {
        CGRect newFrame = self.frame;
        newFrame.origin.y = newFrame.size.height;
        [UIView animateWithDuration:0.1 animations:^{
            self.frame = newFrame;
        } completion:^(BOOL finished) {
            CGRect frame = self.frame;
            frame.origin.y = frame.size.height-kPopHeaderHight-kAllMissionCellHeight;
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.frame = frame;
            } completion:nil];
        }];
    }else{
        CGRect frame = self.frame;
        frame.origin.y = frame.size.height-kPopHeaderHight-kAllMissionCellHeight;
        
        //阻尼  damping    Velocity  速率
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.frame = frame;
        } completion:nil];
    }
    self.isShow = YES;
}

- (NSString *)getDistance{
    
    OrderStoreModel *storeModel = [self.dataArray objectAtIndex:0];
    
    NSNumber *lat = storeModel.location[1];
    NSNumber *log = storeModel.location[0];
    MAMapPoint point1 = MAMapPointForCoordinate([[UserLocation defaultUserLoaction] userLoaction]);
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat.floatValue,log.floatValue));
    //2.计算距离
    CGFloat distance = MAMetersBetweenMapPoints(point1,point2);
    if (distance>1000) {
        return [NSString stringWithFormat:@"（%.2f公里）",distance/1000.00];
    }else{
        return [NSString stringWithFormat:@"（%.0f米）",distance];
    }
}


- (void)hidden{
    
    if (self.isShow) {
        CGRect newFrame = self.frame;
        newFrame.origin.y = SYSTEM_HEIGHT;
        [UIView animateWithDuration:0.1 animations:^{
            self.frame = newFrame;
        }];
    }
    self.isShow = NO;
}

@end
