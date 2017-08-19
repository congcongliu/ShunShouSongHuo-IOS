//
//  CargoListViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/8.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CargoListViewController.h"
#import "GoodModel.h"
#import "NoDataView.h"
#import "LinkFailed.h"
#import "OrderGoodCell.h"
#import "CCHTTPRequest.h"

@interface CargoListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray        *storeIds;
@property (nonatomic, assign) NSInteger      storeCount;
@property (nonatomic, assign) BOOL           isSelectStoreMode;
@property (nonatomic, copy  ) CargoListCallBack callback;

//列表用
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NoDataView     *emptyListView;
@property (nonatomic, strong) LinkFailed     *defaultView;
@end

@implementation CargoListViewController

- (instancetype)initWithSelectStoreCount:(NSInteger)storeCount
{
    self = [super init];
    if (self) {
        self.storeCount = storeCount;
    }
    return self;
}

- (instancetype)initWithSelectStoreIds:(NSArray *)storeIds andCallback:(CargoListCallBack)callback
{
    self = [super init];
    if (self) {
        self.storeIds = storeIds;
        self.storeCount = storeIds.count;
        self.callback = callback;
        self.isSelectStoreMode = YES;
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
    self.title = [NSString stringWithFormat:@"装货清单（%ld家门店）",self.storeCount];
    [self addNaviView];
    [self addGoodList];
    [self getGoodList];
    if (self.isSelectStoreMode) {
        [self addBottomView];
    }
}

#pragma mark -----------> 添加导航条
- (void)addNaviView{
    
    CCNavigationBar *navi = [[CCNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_NAVI_HEIGHT) title:self.title];
    [self.view addSubview:navi];
    UIButton *left = [CCControl buttonWithFrame:CGRectMake(0, 0, 80, 20) title:@"" backGroundImage:nil target:self action:@selector(naviBackClick)];
    [navi addLeftButton:left];
}

#pragma mark -----------> 添加商品列表
- (void)addGoodList{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"OrderGoodCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderGoodCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,SYSTEM_NAVI_HEIGHT)
    .bottomSpaceToView(self.view,self.isSelectStoreMode?60:0);
    
    //链接失败的图片
    CCWeakSelf(self);
    _defaultView = [[LinkFailed alloc]initWithFrame:self.view.bounds callBack:^{
        [weakself getGoodList];
    }];
    [self.view addSubview:_defaultView];
    _defaultView.hidden = YES;
}



#pragma mark -----------> UITabelView delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodModel *goodModel = [self.goodsArray objectAtIndex:indexPath.row];
    OrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderGoodCell" forIndexPath:indexPath];
    [cell showCellWithIndexPath:indexPath andGoodModel:goodModel];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.goodsArray.count>0 ? 0.5 :0;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    footerView.backgroundColor = [UIColor customGrayColor];
    return footerView;
}

- (void)addBottomView{
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor grayTextColor];
    [bottomView addSubview:lineView];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 20;
    cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
    cancelButton.layer.borderWidth = 2;
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"F5F5F5"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelSelectStore) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.clipsToBounds = YES;
    confirmButton.layer.cornerRadius = 20;
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    confirmButton.backgroundColor = UIColorFromRGB(0xFF3B30);
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"cc2f27"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(confirmSelectStore) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmButton];
    cancelButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(bottomView)
    .leftSpaceToView(bottomView,15)
    .widthIs((SYSTEM_WIDTH)/3);
    
    confirmButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(bottomView)
    .leftSpaceToView(cancelButton,10)
    .rightSpaceToView(bottomView,15);
}

- (void)getGoodList{
    show_progress();
    CCWeakSelf(self);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    if (self.isSelectStoreMode) {
        [parameters put:self.storeIds key:@"private_poi_ids"];
    }
    
    [[CCHTTPRequest requestManager] getWithRequestBodyString:USER_GET_GOODS_LIST parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        dismiss_progress();
        if (error) {
            CCLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 200);
        }else{
            //            CCLog(@"门店详情%@",result);
            NSArray *goods = [result objectForKey:@"goods"];
            [weakself.goodsArray removeAllObjects];
            for (NSDictionary *goodDict in goods) {
                GoodModel *goodModel = [[GoodModel alloc] initWithDictionary:goodDict error:nil];
                [weakself.goodsArray addObject:goodModel];
            }
        }
        if (error.code == -404) {
            _defaultView.hidden = NO;
        }
        else{
            _defaultView.hidden = YES;
        }
        if (weakself.goodsArray.count==0) {
            [weakself.tableView addSubview:weakself.emptyListView];
        }else{
            [weakself.emptyListView removeFromSuperview];
        }
        [weakself.tableView reloadData];
    }];

}

- (void)confirmSelectStore{
    show_progress();
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:self.storeIds key:@"private_poi_ids"];
    
    CCWeakSelf(self);
    [[CCHTTPRequest requestManager] postWithRequestBodyString:USER_CLAIM_ORDER_STORE parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        dismiss_progress();
        if (error) {
            CCLog(@"%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 200);
        }else{
            if (weakself.callback) {
                weakself.callback(YES);
            }
            toast_showInfoMsg(@"选店成功", 200);
            [weakself naviBackClick];
        }
    }];
}

- (void)cancelSelectStore{
    [self naviBackClick];
}




- (void)naviBackClick{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
