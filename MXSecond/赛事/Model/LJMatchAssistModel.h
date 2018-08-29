//
//  LJMatchAssistModel.h
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

//助攻
#import <Foundation/Foundation.h>

@interface LJMatchAssistModel : NSObject
//
//@property (nonatomic, copy) NSString *image_86x120_url;/**< <#注释#> */
//@property (nonatomic, copy) NSString *position;/**< <#注释#> */
@property (nonatomic, copy) NSString *team_name;/**< 球队 */
//@property (nonatomic, copy) NSString *total_mins;/**< <#注释#> */
//@property (nonatomic, copy) NSString *player_name_en;/**< <#注释#> */
//@property (nonatomic, assign) NSInteger season_id;/**< <#注释#> */
@property (nonatomic, assign) NSInteger rank_index;/**< 排名 */
//@property (nonatomic, assign) NSInteger player_id;/**< <#注释#> */
@property (nonatomic, assign) NSInteger assist_count;/**< 助攻 */
//@property (nonatomic, assign) NSInteger pen_goal_count;/**< <#注释#> */
//@property (nonatomic, assign) NSInteger league_id;/**< <#注释#> */
//@property (nonatomic, assign) NSInteger team_id;/**< <#注释#> */
@property (nonatomic, copy) NSString *player_name;/**< 球员中文 */
//@property (nonatomic, assign) NSInteger goal_count;/**< <#注释#> */

@end
