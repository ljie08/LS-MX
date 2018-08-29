//
//  XFMatchInfoModel.m
//  MXFootball
//
//  Created by FreeSnow on 2018/7/10.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "XFMatchInfoModel.h"

@implementation XFMatchInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             
             @"score" :@"XFScoreModel"
             };
}
@end
