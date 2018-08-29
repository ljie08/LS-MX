//
//  XFNewsModel.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/13.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFNewsModel.h"

@implementation XFNewsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
   return @{
      @"Id":@"id",
      @"Description":@"description"
      };
}
@end
