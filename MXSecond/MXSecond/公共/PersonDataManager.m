//
//  PersonDataManager.m
//  MXFootball
//
//  Created by Libra on 2018/7/6.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "PersonDataManager.h"

@implementation PersonDataManager

+ (PersonDataManager *)instance {
    static PersonDataManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PersonDataManager alloc] init];
        
        NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *listPath = [listFile stringByAppendingPathComponent:LSUSER_DATA];
        _instance.user = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    });
    return _instance;
}

/**
 *  获取APP版本号
 *
 */
- (NSString *)clientVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

/**
 *  当前版本APP是否第一次运行
 *
 *  @return 如果当前版本是第一次运行则返回YES，否则则返回NO
 */
- (BOOL)isFirstRun {
    NSString *key = [@"HasLaunchedOnce" stringByAppendingString:[self clientVersion]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:key]) {
        // app already launched
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        return YES;
    }
}

/**
 是否登录

 @return <#return value description#>
 */
- (BOOL)hasLogin {
    return self.user != nil && self.user.userId;
}

/**
 退出登录,账号被顶掉
 */
- (void)logOut {
    [PersonDataManager instance].user = nil;
    
    [self saveUserDataWithUser:[PersonDataManager instance].user];
}

- (void)setUser:(User *)user {
    _user = user;
    
    [self saveUserDataWithUser:_user];
}

- (void)saveUserDataWithUser:(User *)user {
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:LSUSER_DATA];
    
    //将登录成功返回的用户信息存到本地
    [NSKeyedArchiver archiveRootObject:user toFile:listPath];
}

@end
