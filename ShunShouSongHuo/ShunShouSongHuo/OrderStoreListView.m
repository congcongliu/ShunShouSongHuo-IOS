//
//  OrderStoreListView.m
//  AgilePOPs
//
//  Created by CongCong on 2017/7/21.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "OrderStoreListView.h"
#import "CCTool.h"
#import "CCAlert.h"
#import <MJRefresh.h>
#import "NoDataView.h"
#import "LinkFailed.h"
#import "UserLocation.h"
#import "CCHTTPRequest.h"
#import "NSString+Tool.h"
#import "ZRefreshHeader.h"
#import "OrderStoreCell.h"
#import "CustomIOSAlertView.h"
#import <UIView+SDAutoLayout.h>
#import "UIColor+CustomColors.h"
#import "NSMutableDictionary+Tool.h"
@interface OrderStoreListView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    int _limit;//条数限制
    int _skipCount;//跳 过 几条
    int _totoalCount;// 总数
    int _selectedIndex;
    CLLocationCoordinate2D _centerLocation;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView    *tabView;
@property (nonatomic, strong) NoDataView     *emptyListView;
@property (nonatomic, strong) LinkFailed     *defaultView;;
@property (nonatomic, assign) NSInteger      currentPage;
@property (nonatomic, assign) BOOL           isMyStore;
//搜索用
@property (nonatomic, strong) UITextField    *searchTextFiled;
@property (nonatomic, copy  ) NSString       *searchKey;
@property (nonatomic, copy  ) OrderStoreListSeletedCallBack callback;
@end

@implementation OrderStoreListView

- (instancetype)initTokenStoreListWithFrame:(CGRect)frame andSeletedCallBack:(OrderStoreListSeletedCallBack)callBack{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.callback = callBack;
        self.isMyStore = YES;
        [self initData];
//        [self initSearchView];
        [self initStoreList];
    }
    return self;
}

- (instancetype)initVaildStoreListWithFrame:(CGRect)frame andSeletedCallBack:(OrderStoreListSeletedCallBack)callBack{
    self = [super initWithFrame:frame];
    if (self) {
        self.callback = callBack;
        [self initData];
        [self initSearchView];
        [self initStoreList];
    }
    return self;
}

- (void)initData{
    _limit = 10;
    _currentPage = 0;
    _skipCount = 0;
    _totoalCount = 0;
    _selectedIndex = -1;

}

- (void)reloadData{
    _currentPage = 0;
    _selectedIndex = -1;
    [self requestDataFromSever];
    [self.searchTextFiled resignFirstResponder];
}

- (void)tableRefesh{
//    if (!self.dataArray.count) {
        _selectedIndex = -1;
        [self.tabView.mj_header beginRefreshing];
//    }
}

- (NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NoDataView *)emptyListView{
    
    if (!_emptyListView) {
        _emptyListView = [[NoDataView alloc]initWithFrame:self.bounds];
        _emptyListView.backgroundColor = [UIColor whiteColor];
    }
    return _emptyListView;
}

- (void)requestDataFromSever{
    
    _currentPage++;
    if (_currentPage==1) {
        _skipCount = 0;
    }else{
        _skipCount = (int)self.dataArray.count;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters putInt:(int)_currentPage key:@"current_page"];
    [parameters putInt:_limit key:@"limit"];
    [parameters putInt:_skipCount key:@"skip_count"];
    [parameters put:@"distance" key:@"sort_key"];
    [parameters put:self.searchKey key:@"search_key"];
    _centerLocation = [[UserLocation defaultUserLoaction] userLoaction];
    double lat = _centerLocation.latitude;
    double lon = _centerLocation.longitude;
    [parameters put:@[[NSNumber numberWithDouble:lon],[NSNumber numberWithDouble:lat]] key:@"center_location"];
    if (self.isMyStore) {
        [parameters put:@"my_claim_list" key:@"list_type"];
    }else{
        [parameters put:@"can_claim_list" key:@"list_type"];
    }
    [parameters put:accessToken() key:ACCESS_TOKEN];
    CCWeakSelf(self);
    
    [[CCHTTPRequest requestManager] getWithRequestBodyString:USER_GET_STORE_LIST parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 200);
            [weakself.tabView.mj_header endRefreshing];
            [weakself.tabView.mj_footer endRefreshing];
        }
        else{
            //NSLog(@"%@",result);
            NSArray *pois = [result objectForKey:@"pois"];

            NSLog(@"pois Count==========> %lu  ",(unsigned long)pois.count);
            if (_currentPage==1) {
                //刷新
                [weakself.dataArray removeAllObjects];
            }
            for (NSDictionary *poiDict in pois) {
                OrderStoreModel *model = [[OrderStoreModel alloc]initWithDictionary:poiDict error:nil];
                [weakself.dataArray addObject:model];
            }

            [weakself.tabView reloadData];
            [weakself.tabView.mj_header endRefreshing];
            
            if (pois.count<10) {
                [weakself.tabView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [weakself.tabView.mj_footer endRefreshing];
            }
        }
        
        if (error.code == -404&&self.dataArray.count==0) {
            _defaultView.hidden = NO;
        }
        else{
            _defaultView.hidden = YES;
        }

        if (weakself.dataArray.count==0) {
            [weakself.tabView addSubview:weakself.emptyListView];
        }
        else{
            [weakself.emptyListView removeFromSuperview];
        }
        dismiss_progress();
    }];
}


