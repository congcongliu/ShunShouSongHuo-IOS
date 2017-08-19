//
//  HomePageViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/4.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "HomePageViewController.h"
#import "UserLocation.h"
#import "CCHTTPRequest.h"
#import "OrderStoreMapView.h"
#import "OrderStoreListView.h"
#import "CustomIOSAlertView.h"
#import "PopStorePointsList.h"
#import "SettingViewController.h"
#import "CargoListViewController.h"
#import "NavigationViewController.h"
#import "StoreDetailViewController.h"
@interface HomePageViewController ()<OrderStoreDelegate,PopStoreListDelegate>{
    NSInteger           _selectedIndex;
    OrderStoreMapView  *_storeMap;
    OrderStoreListView *_vaildStoreList;
    OrderStoreListView *_tokenStoreList;
    UIButton           *_cancelSelectButton;
    UIButton           *_completedSelectButton;
    UIButton           *_selectStoreButton;
    UIView             *_bottomView;
}
@property (nonatomic, strong) UIScrollView           *contentView;
@property (nonatomic, strong) OrderStoreMapView      *storeMap;
@property (nonatomic, strong) PopStorePointsList     *popStorePointsList;//弹出列表
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    self.fd_interactivePopDisabled = YES;
    [self addNaviBar];
    [self addMapAndListView];
    [self addBottomView];
    [self initPopListView];
    [self getStorageInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenVaild)
                                                 name:ACCESS_TOKEN_INVAILD_NOTI object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!accessToken()||[accessToken() isEmpty]) {
        [self tokenVaild];
        return;
    }
    
    [[UserLocation defaultUserLoaction] getLoaction];
    switch (_selectedIndex) {
        case 0:
        {
            [_storeMap hiddenPopList];
            [_storeMap reloadData];
            _bottomView.hidden = NO;
        }
            break;
        case 1:
        {
            [_tokenStoreList reloadData];
            _bottomView.hidden = YES;
        }
            break;
        case 2:
        {
            [_vaildStoreList reloadData];
            _bottomView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)addNaviBar{
    
    UISegmentedControl* segmented = [[UISegmentedControl alloc]initWithItems:@[@"地图模式",@"已选门店",@"可选门店"]];
    segmented.selectedSegmentIndex = 0;
    segmented.layer.borderWidth = 2;
    segmented.layer.borderColor = [UIColor blackColor].CGColor;
    segmented.clipsToBounds = YES;
    segmented.layer.cornerRadius = 15;
    [segmented addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    segmented.tintColor = [UIColor blackColor];
    
    NSDictionary *testDic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:13] forKey:NSFontAttributeName];
    [segmented setTitleTextAttributes:testDic forState:UIControlStateNormal];
    [segmented setTitleTextAttributes:testDic forState:UIControlStateSelected];
    
    CCNavigationBar *naviBar = [[CCNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_NAVI_HEIGHT) centerSegmented:segmented andSegmentedFrame:CGRectMake(SYSTEM_WIDTH/2-130, 27, 260, 30)];
    [self.view addSubview:naviBar];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor grayTextColor];
    [naviBar addSubview:lineView];
    
    UIButton * orderListButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH - 60, 20, 60, 44)];
    [orderListButton setTitle:@"清单" forState:UIControlStateNormal];
    orderListButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [orderListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderListButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [orderListButton addTarget:self action:@selector(gotoCargoList) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:orderListButton];
    
    
    UIButton *settingButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SYSTEM_STATUS_BAR_HEIGHT, 44, 44)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_1"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_0"] forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:settingButton];
}

