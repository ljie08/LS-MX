//
//  SuccessData.h
//  MXSecond
//
//  Created by Libra on 2018/7/13.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuccessData : NSObject

@property (nonatomic, copy) NSString *status;/**< 状态 */
@property (nonatomic, assign) NSInteger code;/**< 200成功 404失败 */
@property (nonatomic, strong) NSString *message;/**< 提示信息 */
@property (nonatomic, strong) NSArray *result;/**< 数据 */

@end
