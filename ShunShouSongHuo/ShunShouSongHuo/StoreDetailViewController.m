//
//  StoreDetailViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/9.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "LinkFailed.h"
#import "UserLocation.h"
#import "CCHTTPRequest.h"
#import "StoreDeatilCell.h"
#import "SJAvatarBrowser.h"
#import "StoreDetailModel.h"
#import <MAMapKit/MAMapKit.h>
#import <UIImageView+WebCache.h>
#import "NavigationViewController.h"
#import "OrderDetailViewController.h"
@interface StoreDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) OrderStoreModel  *storeModel;
@property (nonatomic, strong) StoreDetailModel *storeDetailModel;
@property (nonatomic, strong) UIView           *headerView;
@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) LinkFailed       *defaultView;
@property (nonatomic, assign) BOOL             isNeedReafesh;
@end

@implementation StoreDetailViewController

- (instancetype)initWithStoreModel:(OrderStoreModel*)storeModel
{
    self = [super init];
    if (self) {
        self.storeModel = storeModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店订单";
    [self addNaviView];
    [self addHeaderView];
    [self addTabelView];
    [self getStoreDetail];
    [[UserLocation defaultUserLoaction] getLoaction];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOrderSucceed)
                                                 name:ORDER_GOODS_DElIVERYED_NOTI object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNeedReafesh) {
        [self getStoreDetail];
    }
    self.isNeedReafesh = NO;
}

- (void)sendOrderSucceed{
    self.isNeedReafesh = YES;
}

#pragma mark -----------> 添加导航条
- (void)addNaviView{
    
    CCNavigationBar *navi = [[CCNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_NAVI_HEIGHT) title:self.title];
    [self.view addSubview:navi];
    UIButton *left = [CCControl buttonWithFrame:CGRectMake(0, 0, 80, 20) title:@"" backGroundImage:nil target:self action:@selector(naviBackClick)];
    [navi addLeftButton:left];
}

