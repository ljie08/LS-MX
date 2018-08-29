//
//  LJMatchListModel.m
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "LJMatchScoreModel.h"

@implementation LJMatchScoreModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{
              @"scoreid" : @"id",
              };
}

@end
