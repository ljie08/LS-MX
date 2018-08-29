//
//  LJMatchListModel.h
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

//积分
#import <Foundation/Foundation.h>

@interface LJMatchScoreModel : NSObject

@property (nonatomic, assign) NSInteger win;/**< 胜 */
//@property (nonatomic, copy) NSString *promotion_name;/**< <#注释#> */
@property (nonatomic, assign) NSInteger miss;/**< 失 */
//@property (nonatomic, copy) NSString *season_id;/**< <#注释#> */
//@property (nonatomic, assign) NSInteger avg_goal_lost;/**< <#注释#> */
//@property (nonatomic, copy) NSString *promotion_id;/**< <#注释#> */
//@property (nonatomic, assign) NSInteger avg_goal_hit;/**< <#注释#> */
//@property (nonatomic, assign) NSInteger difference;/**< <#注释#> */
@property (nonatomic, assign) NSInteger hits;/**< 进 */
@property (nonatomic, assign) NSInteger draw;/**< 平 */
@property (nonatomic, assign) NSInteger score;/**< 积分 */
//@property (nonatomic, assign) NSInteger avg_score;/**< <#注释#> */
@property (nonatomic, assign) NSInteger played;/**< 赛 */
//@property (nonatomic, copy) NSString *team_group;/**< <#注释#> */
//@property (nonatomic, assign) NSInteger scoreid;/**< <#注释#> */
@property (nonatomic, assign) NSInteger lost;/**< 负 */
//@property (nonatomic, copy) NSString *known_name_zh;/**< 球队 */
@property (nonatomic, assign) NSInteger rank_index;/**< 排名 */
//@property (nonatomic, assign) NSInteger avg_goal_win;/**< <#注释#> */
//@property (nonatomic, assign) NSInteger league_id;/**< <#注释#> */
//@property (nonatomic, copy) NSString *team_id;/**< <#注释#> */
@property (nonatomic, copy) NSString *name_zh;/**< 球队 */

@end
