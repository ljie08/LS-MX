//
//  LoginModel.h
//  MXFootball
//
//  Created by Libra on 2018/7/6.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (nonatomic, copy) NSString *registerPhoneNum;//注册手机号
@property (nonatomic, copy) NSString *registerPasswd1;//输入密码
@property (nonatomic, copy) NSString *registerPasswd2;//再次输入密码
@property (nonatomic, copy) NSString *code;//验证码

@end
