//
//  LoginViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/4.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "LoginViewController.h"
#import "UserLocation.h"
#import <SDAutoLayout.h>
#import "CCHTTPRequest.h"
#import "HomePageViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton    *loginButton;
@property (nonatomic, strong) UIImageView *alienLoginView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIImageView *alienwareImageView;
@property (nonatomic, strong) UITextField *mobilePhoneTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UserLocation defaultUserLoaction] getLoaction];
    [self addAlienwareImageView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (accessToken() && ![accessToken() isEmpty]) {
        [self gotoHomePage];
    }
}


- (void)gotoHomePage{
    HomePageViewController *home = [[HomePageViewController alloc]init];
    [self.navigationController pushViewController:home animated:YES];
}

- (void)addAlienwareImageView{
    
    

    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Apluslogo"]];
    [self.view addSubview:logoImageView];
    
    logoImageView.sd_layout
    .topSpaceToView(self.view, 80)
    .centerXEqualToView(self.view)
    .autoHeightRatio(136.00/314.00);
    
    
    UIView *accountView = [[UIView alloc] init];
    accountView.clipsToBounds = YES;
    accountView.layer.cornerRadius = 22.5;
    accountView.layer.borderColor = [UIColor blackColor].CGColor;
    accountView.layer.borderWidth = 2;
    [self.view addSubview:accountView];
    
    accountView.sd_layout
    .leftSpaceToView(self.view,50)
    .rightSpaceToView(self.view,50)
    .topSpaceToView(logoImageView,50)
    .heightIs(45);
    
    
    UIImageView *accountImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personinfo"]];
    accountImageView.frame = CGRectMake(14, 11.5, 22, 22);
    [accountView addSubview:accountImageView];
    
    _mobilePhoneTextField = [[UITextField alloc]init];
    [_mobilePhoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    _mobilePhoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    _mobilePhoneTextField.placeholder = @"请输入手机号";
    _mobilePhoneTextField.font = [UIFont systemFontOfSize:15];
    _mobilePhoneTextField.text = user_phone();
    [accountView addSubview:_mobilePhoneTextField];
    
    _mobilePhoneTextField.sd_layout
    .leftSpaceToView(accountView,50)
    .topSpaceToView(accountView,2)
    .bottomSpaceToView(accountView,2)
    .rightSpaceToView(accountView,15);
    
    
    UIView *passwordView = [[UIView alloc] init];
    passwordView.clipsToBounds = YES;
    passwordView.layer.cornerRadius = 22.5;
    passwordView.layer.borderColor = [UIColor blackColor].CGColor;
    passwordView.layer.borderWidth = 2;
    [self.view addSubview:passwordView];
    
    
    passwordView.sd_layout
    .leftSpaceToView(self.view,50)
    .rightSpaceToView(self.view,50)
    .topSpaceToView(accountView,15)
    .heightIs(45);
    
    UIImageView *passwordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"passportimage"]];
    passwordImageView.frame = CGRectMake(14, 11.5, 22, 22);
    [passwordView addSubview:passwordImageView];
    _passwordTextField = [[UITextField alloc]init];
    _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    [_passwordTextField setKeyboardType:UIKeyboardTypeURL];
    [passwordView addSubview:_passwordTextField];
    
    
    _passwordTextField.sd_layout
    .leftSpaceToView(passwordView,50)
    .topSpaceToView(passwordView,2)
    .bottomSpaceToView(passwordView,2)
    .rightSpaceToView(passwordView,15);
    
    
    UIButton *loginButton = [[UIButton alloc]init];
    loginButton.clipsToBounds = YES;
    loginButton.layer.cornerRadius = 22.5;
    loginButton.backgroundColor = [UIColor customYellowColor];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"e2b500"] forState:UIControlStateHighlighted];
    [loginButton addTarget: self action:@selector(loginWithNameAndPassPort) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    loginButton.sd_layout
    .leftSpaceToView(self.view,50)
    .rightSpaceToView(self.view,50)
    .topSpaceToView(passwordView,50)
    .heightIs(45);
    
    
    self.alienLoginView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alien_login"]];
    [self.view addSubview:self.alienLoginView];
    
    self.alienLoginView.sd_layout
    .bottomSpaceToView(self.view, 0)
    .centerXEqualToView(self.view)
    .autoHeightRatio(568.00/418.00);

}

- (void)loginWithNameAndPassPort{
    //@"139018429720"
    if(_mobilePhoneTextField.text.length<1){
        toast_showInfoMsg(@"请输入账号", 320);
        return;
    }
    if (_passwordTextField.text.length<6) {
        toast_showInfoMsg(@"密码小于六位", 320);
        return;
    }
    show_progress();
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:_mobilePhoneTextField.text key:@"username"];
    [parameters put:_passwordTextField.text key:@"password"];
    [parameters put:myUUID() key:@"device_id"];
    CCWeakSelf(self);
    
    [[CCHTTPRequest requestManager] postWithRequestBodyString:USER_LOGIN_IN parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        dismiss_progress();
        if (error) {
            CCLog(@"登陆失败%@",error.domain);
            toast_showInfoMsg(NSLocalizedStringFromTable(error.domain, @"SeverError", nil), 260);
        }
        else{
            CCLog(@"%@",result);
            [weakself loginSuccessedWith:result];
        }
    }];
}

- (void)loginSuccessedWith:(NSDictionary *)result{
    NSDictionary *userDict = [result objectForKey:@"user"];
    save_AccessToken([result stringForKey:ACCESS_TOKEN]);
    save_FilledInvitationCode(NO);
    save_messageCount(0);
    save_NickName([userDict stringForKey:NICK_NAME]);
    save_DeviceId([userDict stringForKey:DEVICE_ID]);
    save_WeixinId([userDict stringForKey:WEIXIN_ID]);
    save_UserID([userDict stringForKey:@"_id"]);
    save_FreshmanCityTag([userDict stringForKey:FREAHMAN_CITY_TAG]);
    save_UserHeadPhoto([userDict stringForKey:USER_HEAD_PHOTO]);
    save_ParentInvitationCode([userDict stringForKey:PARENT_INVITATION_CODE]);
    save_InvitationCode([userDict stringForKey:MY_INVITATION_CODE]);
    save_NotFreshMan([userDict boolForKey:NOT_FRESHMAN]);
    save_userAge([userDict intForKey:USER_AGE]);
    save_userSex([userDict stringForKey:USER_SEX]);
    save_userPhone([userDict stringForKey:USER_PHONE_NUMBER]);
    [self gotoHomePage];
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
