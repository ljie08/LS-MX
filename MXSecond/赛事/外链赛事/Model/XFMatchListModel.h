//
//  XFMatchListModel.h
//  MXFootball
//
//  Created by FreeSnow on 2018/7/3.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFMatchListModel : NSObject
@property (nonatomic , copy) NSString * advertPic ;/**< 广告图片地址 */
@property (nonatomic , copy) NSString * targetUrl ;/**< 广告跳转目标地址 */
@property (nonatomic , copy) NSString * advertId ; /**< 广告id */

@property (nonatomic, assign) NSInteger isCollect ; /**< 收藏falg */

@property (nonatomic , assign) NSInteger eventId ;/**< 赛事ID */
@property (nonatomic , copy) NSString * eventName ;/**< 赛事全称 */
@property (nonatomic , copy) NSString * eventShortName ;/**< 赛事别名（简称）*/
@property (nonatomic , assign) NSInteger flashFlg ;/**< 动画flg（0：没有动画，1：有动画）*/

@property (nonatomic , copy) NSString * homeTeamLogo ;/**< 主队logo*/
@property (nonatomic , copy) NSString * homeTeamName ;/**< 主队名*/
@property (nonatomic , assign) NSInteger homeTeamScore ;/**< 主队得分*/
@property (nonatomic , assign) NSInteger matchId ;/**< 比赛ID*/

@property (nonatomic , assign) NSInteger matchStatus ;/**< 赛事状态Id*/
@property (nonatomic , copy) NSString * startBallTime ;/**< 开球时间*/
@property (nonatomic , copy) NSString * startGameTime ;/**< 开赛时间*/
@property (nonatomic , copy) NSString * statusName ;/**< 赛事状态描述*/

@property (nonatomic , copy) NSString * visitTeamLogo ;/**< 客队logo*/
@property (nonatomic , copy) NSString * visitTeamName ;/**< 客队名*/
@property (nonatomic , assign) NSInteger visitTeamScore ;/**< 客队比分 */

#pragma mark - 首页所需
//@property (nonatomic, copy) NSString *eventNm;//赛事名
//@property (nonatomic, copy) NSString *matchStartTime;//开赛时间(UnixTime)
//@property (nonatomic, copy) NSString *homeNm;//主队名
//@property (nonatomic, assign) NSInteger homeScore;//主队比分
//@property (nonatomic, copy) NSString *homeLogo;//主队logo
//@property (nonatomic, copy) NSString *awayNm;//客队名
//@property (nonatomic, assign) NSInteger awayScore;//客队比分
//@property (nonatomic, copy) NSString *awayLogo;//客队logo
@property (nonatomic, copy) NSString *reason;//推荐理由

@end