- (void)gotoSetting{
    SettingViewController *setting = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)gotoCargoList{
//    CargoListViewController *cargoList = [[CargoListViewController alloc]init];
//    UINavigationController *cargoNavi = [[UINavigationController alloc]initWithRootViewController:cargoList];
//    [self presentViewController:cargoList animated:YES completion:nil];
    CargoListViewController *cargoList = [[CargoListViewController alloc]initWithSelectStoreCount:[_storeMap getSeletedCount]];
    [self.navigationController pushViewController:cargoList animated:YES];
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    
    if (Seg.selectedSegmentIndex == _selectedIndex) {
        return;
    }
    _selectedIndex = Seg.selectedSegmentIndex;
    switch (_selectedIndex) {
        case 0:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _contentView.sd_resetNewLayout
                .topSpaceToView (self.view,SYSTEM_NAVI_HEIGHT)
                .leftEqualToView (self.view)
                .widthIs(SYSTEM_WIDTH*3)
                .bottomSpaceToView(self.view,0);
                [_contentView updateLayout];
                _bottomView.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _contentView.sd_resetNewLayout
                .topSpaceToView (self.view,SYSTEM_NAVI_HEIGHT)
                .centerXEqualToView(self.view)
                .widthIs(SYSTEM_WIDTH*3)
                .bottomSpaceToView(self.view,0);
                [_contentView updateLayout];
                _bottomView.hidden = YES;
            } completion:^(BOOL finished) {                
                [_tokenStoreList tableRefesh];
            }];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _contentView.sd_resetNewLayout
                .topSpaceToView (self.view,SYSTEM_NAVI_HEIGHT)
                .rightEqualToView(self.view)
                .widthIs(SYSTEM_WIDTH*3)
                .bottomSpaceToView(self.view,0);
                [_contentView updateLayout];
                _bottomView.hidden = YES;
            } completion:^(BOOL finished) {
                [_vaildStoreList tableRefesh];
            }];
        }
            break;

        default:
            break;
    }

}

- (void)addMapAndListView{
    
    _contentView = [[UIScrollView alloc]init];
    _contentView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_contentView];
    _contentView.sd_layout
    .topSpaceToView (self.view,SYSTEM_NAVI_HEIGHT)
    .leftEqualToView (self.view)
    .widthIs(SYSTEM_WIDTH*3)
    .bottomSpaceToView(self.view,0);
    
    _storeMap = [[OrderStoreMapView alloc] initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTEM_NAVI_HEIGHT-60) andDelegate:self];
    
    CCWeakSelf(self);
    _tokenStoreList = [[OrderStoreListView alloc] initTokenStoreListWithFrame:CGRectMake(SYSTEM_WIDTH, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTEM_NAVI_HEIGHT) andSeletedCallBack:^(OrderStoreModel *storeModel) {
        [weakself gotoStoreDetail:storeModel];
    }];
    
    _vaildStoreList = [[OrderStoreListView alloc] initVaildStoreListWithFrame:CGRectMake(SYSTEM_WIDTH*2, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTEM_NAVI_HEIGHT) andSeletedCallBack:^(OrderStoreModel *storeModel) {
        [weakself gotoStoreDetail:storeModel];
    }];
    [_contentView addSubview:_storeMap];
    [_contentView addSubview:_vaildStoreList];
    [_contentView addSubview:_tokenStoreList];
}

#pragma mark -----------> 门店选择模块
- (void)addBottomView{
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor grayTextColor];
    [_bottomView addSubview:lineView];
    
    _cancelSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelSelectButton.clipsToBounds = YES;
    _cancelSelectButton.layer.cornerRadius = 20;
    _cancelSelectButton.layer.borderColor = [UIColor blackColor].CGColor;
    _cancelSelectButton.layer.borderWidth = 2;
    _cancelSelectButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_cancelSelectButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelSelectButton setBackgroundImage:[UIImage imageNamed:@"F5F5F5"] forState:UIControlStateHighlighted];
    _cancelSelectButton.hidden = YES;
    [_cancelSelectButton addTarget:self action:@selector(cancelSelectStore) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_cancelSelectButton];
    
    _completedSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completedSelectButton.clipsToBounds = YES;
    _completedSelectButton.layer.cornerRadius = 20;
    _completedSelectButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_completedSelectButton setTitle:@"完成选择" forState:UIControlStateNormal];
    _completedSelectButton.backgroundColor = UIColorFromRGB(0xFF3B30);
    [_completedSelectButton setBackgroundImage:[UIImage imageNamed:@"cc2f27"] forState:UIControlStateHighlighted];
    _completedSelectButton.hidden = YES;
    [_completedSelectButton addTarget:self action:@selector(completedSelectStore) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_completedSelectButton];
    
    _selectStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectStoreButton.clipsToBounds = YES;
    _selectStoreButton.layer.cornerRadius = 20;
    _selectStoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_selectStoreButton setTitle:@"选择配送门店" forState:UIControlStateNormal];
    _selectStoreButton.backgroundColor = UIColorFromRGB(0xFF3B30);
    [_selectStoreButton setBackgroundImage:[UIImage imageNamed:@"cc2f27"] forState:UIControlStateHighlighted];
    [_selectStoreButton addTarget:self action:@selector(selectStoreClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_selectStoreButton];
    
    _cancelSelectButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(_bottomView)
    .leftSpaceToView(_bottomView,15)
    .widthIs((SYSTEM_WIDTH)/3);
    
    _completedSelectButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(_bottomView)
    .leftSpaceToView(_cancelSelectButton,10)
    .rightSpaceToView(_bottomView,15);
    
    _selectStoreButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(_bottomView)
    .leftSpaceToView(_bottomView,15)
    .rightSpaceToView(_bottomView,15);
}


