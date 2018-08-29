//
//  PersonDataManager.h
//  MXFootball
//
//  Created by Libra on 2018/7/6.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonDataManager : NSObject

+ (PersonDataManager *)instance;

@property (nonatomic, strong) User *user;//用户信息

/**
 *  当前版本APP是否第一次运行
 *
 *  @return 如果当前版本是第一次运行则返回YES，否则则返回NO
 */
- (BOOL)isFirstRun;

/**
 是否登录
 
 @return <#return value description#>
 */
- (BOOL)hasLogin;

/**
 退出登录,账号被顶掉
 */
- (void)logOut;

@end
