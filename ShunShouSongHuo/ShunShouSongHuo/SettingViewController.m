//
//  SettingViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "SettingViewController.h"
#import "CCUserData.h"
#import "CustomIOSAlertView.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *settingArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    // Do any additional setup after loading the view.
    [self addNaviView];
    [self addTableView];
    [self addVisionTips];
}

#pragma mark -----------> 添加导航条
- (void)addNaviView{
    
    CCNavigationBar *navi = [[CCNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_NAVI_HEIGHT) title:self.title];
    [self.view addSubview:navi];
    
    UIButton *left = [CCControl buttonWithFrame:CGRectMake(0, 0, 80, 20) title:@"" backGroundImage:nil target:self action:@selector(naviBackClick)];
    [navi addLeftButton:left];
    
}

- (void)addTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYSTEM_NAVI_HEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTEM_NAVI_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [_tableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingCell"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);

}

- (UIView*)tableHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 5)];
    headerView.backgroundColor = _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 19.5, SYSTEM_WIDTH, 0.5)];
//    lineView.backgroundColor = UIColorFromRGB(0xcccccc);
//    [headerView addSubview:lineView];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.settingArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //判断
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxxx"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 70)];
    
//    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, SYSTEM_WIDTH, 0.5)];
//    lineView1.backgroundColor = UIColorFromRGB(0xcccccc);
//    [footerView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 19.5, SYSTEM_WIDTH, 0.5)];
    lineView2.backgroundColor = UIColorFromRGB(0xcccccc);
    [footerView addSubview:lineView2];
    
    footerView.backgroundColor = _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);;
    UIButton *loginOutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, SYSTEM_WIDTH, 50)];
    [loginOutButton setTitle:NSLocalizedString(@"xx_login_out", nil) forState:UIControlStateNormal];
    loginOutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    loginOutButton.backgroundColor = [UIColor whiteColor];
    [loginOutButton addTarget:self action:@selector(quitThisAccount)
             forControlEvents:UIControlEventTouchUpInside];
    [loginOutButton setTitleColor:[UIColor customRedColor] forState:UIControlStateNormal];
    [footerView addSubview:loginOutButton];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, SYSTEM_WIDTH, 0.5)];
    lineView3.backgroundColor = UIColorFromRGB(0xcccccc);
    [footerView addSubview:lineView3];
    return footerView;
}

- (void)quitThisAccount{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerImage:@"alert_normol" message:NSLocalizedString(@"s_are_you_sure_quit_this_acount", nil) buttons:@[NSLocalizedString(@"cancel", nil),NSLocalizedString(@"w_i_am_sure", nil)]];
    CCWeakSelf(self);
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if (buttonIndex==1) {
            save_AccessToken(@"");
            save_uploadLocation(NO);
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        }
        [alertView close];
    }];
    [alertView show];
}


- (void)addVisionTips{
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.font = fontBysize(12);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = [NSString stringWithFormat:@"v %@",APPVERSION];
    [self.view addSubview:tipLabel];
    
    tipLabel.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,20)
    .autoHeightRatio(0);
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
