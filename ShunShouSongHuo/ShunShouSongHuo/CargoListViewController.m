//
//  CargoListViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/8.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CargoListViewController.h"
#import <SDAutoLayout.h>
#import "OrderGoodCell.h"
@interface CargoListViewController ()<UITableViewDelegate,UITableViewDataSource>
//列表用
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CargoListViewController

- (NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"装货清单";
    [self.goodsArray addObjectsFromArray:@[@"",@"",@"",@"",@""]];
    [self addNaviView];
    [self addGoodList];
    [self addBottomView];
}

#pragma mark -----------> 添加导航条
- (void)addNaviView{
    
    CCNavigationBar *navi = [[CCNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_NAVI_HEIGHT) title:self.title];
    [self.view addSubview:navi];
    UIButton *left = [CCControl buttonWithFrame:CGRectMake(0, 0, 80, 20) title:@"" backGroundImage:nil target:self action:@selector(dismissClick)];
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
    .bottomSpaceToView(self.view,60)
    .topSpaceToView(self.view,SYSTEM_NAVI_HEIGHT);
}



#pragma mark -----------> UITabelView delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderGoodCell" forIndexPath:indexPath];
    [cell showCellWithIndexPath:indexPath];
    return cell;
}


- (void)addBottomView{
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTEM_HEIGHT-60, SYSTEM_WIDTH, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [bottomView addSubview:lineView];
    
    UIButton * reselectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reselectButton.clipsToBounds = YES;
    reselectButton.layer.cornerRadius = 20;
    reselectButton.layer.borderColor = [UIColor blackColor].CGColor;
    reselectButton.layer.borderWidth = 2;
    reselectButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [reselectButton setTitle:@"重新选店" forState:UIControlStateNormal];
    [reselectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reselectButton setBackgroundImage:[UIImage imageNamed:@"F5F5F5"] forState:UIControlStateHighlighted];
    [bottomView addSubview:reselectButton];
    
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.clipsToBounds = YES;
    confirmButton.layer.cornerRadius = 20;
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    confirmButton.backgroundColor = UIColorFromRGB(0xFF3B30);
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"cc2f27"] forState:UIControlStateHighlighted];
    [bottomView addSubview:confirmButton];
    reselectButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(bottomView)
    .leftSpaceToView(bottomView,15)
    .widthIs((SYSTEM_WIDTH)/3);
    
    confirmButton.sd_layout
    .heightIs(40)
    .centerYEqualToView(bottomView)
    .leftSpaceToView(reselectButton,10)
    .rightSpaceToView(bottomView,15);
}

- (void)dismissClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
