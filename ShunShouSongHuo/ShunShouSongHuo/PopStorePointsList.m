//
//  PopStorePointsList.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//
#define kAllMissionCellHeight 120.0
#define kPopHeaderHight 36.0
#import "Constant.h"
#import "UIButton+Block.h"
#import "StorePointCell.h"
#import "PopStorePointsList.h"

@interface PopStorePointsList ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tabView;
    UILabel *_headerLable;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy  ) OrderStorePopListCallBack callback;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAllMissionCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StorePointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StorePointCell" forIndexPath:indexPath];
    OrderStoreModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CCWeakSelf(self);
    [cell showOrderCellWithStore:model andStoreNaviCallBack:^{
        if (weakself.callback) {
            weakself.callback();
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)showPopViewWith:(OrderStoreModel *)model andPopListCallBack:(OrderStorePopListCallBack)callback{
    self.callback = callback;
    [self addNewModel:model];
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
