//
//  RegisterViewController.m
//  MXFootball
//
//  Created by Libra on 2018/7/2.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "RegisterViewController.h"
#import "WKViewController.h"//注册协议

@interface RegisterViewController ()<UITextFieldDelegate> {
    NSTimer *_timer;//定时器
    NSInteger _num;//定时倒计数
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwd1;
@property (weak, nonatomic) IBOutlet UITextField *passwd2;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, strong) LoginModel *login;//注册信息

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.codeButton.layer.borderColor = WhiteColor.CGColor;
    
    [self.phoneTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTF setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwd1 setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwd2 setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.registerBtn.layer.borderColor = WhiteColor.CGColor;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resetTimer];
}

#pragma mark - action
//
- (IBAction)gobackLogin:(id)sender {
    [self goBack];
}

//获取验证码
- (IBAction)getCode:(id)sender {
    if (!self.phoneTF.text || !self.login.registerPhoneNum) {
        [self showMassage:@"请输入手机号"];
        return;
    }
    //接口
    //判断手机号是否注册过或绑定过
    NSString *timeStr = [LJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.login.registerPhoneNum forKey:@"telephone"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    weakSelf(self);
    [[WebManager sharedManager] LSGetCheckPhoneBindWithParameters:allParams success:^(LSLJSuccessData *data) {
        if ([data.code isEqualToString:@"0"]) {
            //既没注册也没绑定
            [weakSelf sendCode];
        } else {
            //1023注册过，没绑定过
            //1021绑定过(表示已经注册了)
            //其他错误情况
            [weakSelf showMassage:data.msg];
        }
        
    } failure:^(NSString *error) {
        [weakSelf showMassage:error];
    }];
}

//发送验证码
- (void)sendCode {
    [self setBtn];
    [self setTimer];
    
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
            [weakSelf showMassage:@"验证码发送成功"];
        } else {
            [weakSelf showMassage:data.msg];
        }
    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf resetBtn];
        [weakSelf resetTimer];
        [weakSelf showMassage:error];
    }];
}

//注册 先判断所填
- (IBAction)registerAction:(id)sender {
    weakSelf(self);
    [self isRegisterCompleteWithTextSuccess:^(BOOL isCorrect) {
        if (isCorrect) {
            [weakSelf finishRegiste];
        }
    } failure:^(NSString *errorString) {
        [weakSelf showMassage:errorString];
    }];
}

//注册
- (void)finishRegiste {
    weakSelf(self);
    [self showWaiting];
    //接口
    NSString *timeStr = [LJUtil getNowDateTimeString];
    self.login.registerPasswd1 = [self.login.registerPasswd1 MD5];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.login.registerPhoneNum forKey:@"telephone"];
    [parameters setObject:self.login.code forKey:@"code"];
    [parameters setObject:self.login.registerPasswd1 forKey:@"password"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    [[WebManager sharedManager] LSGetReginsterWithParameters:allParams success:^(LSLJSuccessData *data) {
        [weakSelf hideWaiting];
        if ([data.code isEqualToString:@"0"]) {
            [weakSelf showMassage:@"注册成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf showMassage:data.msg];
        }

    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

#pragma mark - 定时器
//定时器执行方法
- (void)timechang:(id)sender {
    _num--;
    
    [self.codeButton setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
    
    if (_num == 0) {
        [self resetBtn];
        
        [self resetTimer];
    }
}

- (void)setBtn {
    self.codeButton.enabled = NO;
    self.codeButton.layer.borderWidth = 0;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
}

- (void)setTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechang:) userInfo:nil repeats:YES];
}

- (void)resetBtn {
    self.codeButton.enabled = YES;
    _num = 59;
    [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.codeButton.layer.borderWidth = 1;
}

- (void)resetTimer {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.passwd1 resignFirstResponder];
    [self.passwd2 resignFirstResponder];
}

#pragma mark -- textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 100:
            self.login.registerPhoneNum = textField.text;
            break;
        case 101:
            self.login.code = textField.text;
            break;
        case 102:
            self.login.registerPasswd1 = textField.text;
            break;
        case 103:
            self.login.registerPasswd2 = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (textField.tag == 100) {
        return (newString.length <= 11);
    } else if (textField.tag == 101) {
        return (newString.length <= 6);
    } else if (textField.tag == 102 || textField.tag == 103) {
        return (newString.length <= 12);
    } else {
        return NO;
    }
}

#pragma mark -- UI
- (void)initUIView {
    [self initTitleViewWithTitle:@"注册"];
    [self setBackButton:YES];
    
    _num = 59;
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

#pragma mark -- 验证
/**
 判断注册是否填写完整
 
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isRegisterCompleteWithTextSuccess:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure {
    NSDictionary *dic = [self registerData];
    if ([[dic valueForKey:@"result"] isEqualToString:@"no"]) {
        failure([dic valueForKey:@"hint"]);
    } else {
        success(YES);
    }
}

//注册时判断所填信息是否正确
- (NSDictionary*)registerData {
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

#pragma mark ----
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