- (void)initStoreList{
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, self.bounds.size.height)];
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.showsVerticalScrollIndicator = NO;
    [_tabView registerNib:[UINib nibWithNibName:@"OrderStoreCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderStoreCell"];

    _tabView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self addSubview:_tabView];
    
    
    CCWeakSelf(self);
    // 下拉刷新
    self.tabView.mj_header= [ZRefreshHeader headerWithRefreshingBlock:^{
        weakself.currentPage = 0;
        [weakself requestDataFromSever];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tabView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself requestDataFromSever];
    }];
    [footer setTitle:NSLocalizedString(@"l_pull_up_will_load_more", nil) forState:MJRefreshStateIdle];
    [footer setTitle:NSLocalizedString(@"l_stop_pull_to_load_more", nil) forState:MJRefreshStatePulling];
    [footer setTitle:NSLocalizedString(@"l_loading_more", nil) forState:MJRefreshStateRefreshing];
    [footer setTitle:NSLocalizedString(@"l_already_load_all", nil) forState:MJRefreshStateNoMoreData];
    
    self.tabView.mj_footer = footer;
    //链接失败的图片
    _defaultView = [[LinkFailed alloc]initWithFrame:self.bounds callBack:^{
        [weakself reloadData];
    }];
    
    [self addSubview:_defaultView];
    _defaultView.hidden = YES;

}
#pragma mark ===> TabView  dataSource  delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (OrderStoreCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderStoreModel *storeModel = [self.dataArray objectAtIndex:indexPath.row];
    OrderStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderStoreCell" forIndexPath:indexPath];
    [cell showStoreCellWithModel:storeModel andIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    OrderStoreModel *storeModel = [self.dataArray objectAtIndex:indexPath.row];
    if (self.callback) {
        self.callback(storeModel);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.dataArray.count>0 ? 0.5 :0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    footerView.backgroundColor = [UIColor customGrayColor];
    return footerView;
}

#pragma mark --------> 添加搜索框
- (void)initSearchView{
    
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.clipsToBounds = YES;
    searchView.layer.cornerRadius = CORNERRADIUS;
    [self addSubview:searchView];
    
    searchView.sd_layout
    .topSpaceToView(self,5)
    .leftSpaceToView(self,15)
    .rightSpaceToView(self,70)
    .heightIs(40);

    self.searchTextFiled = [[UITextField alloc]init];
    [searchView addSubview:_searchTextFiled];
    _searchTextFiled.clearButtonMode = UITextFieldViewModeAlways;
    _searchTextFiled.delegate = self;
    _searchTextFiled.font = fontBysize(15);
    _searchTextFiled.placeholder = NSLocalizedString(@"g_please_input_search_key", nil);
    [_searchTextFiled setReturnKeyType:UIReturnKeySearch];
    
    _searchTextFiled.sd_layout
    .topSpaceToView(searchView,0)
    .leftSpaceToView(searchView,50)
    .rightSpaceToView(searchView,15)
    .heightIs(40);
    
    UIImageView *searchImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    searchImageView.userInteractionEnabled = YES;
    [searchView addSubview:searchImageView];
    [searchImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(reloadData)]];
    
    searchImageView.sd_layout
    .leftSpaceToView(searchView,15)
    .topSpaceToView(searchView,8)
    .widthIs(22)
    .heightIs(22);
    
    UIButton *clearButton = [[UIButton alloc]init];
    [clearButton setTitle:NSLocalizedString(@"g_clear_search_classfiy", nil) forState:UIControlStateNormal];
    clearButton.titleLabel.font = fontBysize(16);
    [clearButton setTitleColor:[UIColor grayTextColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearClick)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearButton];
    
    clearButton.sd_layout
    .topSpaceToView(self,5)
    .rightSpaceToView(self,5)
    .widthIs(60)
    .heightIs(40);
    
}

- (BOOL)textFieldShouldReturn:(UITextView*)textField{
    self.searchKey = textField.text;
    [self reloadData];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self clearClick];
    return YES;
}

- (void)clearClick{
    self.searchTextFiled.text = @"";
    self.searchKey = @"";
    [self reloadData];
    [self.searchTextFiled resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)dealloc{
    NSLog(@"storeList delloc");
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NSLocalizedString(@"c__give_up__", nil);
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete){
//        /*此处处理自己的代码，如删除数据*/
//        OrderStoreModel *storeModel = [self.dataArray objectAtIndex:indexPath.row];
//        CCWeakSelf(self);
//        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
//        [alertView setContainerImage:@"alertnormol" message:NSLocalizedString(@"sl_user_give_up_store", nil) buttons:@[ NSLocalizedString(@"c_let_me_double_think", nil),NSLocalizedString(@"c_give_up", nil)]];
//
//        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
//            if (buttonIndex) {
//                [weakself.dataArray removeObjectAtIndex:indexPath.row];
//                /*删除tableView中的一行*/
//                [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                if (weakself.dataArray.count==0) {
//                    [weakself.tabView addSubview:weakself.emptyListView];
//                }
//                [weakself giveUpStore:storeModel];
//            }
//            [alertView close];
//        }];
//        [alertView show];
//    }
//}
//
//- (void)giveUpStore:(OrderStoreModel*)storeModel{
//    CCWeakSelf(self);
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters put:accessToken() key:ACCESS_TOKEN];
//    [parameters put:storeModel._id key:@"private_poi_id"];
//    [[CCHTTPRequest requestManager] postWithRequestBodyString:@"" parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
//        if (error) {
//            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 200);
//            [weakself reloadData];
//        }else{
//            toast_showInfoMsg(NSLocalizedString(@"c_give_up_succeed", nil), 200);
//        }
//    }];
//}

@end