- (void)addHeaderView{//120
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_NAVI_HEIGHT, SYSTEM_WIDTH, 180)];
    [self.view addSubview:self.headerView];
    
    UIImageView *storeImageView = [[UIImageView alloc]init];
    storeImageView.clipsToBounds  = YES;
    storeImageView.layer.cornerRadius = 20;
    [self.headerView addSubview:storeImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    storeImageView.userInteractionEnabled = YES;
    [storeImageView addGestureRecognizer:tap];
    [storeImageView setContentMode:UIViewContentModeScaleAspectFill];
    NSString *photoUrl = [self.storeModel.header_photos firstObject];
    [storeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_HEARDER_URL,photoUrl]] placeholderImage:[UIImage imageNamed:@"defaultimage"] options:SDWebImageLowPriority];
    
    storeImageView.sd_layout
    .leftSpaceToView(_headerView,15)
    .topSpaceToView(_headerView,15)
    .widthIs(95)
    .heightIs(95);
    
    UILabel *storeNameLabel = [[UILabel alloc]init];
    storeNameLabel.font = fontBysize(18);
    storeNameLabel.text = self.storeModel.name;
    [self.headerView addSubview:storeNameLabel];
    
    storeNameLabel.sd_layout
    .topEqualToView(storeImageView)
    .leftSpaceToView(storeImageView,15)
    .rightSpaceToView(_headerView,15)
    .heightIs(30);
    
    UILabel *storeAddressLabel = [[UILabel alloc]init];
    storeAddressLabel.font = fontBysize(14);
    storeAddressLabel.numberOfLines = 2;
    storeAddressLabel.text = self.storeModel.address;
    [self.headerView addSubview:storeAddressLabel];
    
    storeAddressLabel.sd_layout
    .topSpaceToView(storeNameLabel,0)
    .leftSpaceToView(storeImageView,15)
    .rightSpaceToView(_headerView,15)
    .heightIs(35);
    
    UILabel *storeContectLabel = [[UILabel alloc]init];
    storeContectLabel.font = fontBysize(14);
    storeContectLabel.text = [NSString stringWithFormat:@"%@ %@", self.storeModel.contact_name, self.storeModel.contact_phone];
    [self.headerView addSubview:storeContectLabel];
    
    storeContectLabel.sd_layout
    .topSpaceToView(storeAddressLabel,0)
    .leftSpaceToView(storeImageView,15)
    .rightSpaceToView(_headerView,15)
    .heightIs(20);
    
    BOOL isEmptyPhone = !self.storeModel||[self.storeModel.contact_phone isEmpty];
    
    UIButton * phoneCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneCallButton.clipsToBounds = YES;
    phoneCallButton.layer.cornerRadius = 20;
    phoneCallButton.layer.borderColor = [UIColor blackColor].CGColor;
    phoneCallButton.layer.borderWidth = 2;
    phoneCallButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [phoneCallButton setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
    [phoneCallButton setTitle:@"  打电话" forState:UIControlStateNormal];
    [phoneCallButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [phoneCallButton setBackgroundImage:[UIImage imageNamed:@"F5F5F5"] forState:UIControlStateHighlighted];
    [phoneCallButton addTarget:self action:@selector(phoneCallButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:phoneCallButton];
    
    phoneCallButton.sd_layout
    .heightIs(40)
    .topSpaceToView(storeImageView,15)
    .leftSpaceToView(_headerView,15)
    .widthIs(isEmptyPhone ? 0 : (SYSTEM_WIDTH-45)/2);
    
    
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
    [self.headerView addSubview:naviButton];
    
    naviButton.sd_layout
    .heightIs(40)
    .topSpaceToView(storeImageView,15)
    .rightSpaceToView(_headerView,15)
    .widthIs(isEmptyPhone ? (SYSTEM_WIDTH - 30) : (SYSTEM_WIDTH-45)/2);
    
}


- (NSString *)getDistance{
    NSNumber *lat = self.storeModel.location[1];
    NSNumber *log = self.storeModel.location[0];
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

- (void)imageViewTap:(UIGestureRecognizer*)sender{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)phoneCallButtonClick{
    callNumber(self.storeModel.contact_phone, self.view);
}


- (void)naviButtonClick{
    NavigationViewController *navi = [[NavigationViewController alloc]initWithStoreModel:self.storeModel];
    [self.navigationController pushViewController:navi animated:YES];
}

- (void)addTabelView{
    self.tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"StoreDeatilCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StoreDeatilCell"];
    _tableView.rowHeight = 190;
    [self.view addSubview:_tableView];
    
    _tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.headerView,0)
    .bottomEqualToView(self.view);
    
    //链接失败的图片
    CCWeakSelf(self);
    _defaultView = [[LinkFailed alloc]initWithFrame:self.view.bounds callBack:^{
        [weakself getStoreDetail];
    }];

    [self.view addSubview:_defaultView];
    _defaultView.hidden = YES;

}

- (void)getStoreDetail{
    dismiss_progress();
    show_progress();
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:self.storeModel._id key:@"private_poi_id"];
    [[CCHTTPRequest requestManager] getWithRequestBodyString:USER_GET_STORE_DETAIL parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        dismiss_progress();
        if (error) {
            CCLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 200);
            if (error.code == -404) {
                _defaultView.hidden = NO;
            }
            else{
                _defaultView.hidden = YES;
            }
        }else{
//            CCLog(@"门店详情%@",result);
            NSDictionary *orderDetailDict = [result objectForKey:@"poi_order_info"];
            weakself.storeDetailModel = [[StoreDetailModel alloc]initWithDictionary:orderDetailDict error:nil];
            if (weakself.storeDetailModel.activities.count==0) {
                toast_showInfoMsg(@"运单配送完成", 200);
                [weakself naviBackClick];
            }else{
                [weakself.tableView reloadData];
            }
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storeDetailModel.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityModel *activityModel = self.storeDetailModel.activities[indexPath.row];
    StoreDeatilCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreDeatilCell" forIndexPath:indexPath];
    [cell showOrderCellWithActivityModel:activityModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityModel *activityModel = self.storeDetailModel.activities[indexPath.row];
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] initWithActivityModel:activityModel isCheckOrder:self.storeModel.self_order_count.integerValue];
    orderDetail.activityCount = self.storeDetailModel.activities.count;
    orderDetail.storeId = self.storeModel._id;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