- (void)selectStoreClick{
    _selectStoreButton.hidden = YES;
    _cancelSelectButton.hidden = NO;
    _completedSelectButton.hidden = NO;
    [_storeMap startSelectStore];
}

- (void)completedSelectStore{
    
    if (_storeMap.selectedStores.count==0) {
        toast_showInfoMsg(@"请至少选择一家门店", 200);
        return;
    }
    
    CCWeakSelf(self);
    CargoListViewController *cargoList = [[CargoListViewController alloc]initWithSelectStoreIds:_storeMap.selectedStores andCallback:^(BOOL isSucceed) {
        [weakself cancelSelectStore];
    }];
//    UINavigationController *cargoNavi = [[UINavigationController alloc]initWithRootViewController:cargoList];
//    [self presentViewController:cargoList animated:YES completion:nil];
    [self.navigationController pushViewController:cargoList animated:YES];
}

- (void)cancelSelectStore{
    _selectStoreButton.hidden = NO;
    _cancelSelectButton.hidden = YES;
    _completedSelectButton.hidden = YES;
    [_storeMap stopSelectStore];
}

//- (void)reSelectStoreSucceed{
////    _selectStoreButton.hidden = NO;
////    _cancelSelectButton.hidden = YES;
////    _completedSelectButton.hidden = YES;
////    _storeMap.isRouted = NO;
////    [_storeMap stopSelectStore];
//}

#pragma mark ----------> 门店详情弹框模块
- (void)initPopListView{
    _popStorePointsList = [[PopStorePointsList alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT)];
    [self.view addSubview:_popStorePointsList];
}

#pragma mark ----------> orderMapDelegate 地图选点回调

- (void)didSeletedStore:(OrderStoreModel *)storeModel{
    [_popStorePointsList showPopViewWith:storeModel andPopStoreListDelegate:self];
}
- (void)didDeseletedStore{
    [_popStorePointsList hidden];
}

- (void)didSelectNaviWithStoreModel:(OrderStoreModel *)storeModel{
    NavigationViewController *navi = [[NavigationViewController alloc]initWithStoreModel:storeModel];
    [self.navigationController pushViewController:navi animated:YES];
}

- (void)didSelectDetailWithStoreModel:(OrderStoreModel *)storeModel{
    [self gotoStoreDetail:storeModel];
}

- (void)gotoStoreDetail:(OrderStoreModel *)storeModel{
    StoreDetailViewController *detail = [[StoreDetailViewController alloc] initWithStoreModel:storeModel];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark ------------> 获取仓库信息
- (void)getStorageInfo{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    CCWeakSelf(self);
    [[CCHTTPRequest requestManager] getWithRequestBodyString:USER_GET_STORAGE parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSDictionary *warehouse = [result objectForKey:@"warehouse"];
            save_StorageAddress([warehouse stringForKey:@"address"]);
            save_StorageLocation([warehouse objectForKey:@"location"]);
            [weakself.storeMap addStorageAnnotationView];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tokenVaild{
    [self performSelector:@selector(naviBack) withObject:nil afterDelay:3];
}

- (void)naviBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
