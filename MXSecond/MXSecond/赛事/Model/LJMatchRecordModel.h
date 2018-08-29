//
//  LJMatchRecordModel.h
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

//记录
#import <Foundation/Foundation.h>

@interface LJMatchRecordModel : NSObject

@property (nonatomic, copy) NSString *home_name;/**< 主队名 */
@property (nonatomic, assign) NSInteger home_score;/**< 主队分 */
@property (nonatomic, copy) NSString *home_logo_100x130;/**< 主队logo */
@property (nonatomic, copy) NSString *away_name;/**< 客队名 */
@property (nonatomic, assign) NSInteger away_score;/**< 客队分 */
@property (nonatomic, copy) NSString *away_logo_100x130;/**< 客队logo */
@property (nonatomic, copy) NSString *stadium_name;/**< 体育场 */
@property (nonatomic, copy) NSString *natch_data_cn;/**< 比赛时间 */
//@property (nonatomic, strong) <#type#> *<#name#>;/**< <#注释#> */

@end
