//
//  InputViewController.m
//  MXFootball
//
//  Created by Libra on 2018/7/6.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()<UITextFieldDelegate ,UITextViewDelegate>

@property (nonatomic, strong) UITextField *name;/**< 名字 */
@property (nonatomic, strong) UITextView *sign;/**< 签名 */
@property (nonatomic, strong) User *user;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PersonDataManager instance].user;
}

- (void)saveData {
    //保存昵称
    if ([self.navTitle isEqualToString:@"修改昵称"]) {
        [self editName];
    } else {
        [self editSign];
    }
}

//修改昵称
- (void)editName {
    NSString *timeStr = [LJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(self.user.userId) forKey:@"userId"];
    [parameters setObject:self.name.text forKey:@"nickname"];
    [parameters setObject:timeStr forKey:@"time"];
    [parameters setObject:self.user.token forKey:@"token"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    weakSelf(self);
    [self showWaiting];
    
    [[WebManager sharedManager] LSEditNameWithParameters:allParams success:^(LSLJSuccessData *data) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:data.msg];
        if ([data.code isEqualToString:@"0"]) {
            weakSelf.user.username = [data.data objectForKey:@"newUsername"];
            [PersonDataManager instance].user = weakSelf.user;
            [weakSelf goBack];
        }
    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

//修改签名
- (void)editSign {
    NSString *timeStr = [LJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(self.user.userId) forKey:@"userId"];
    [parameters setObject:self.sign.text forKey:@"userSign"];
    [parameters setObject:timeStr forKey:@"time"];
    [parameters setObject:self.user.token forKey:@"token"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    weakSelf(self);
    [self showWaiting];
    [[WebManager sharedManager] LSEditSignWithParameters:allParams success:^(LSLJSuccessData *data) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:data.msg];
        if ([data.code isEqualToString:@"0"]) {
            weakSelf.user.userSign = [data.data objectForKey:@"userSign"];
            [PersonDataManager instance].user = weakSelf.user;
            [weakSelf goBack];
        }
    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

#pragma mark - textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
//    self.user.username = textField.text;
    [textField resignFirstResponder];
}

#pragma mark - textview
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.text.length) {
        textView.text = @"";
    }
    textView.textColor = FontColor;
//    self.user.userSign = textView.text;
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        textView.text = self.placeStr;
        textView.textColor = LightGrayColor;
    }
    [textView resignFirstResponder];
//    [self.sign resignFirstResponder];
//    self.user.userSign = textView.text;
}

//限制输入字数
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >= 30) {
        [self showMassage:@"签名不能超过30字~"];
        textView.text = [textView.text substringToIndex:30];
    }
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyboard {
    [self.name resignFirstResponder];
    [self.sign resignFirstResponder];
}

#pragma mark -- ui
- (void)initUIView {
    [self initTitleViewWithTitle:self.navTitle];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 40);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = SYSTEMFONT(16);
    [rightBtn addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self addNavigationWithTitle:nil leftItem:nil rightItem:right titleView:nil];
    
    [self setBackButton:YES];
    
    if ([self.navTitle isEqualToString:@"修改昵称"]) {
        [self setTextField];
    } else {
        [self setTextView];
    }
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [CurrentKeyWindow addGestureRecognizer:hideTap];
}

- (void)setTextField {
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Screen_Width, 50)];
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Screen_Width-20, 50)];
//    NSString *text = [self.navTitle stringByReplacingOccurrencesOfString:@"修改" withString:@""];
    self.name.placeholder = self.placeStr;
    self.name.text = [PersonDataManager instance].user.username;
    self.name.textColor = FontColor;
    self.name.font = SYSTEMFONT(15);
    self.name.delegate = self;
    
    bgview.backgroundColor = WhiteColor;
    [bgview addSubview:self.name];
    
    [self.view addSubview:bgview];
}

- (void)setTextView {
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Screen_Width, 100)];
    
    self.sign = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, Screen_Width-20, 100)];
    
    NSString *text = [self.navTitle stringByReplacingOccurrencesOfString:@"修改" withString:@""];
    self.sign.text = [PersonDataManager instance].user.userSign.length ? [PersonDataManager instance].user.userSign :[NSString stringWithFormat:@"请输入%@,30字内", text];
    
    self.sign.textColor = LightGrayColor;
    self.sign.font = SYSTEMFONT(15);
    self.sign.delegate = self;
    self.sign.scrollEnabled = YES;
    
    bgview.backgroundColor = WhiteColor;
    [bgview addSubview:self.sign];
    [self.view addSubview:bgview];
}

#pragma mark - user
- (User *)user {
    if (!_user) {
        _user = [[User alloc] init];
    }
    return _user;
}

#pragma mark --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
