//
//  ResetPasswdViewController.m
//  MXFootball
//
//  Created by Libra on 2018/7/3.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "ResetPasswdViewController.h"

@interface ResetPasswdViewController ()<UITextFieldDelegate> {
    NSTimer *_timer;//定时器
    NSInteger _num;//定时倒计数
}

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextField *phonenumTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwd1;
@property (weak, nonatomic) IBOutlet UITextField *passwd2;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, strong) LoginModel *login;//修改信息

@end

@implementation ResetPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
    self.backBtn.hidden = self.isHidden;
    
    self.codeBtn.layer.borderColor = WhiteColor.CGColor;
    
    [self.phonenumTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwd1 setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwd2 setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.sureBtn.layer.borderColor = WhiteColor.CGColor;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self resetBtn];
    [self resetTimer];
}

#pragma mark -- action

- (IBAction)gobackLogin:(id)sender {
    [self goBack];
}

//发送前先判断手机号输入是否正确
- (IBAction)getCode:(id)sender {
    if (!self.phonenumTF.text || !self.login.registerPhoneNum ) {
        [self showMassage:@"请输入手机号"];
        return;
    }
    if (self.phonenumTF.text.length != 11) {
        [self showMassage:@"手机号有误"];
        return;
    }
    
    weakSelf(self);
    //判断手机号是否注册过或绑定过
    NSString *timeStr = [LJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.login.registerPhoneNum forKey:@"telephone"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    [[WebManager sharedManager] LSGetCheckPhoneBindWithParameters:allParams success:^(LSLJSuccessData *data) {
        if ([data.code isEqualToString:@"0"] || [data.code isEqualToString:@"1021"] || [data.code isEqualToString:@"1022"] || [data.code isEqualToString:@"1023"]) {
            //手机号正常，可收取验证码
            [weakSelf getCodeNum];
        } else {
            //其他错误情况
            [weakSelf showMassage:data.msg];
        }

    } failure:^(NSString *error) {
        [weakSelf showMassage:error];
    }];
}

//密码设置完成。提交。先判断输入是否正确
- (IBAction)resetPasswd:(id)sender {
    weakSelf(self);
    [self isForgetWithSuccess:^(BOOL isCorrect) {
        if (isCorrect) {
            [weakSelf reset];
        }
    } failure:^(NSString *errorString) {
        [weakSelf showMassage:errorString];
    }];
}

//重置密码
- (void)getCodeNum {
    weakSelf(self);
    [self showWaiting];
    
    //接口
    NSString *timeStr = [LJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.login.registerPhoneNum forKey:@"telephone"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    [[WebManager sharedManager] LSGetSendCodeWithParameters:allParams success:^(LSLJSuccessData *data) {
        [weakSelf hideWaiting];
        if ([data.code isEqualToString:@"0"]) {
            [weakSelf setBtn];
            [weakSelf showMassage:@"验证码发送成功"];
        } else {
            [weakSelf showMassage:data.msg];
        }
    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf resetTimer];
        [weakSelf resetBtn];
        [weakSelf showMassage:error];
    }];
}

//重置密码
- (void)reset {
    weakSelf(self);
    [self showWaiting];
    
    NSString *timeStr = [LJUtil getNowDateTimeString];
    self.login.registerPasswd1 = [self.login.registerPasswd1 MD5];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.login.registerPhoneNum forKey:@"telephone"];
    [parameters setObject:self.login.code forKey:@"code"];
    [parameters setObject:self.login.registerPasswd1 forKey:@"newPassword"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    [[WebManager sharedManager] LSGetForgetPasswdWithParameters:allParams success:^(NSString *msg, NSString *code) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:msg];
        if ([code isEqualToString:@"0"]) {
            [weakSelf goRootBack];
        }
    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

#pragma mark -- 定时器
//定时器执行方法
- (void)timechang:(id)sender {
    _num--;
    
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
    
    if (_num == 0) {
        [self resetBtn];
        [self resetTimer];
    }
}

//设置button和开启定时器
- (void)setBtn {
    self.codeBtn.enabled = NO;
    self.codeBtn.layer.borderWidth = 0;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechang:) userInfo:nil repeats:YES];
}

//重置button
- (void)resetBtn {
    self.codeBtn.enabled = YES;
    _num = 59;
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.codeBtn.layer.borderWidth = 1;
}

//重置定时器
- (void)resetTimer {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.phonenumTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.passwd1 resignFirstResponder];
    [self.passwd2 resignFirstResponder];
}

#pragma mark -- textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 200:
            self.login.registerPhoneNum = textField.text;
            break;
        case 201:
            self.login.code = textField.text;
            break;
        case 202:
            self.login.registerPasswd1 = textField.text;
            break;
        case 203:
            self.login.registerPasswd2 = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (textField.tag == 200) {
        return (newString.length <= 11);
    } else if (textField.tag == 201) {
        return (newString.length <= 6);
    } else if (textField.tag == 202) {
        return (newString.length <= 12);
    } else if (textField.tag == 203) {
        return (newString.length <= 12);
    } else {
        return NO;
    }
}

#pragma mark -- UI
- (void)initUIView {
    [self initTitleViewWithTitle:@"忘记密码"];
    [self setBackButton:YES];
    
    _num = 59;
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

#pragma mark -- 验证
/**
 判断忘记密码是否填写完整
 
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isForgetWithSuccess:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure {
    NSDictionary *dic = [self forget];
    if ([[dic valueForKey:@"result"] isEqualToString:@"no"]) {
        failure([dic valueForKey:@"hint"]);
    } else {
        success(YES);
    }
}

/**
 忘记密码时判断所填信息是否正确
 
 @return <#return value description#>
 */
- (NSDictionary *)forget {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"yes" forKey:@"result"];
    
    if (!self.login.registerPhoneNum || self.login.registerPhoneNum.length != 11) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"手机号码输入有误" forKey:@"hint"];
        return dic;
    }
    if (!self.login.code) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"请输入验证码" forKey:@"hint"];
        return dic;
    }
    
    if (!self.login.registerPasswd1 || self.login.registerPasswd1.length < 6 || self.login.registerPasswd1.length > 12) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"请输入6-12位登录密码" forKey:@"hint"];
        return dic;
    }
    if (!self.login.registerPasswd2 || ![self.login.registerPasswd2 isEqualToString:self.login.registerPasswd1]) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"两次输入密码不同，请重新输入" forKey:@"hint"];
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
