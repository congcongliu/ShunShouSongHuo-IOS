//
//  OrderDetailViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/10.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "NoDataView.h"
#import "LinkFailed.h"
#import "CCHTTPRequest.h"
#import "GoodDetailCell.h"
#import "StoreDetailModel.h"
#import "CustomIOSAlertView.h"
#import <UIImageView+WebCache.h>
#import "OrderRemarkViewController.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) ActivityModel  *activityModel;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, assign) BOOL           isCheckOrder;
@property (nonatomic, strong) NoDataView     *emptyListView;
@property (nonatomic, strong) LinkFailed     *defaultView;
@property (nonatomic, copy  ) NSString       *activityId;
@end

@implementation OrderDetailViewController

- (instancetype)initWithActivityModel:(ActivityModel*)activityModel isCheckOrder:(BOOL)isCheckOrder
{
    self = [super init];
    if (self) {
        self.activityModel = activityModel;
        self.activityId    = activityModel._id;
        self.isCheckOrder  = isCheckOrder;
    }
    return self;
}

- (NoDataView *)emptyListView{
    if (!_emptyListView) {
        _emptyListView = [[NoDataView alloc]initWithFrame:self.tableView.bounds];
        _emptyListView.backgroundColor = [UIColor whiteColor];
        _emptyListView.messageLabel.text = @"没有货物";
    }
    return _emptyListView;
}

- (NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单查看";
    [self addNaviView];
    [self addTabelView];
    [self addButtonView];
    [self getOrderDetail];
}

#pragma mark -----------> 添加导航条
- (void)addNaviView{
    
    CCNavigationBar *navi = [[CCNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_NAVI_HEIGHT) title:self.title];
    [self.view addSubview:navi];
    UIButton *left = [CCControl buttonWithFrame:CGRectMake(0, 0, 80, 20) title:@"" backGroundImage:nil target:self action:@selector(naviBackClick)];
    [navi addLeftButton:left];
    
    if (self.isCheckOrder) {
        UIButton * addRemarkButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH-80, 20, 60, 44)];
        [addRemarkButton setTitle:@"添加备注" forState:UIControlStateNormal];
        addRemarkButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [addRemarkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addRemarkButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [addRemarkButton addTarget:self action:@selector(addRemarkClick) forControlEvents:UIControlEventTouchUpInside];
        [navi addSubview:addRemarkButton];
    }
}

- (void)addRemarkClick{
    OrderRemarkViewController *remark = [[OrderRemarkViewController alloc]initWithActiviyId:self.activityModel._id];
    [self.navigationController pushViewController:remark animated:YES];
}

- (void)addTabelView{
    self.tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 80;
    [_tableView registerNib:[UINib nibWithNibName:@"GoodDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GoodDetailCell"];
    [self.view addSubview:_tableView];
    
    
    
    _tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,SYSTEM_NAVI_HEIGHT)
    .bottomSpaceToView(self.view,60);
    
    
    //链接失败的图片
    CCWeakSelf(self);
    _defaultView = [[LinkFailed alloc]initWithFrame:self.view.bounds callBack:^{
        [weakself getOrderDetail];
    }];
    
    [self.view addSubview:_defaultView];
    _defaultView.hidden = YES;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activityModel.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodModel *goodModel = self.activityModel.goods[indexPath.row];
    GoodDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailCell" forIndexPath:indexPath];
    [cell showCellWithModel:goodModel indexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.activityModel.goods.count>0 ? 0.5 :0;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    footerView.backgroundColor = [UIColor customGrayColor];
    return footerView;
}

- (UIView *)tableFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 200)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    if (self.activityModel.order_signature&&self.activityModel.order_signature.key) {
        UIImageView *signatureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH/2, 20, SYSTEM_WIDTH/2, SYSTEM_WIDTH*(SYSTEM_WIDTH-104)/SYSTEM_HEIGHT/2)];
        [signatureImageView setContentMode:UIViewContentModeScaleAspectFill];
        [footerView addSubview:signatureImageView];
        [signatureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_HEARDER_URL,self.activityModel.order_signature.key]] placeholderImage:nil options:SDWebImageLowPriority];
    }
    return footerView;
}


