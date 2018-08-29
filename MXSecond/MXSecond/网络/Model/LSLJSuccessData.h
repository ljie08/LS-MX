//
//  LSLJSuccessData.h
//  MXFootball
//
//  Created by FreeSnow on 2018/7/4.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSLJSuccessData : NSObject
@property (nonatomic, copy) NSString *code;//操作返回码
@property (nonatomic, copy) NSString *msg;//信息
@property (nonatomic, assign) id data;//数据
@end
