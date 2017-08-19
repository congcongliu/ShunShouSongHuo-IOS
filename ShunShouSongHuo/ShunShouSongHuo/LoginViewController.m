//
//  LoginViewController.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/4.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "LoginViewController.h"
#import "UserLocation.h"
#import "CCHTTPRequest.h"
#import "LoginTimeView.h"
#import "CustomIOSAlertView.h"
#import "HomePageViewController.h"
@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIView      *bodyView;
@property (nonatomic, strong) UIButton    *loginButton;
@property (nonatomic, strong) UIView      *accountView;
@property (nonatomic, strong) UIImageView *logoImageView;
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
    [self addDebugUrl];
//    CCLog(@"-------->%@",accessToken());
    [self performSelector:@selector(getAppInfo) withObject:nil afterDelay:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)addDebugUrl{
#if DEBUG
    UIView *serverSetView = [[UIView alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH-44, 20, 44, 44)];
    serverSetView.userInteractionEnabled = YES;
    [self.view addSubview:serverSetView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetServerAddress)];
    tap.numberOfTapsRequired = 5;
    [serverSetView addGestureRecognizer:tap];
#else
#endif
}

#pragma mark  ----------> debug 下 重新设置 地址

- (void)resetServerAddress{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置服务器地址" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *passWordTextFelild = [alertView textFieldAtIndex:0];
    passWordTextFelild.placeholder = @"请输服务器地址";
    passWordTextFelild.text = user_diyUrl();
    passWordTextFelild.keyboardType = UIKeyboardTypeURL;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        return;
    }
    UITextField *passWordTextFelild = [alertView textFieldAtIndex:0];
    NSLog(@"PassWord%@",passWordTextFelild.text);
    if ([passWordTextFelild.text isEmpty]) {
        toast_showInfoMsg(@"请输入地址", 200);
    }else{
        save_userDiyUrl(passWordTextFelild.text);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"地址设置成功" message:[NSString stringWithFormat:@"地址%@",passWordTextFelild.text] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (accessToken() && ![accessToken() isEmpty]) {
        [self gotoHomePage];
        [LoginTimeView showLoginWindow];
    }
}

- (void)gotoHomePage{
    HomePageViewController *home = [[HomePageViewController alloc]init];
    [self.navigationController pushViewController:home animated:YES];
    [self.view endEditing:YES];
}

- (void)addAlienwareImageView{
    
    self.logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header_logo"]];
    [self.view addSubview:_logoImageView];
    
    _logoImageView.sd_layout
    .topSpaceToView(self.view, 65)
    .centerXEqualToView(self.view)
    .autoHeightRatio(86.00/342.00);
    
    self.bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, SYSTEM_HEIGHT)];
    self.bodyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bodyView];
    
    self.alienLoginView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alien_login"]];
    [self.bodyView addSubview:self.alienLoginView];
    
    self.alienLoginView.sd_layout
    .topSpaceToView(self.bodyView, 150)
    .centerXEqualToView(self.bodyView)
    .autoHeightRatio(568.00/418.00);
    
    self.accountView = [[UIView alloc] init];
    _accountView.clipsToBounds = YES;
    _accountView.layer.cornerRadius = 22.5;
    _accountView.layer.borderColor = [UIColor blackColor].CGColor;
    _accountView.layer.borderWidth = 2;
    [self.bodyView addSubview:_accountView];
    
    _accountView.sd_layout
    .leftSpaceToView(self.bodyView,50)
    .rightSpaceToView(self.bodyView,50)
    .topSpaceToView(self.alienLoginView,-20)
    .heightIs(45);
    
    
    UIImageView *accountImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personinfo"]];
    accountImageView.frame = CGRectMake(14, 11.5, 22, 22);
    [_accountView addSubview:accountImageView];
    
    _mobilePhoneTextField = [[UITextField alloc]init];
    [_mobilePhoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    _mobilePhoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    _mobilePhoneTextField.placeholder = @"请输入手机号";
    _mobilePhoneTextField.font = [UIFont systemFontOfSize:15];
    _mobilePhoneTextField.text = user_phone();
    [_accountView addSubview:_mobilePhoneTextField];
    
    _mobilePhoneTextField.sd_layout
    .leftSpaceToView(_accountView,50)
    .topSpaceToView(_accountView,2)
    .bottomSpaceToView(_accountView,2)
    .rightSpaceToView(_accountView,15);
    
    
    UIView *passwordView = [[UIView alloc] init];
    passwordView.clipsToBounds = YES;
    passwordView.layer.cornerRadius = 22.5;
    passwordView.layer.borderColor = [UIColor blackColor].CGColor;
    passwordView.layer.borderWidth = 2;
    [self.bodyView addSubview:passwordView];
    
    
    passwordView.sd_layout
    .leftSpaceToView(self.bodyView,50)
    .rightSpaceToView(self.bodyView,50)
    .topSpaceToView(_accountView,15)
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
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    [_passwordTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
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
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"e2b500"] forState:UIControlStateHighlighted];
    [loginButton addTarget: self action:@selector(loginWithNameAndPassPort) forControlEvents:UIControlEventTouchUpInside];
    [self.bodyView addSubview:loginButton];
    
    loginButton.sd_layout
    .leftSpaceToView(self.bodyView,50)
    .rightSpaceToView(self.bodyView,50)
    .topSpaceToView(passwordView,20)
    .heightIs(45);

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.alienLoginView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.bodyView.frame = CGRectMake(0, -keyboardSize.height, SYSTEM_WIDTH, SYSTEM_HEIGHT);
    }];
}
- (void)keyboardWillHidden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bodyView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        self.alienLoginView.hidden = NO;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark --------> 更新
- (void)getAppInfo{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"deliveryman" forKey:@"app_edition"];
    
    [[CCHTTPRequest requestManager] getWithRequestBodyString:USER_APP_INFO_URL parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"%@",error.domain);
        }
        else{
            NSDictionary *appinfoDict = result[@"app_info"][@"ios_app"];
            save_isForce([appinfoDict boolForKey:@"force"]);
            save_UpdateLinke([appinfoDict stringForKey:@"app_store_id"]);
            NSString *title = [appinfoDict stringForKey:@"update_content"];
            save_ServerVersion([appinfoDict objectForKey:@"version_code"]);
            if (server_version().intValue > APPVERSION.intValue) {
                //版本更新
                [self updateAppWithTitle:title];
            }
        }
    }];
    
}


- (void)updateAppWithTitle:(NSString *)title{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    if (app_isfarce()) {
        [alertView setContainerImage:@"alert_normol" message:title buttons:@[NSLocalizedString(@"l_update_immediate", nil)]];
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:update_link()]];
            exit(0);
        }];
    }else{
        [alertView setContainerImage:@"alert_normol" message:title buttons:@[NSLocalizedString(@"l_update_later", nil),NSLocalizedString(@"l_update_immediate", nil)]];
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            if (buttonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:update_link()]];
                exit(0);
            }
            [alertView close];
        }];
    }
    [alertView show];
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
