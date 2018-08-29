//
//  LoginViewController.m
//  MXFootball
//
//  Created by Libra on 2018/7/2.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ResetPasswdViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) LoginModel *login;//登录信息

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.loginBtn.layer.borderColor = WhiteColor.CGColor;
    
//    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;//去掉导航栏下面的线
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.phoneTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwdTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark -- actions
//关闭
- (IBAction)closeVC:(id)sender {
//    if ([PersonDataManager instance].user) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
        UIViewController * presentingViewController = self.presentingViewController;
        while (presentingViewController.presentingViewController) {
            presentingViewController = presentingViewController.presentingViewController;
            
        }
        [presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
}

//登录
- (IBAction)loginAction:(id)sender {
    weakSelf(self);
    [self isLoginCompleteWithTextWithSuccess:^(BOOL isCorrect) {
        if (isCorrect) {
            [weakSelf getLogin];
        }
    } failure:^(NSString *errorString) {
        [weakSelf showMassage:errorString];
    }];
}

//注册
- (IBAction)registerAction:(id)sender {
    RegisterViewController *regist = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}

//忘记密码
- (IBAction)forgetPasswdAction:(id)sender {
    ResetPasswdViewController *reset = [[ResetPasswdViewController alloc] init];
    reset.isHidden = NO;
    [self.navigationController pushViewController:reset animated:YES];
}

#pragma mark -- Net
- (void)getLogin {
    NSString *timeStr = [LJUtil getNowDateTimeString];
    self.login.registerPasswd1 = [self.login.registerPasswd1 MD5];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.login.registerPhoneNum forKey:@"telephone"];
    [parameters setObject:self.login.registerPasswd1 forKey:@"password"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    weakSelf(self);
    [self showWaiting];
    [[WebManager sharedManager] LSGetLoginWithParameters:allParams success:^(LSLJSuccessData *data) {
        [weakSelf hideWaiting];
        if (![data.code isEqualToString:@"0"]) {
            [weakSelf showMassage:data.msg];
        } else {
            [weakSelf showMassage:data.msg];
            NSDictionary *dataDic = data.data;
            [PersonDataManager instance].user = [User mj_objectWithKeyValues:dataDic];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.phoneTF resignFirstResponder];
    [self.passwdTF resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 500) {
    self.login.registerPhoneNum = textField.text;
    }
    if (textField.tag == 501) {
        self.login.registerPasswd1 = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (textField.tag == 500) {
        return (newString.length <= 11);
    } else if (textField.tag == 501) {
        return (newString.length <= 12);
    } else {
        return NO;
    }
}

#pragma mark - UI
- (void)initUIView {
    [self setBackButton:YES];
    [self initTitleViewWithTitle:@"登录"];
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

#pragma mark -- 验证
/**
 判断登录是否填写完整
 
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isLoginCompleteWithTextWithSuccess:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure {
    NSDictionary *dic = [self loginData];
    if ([[dic valueForKey:@"result"] isEqualToString:@"no"]) {
        failure([dic valueForKey:@"hint"]);
    } else {
        success(YES);
    }
}

//登录时判断所填信息是否正确
- (NSDictionary*)loginData {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"yes" forKey:@"result"];
    
    if (!self.login.registerPhoneNum || self.login.registerPhoneNum.length != 11) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"手机号码输入有误" forKey:@"hint"];
        return dic;
    }
    if (!self.login.registerPasswd1 || self.login.registerPasswd1.length < 6 || self.login.registerPasswd1.length > 12) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"密码输入有误" forKey:@"hint"];
        return dic;
    }
    
    return dic;
}

#pragma mark --
- (LoginModel *)login {
    if (!_login) {
        _login = [[LoginModel alloc] init];
    }
    return _login;
}

#pragma mark ---
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