- (void)addButtonView{
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60)];
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor grayTextColor];
    [bottomView addSubview:lineView];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = NSLocalizedString(@"bs_total_price", nil);
    tipLabel.font = fontBysize(14);
    
    [bottomView addSubview:tipLabel];
    
    tipLabel.sd_layout
    .leftSpaceToView(bottomView,20)
    .centerYEqualToView(bottomView)
    .widthIs(60)
    .autoHeightRatio(0);
    
    UILabel *totalPriceLabel = [[UILabel alloc]init];
    totalPriceLabel.text = [NSString stringWithFormat:@"￥ %.2f",self.activityModel.order_total_price.floatValue/100.00];
    totalPriceLabel.textColor = [UIColor customRedColor];
    totalPriceLabel.font = [UIFont boldSystemFontOfSize:16];
    [bottomView addSubview:totalPriceLabel];
    
    totalPriceLabel.sd_layout
    .leftSpaceToView(tipLabel,0)
    .centerYEqualToView(bottomView)
    .widthIs(200)
    .autoHeightRatio(0);
    
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.clipsToBounds = YES;
    rightButton.layer.cornerRadius = 20;
    [bottomView addSubview:rightButton];
    if (self.isCheckOrder) {
        
        [rightButton setBackgroundColor:[UIColor customRedColor]];
        [rightButton setTitle:@"确认送达" forState:UIControlStateNormal];
        rightButton.titleLabel.font = fontBysize(15);
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        [rightButton setBackgroundColor:[UIColor whiteColor]];
        [rightButton setTitle:@"返回" forState:UIControlStateNormal];
        rightButton.titleLabel.font = fontBysize(16);
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(naviBackClick) forControlEvents:UIControlEventTouchUpInside];
        rightButton.layer.borderColor = [UIColor blackColor].CGColor;
        rightButton.layer.borderWidth = 2;
    }
    
    rightButton.sd_layout
    .rightSpaceToView(bottomView,20)
    .centerYEqualToView(bottomView)
    .widthIs(120)
    .heightIs(40);
}

- (void)confirmOrder{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerImage:@"alert_normol" message:@"你确定此运单中所有货物已送到指定门店了吗？" buttons:@[NSLocalizedString(@"cancel", nil),NSLocalizedString(@"w_i_am_sure", nil)]];
    CCWeakSelf(self);
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if (buttonIndex==1) {
            [weakself deliveryGoods];
        }
        [alertView close];
    }];
    [alertView show];
}


- (void)deliveryGoods{
    show_progress();
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:self.activityModel._id key:@"activity_id"];
    
    CCWeakSelf(self);
    [[CCHTTPRequest requestManager] postWithRequestBodyString:USER_CONFIRM_DELIVEY parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        dismiss_progress();
        if (error) {
            CCLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 200);
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDER_GOODS_DElIVERYED_NOTI object:nil];
            if (weakself.activityCount==1) {
                toast_showInfoMsg(@"门店配送完成", 200);
                [weakself naviBackToStoreList];
            }else{
                toast_showInfoMsg(@"配送完成", 200);
                [weakself naviBackClick];
            }
        }
    }];
}

- (void)getOrderDetail{
    show_progress();
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:self.activityModel._id key:@"activity_id"];
    [[CCHTTPRequest requestManager] getWithRequestBodyString:USER_GET_ORDER_DETAIL parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        dismiss_progress();
        if (error) {
            CCLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 200);
        }else{
            //            CCLog(@"门店详情%@",result);
            NSDictionary *activityDict= [result objectForKey:@"activity"];
            weakself.activityModel = [[ActivityModel alloc]initWithDictionary:activityDict error:nil];
            weakself.activityModel._id = weakself.activityId;
        }
        if (error.code == -404) {
            _defaultView.hidden = NO;
        }
        else{
            _defaultView.hidden = YES;
        }
        if (weakself.activityModel.goods.count==0) {
            [weakself.tableView addSubview:weakself.emptyListView];
        }else{
            [weakself.emptyListView removeFromSuperview];
        }
        [weakself.tableView reloadData];
        weakself.tableView.tableFooterView = [weakself tableFooterView];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)naviBackToStoreList{
    NSInteger pageIndex = self.navigationController.viewControllers.count;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:pageIndex-3] animated:YES];
}


//- (void)getStoreDetail{
//    dismiss_progress();
//    show_progress();
//    CCWeakSelf(self);
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//    [parameters put:accessToken() key:ACCESS_TOKEN];
//    [parameters put:self.storeId key:@"private_poi_id"];
//    [[CCHTTPRequest requestManager] getWithRequestBodyString:USER_GET_STORE_DETAIL parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
//        dismiss_progress();
//        if (error) {
//            toast_showInfoMsg(@"递交成功", 200);
//            [weakself naviBackClick];
//        }else{
//
//            NSDictionary *orderDetailDict = [result objectForKey:@"poi_order_info"];
//            StoreDetailModel* storeDetailModel = [[StoreDetailModel alloc]initWithDictionary:orderDetailDict error:nil];
//            if (storeDetailModel.activities.count==0) {
//                toast_showInfoMsg(@"门店配送完成", 200);
//                [weakself naviBackToStoreList];
//            }else{
//                toast_showInfoMsg(@"配送完成", 200);
//                [weakself naviBackClick];
//            }
//        }
//    }];
//}
//


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
