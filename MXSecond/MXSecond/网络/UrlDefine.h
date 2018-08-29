//
//  UrlDefine.h
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#ifndef UrlDefine_h
#define UrlDefine_h

#define MXKey @"1b5c68449a9df94143f478121749c260"
//发布
//#define QYLBaseUrl @"https://api.qiuyoule.com/"
//测试
#define QYLBaseUrl @"https://api.caipiaoq.com/"

//主URL
//http://zuqiushequ.6ag.cn/newapi/getTeamInfo.api?league_id4&team_id264

#define BaseURL @"http://zuqiushequ.6ag.cn/newapi/"

//------ get ------
//--------------------------------------
//图集54 壁纸55 新闻41 欧洲56type 2 http://zuqiushequ.6ag.cn/newapi/getNewsList.api?classid=41&pageIndex=1&table=news&type=2
#define NEWS_PATH @"getNewsList.api"

//
//快讯http://zuqiushequ.6ag.cn/newapi/getNewsflashList.api?page=0
#define FASTNEWS_PATH @"getNewsflashList.api"

//视频http://zuqiushequ.6ag.cn/newapi/getVideoList.api?page=0
#define VIDEO_PATH @"getVideoList.api"

//图集54 壁纸55 新闻41 欧洲56type 2  http://zuqiushequ.6ag.cn/newapi/getNewsList.api?classid=54&pageIndex=1&table=news&type=1
//#define PHOTOS_PATH @"getNewsList.api"

//壁纸http://zuqiushequ.6ag.cn/newapi/getNewsList.api?classid=55&pageIndex=1&table=news&type=1
//#define WALLPHTOTS_PATH @"getNewsList.api"

//欧洲http://zuqiushequ.6ag.cn/newapi/getNewsList.api?classid=56&pageIndex=1&table=news&type=2
//#define OSSNEWS_PATH @"getNewsList.api"

//详情http://zuqiushequ.6ag.cn/newapi/getNewsContent.api?classid=56&id=4944
#define NEWCONTENT_PATH @"getNewsContent.api"


//--------------赛事---------------
/** 基本面 29 */
static NSString * const LSEventBasicPanelPATH = @"api/event/basicPanel" ;
/**  91 收藏球赛 */
static NSString * const LSEventCollectMatchePATH = @"api/event/CollectMatche";
/**  92 收藏球赛列表 */
static NSString *const LSWodeMyFindCollectMatches_PATH = @"api/event/findCollectMatches";
/** 109赛事模块（即时、完赛） */
static NSString *const LSApiCommonInstant2 = @"api/common/instant2";
//助攻
//http://zuqiushequ.6ag.cn/newapi/getAssistrankList.api?league_id2&season_id2017
#define Assist_PATH @"getAssistrankList.api"

//射手
//http://zuqiushequ.6ag.cn/newapi/getGoalrankList.api?league_id2&season_id2017
#define Goal_PATH @"getGoalrankList.api"

//积分
//http://zuqiushequ.6ag.cn/newapi/getScorerankList.api?league_id2&season_id2017
#define Score_PATH @"getScorerankList.api"

//赛程记录
//http://zuqiushequ.6ag.cn/newapi/getScheduleList.api?league_id2&season_id2017
#define Schedule_PATH @"getScheduleList.api"

//球队信息
//https://m.hupu.com/soccer/teams/264
#define Teams_PATH @"https://m.hupu.com/soccer/teams/"

//-------------注册登录--------------
/** 78 判断手机号是否被绑定 */
#define LSCheckTelBind_PATH @"api/user/checkTelBind"

/** 1 获取短信验证码 */
#define LSSendCode_PATH @"api/user/sendCode"

/** 2 注册 */
#define LSReginster_PATH @"api/user/reg"

/** 105 注册协议 */
#define LSProtocol_PATH @"api/user/protocol"

/** 3 登录 */
#define LSLogin_PATH @"api/user/login"

/** 可以根据这个取出存本地的用户信息 */
#define LSUSER_DATA @"LSuser.plist"

/** 63 忘记密码 */
#define LSForgetPasswd_PATH @"api/user/forgetPwd"

//----------------我的---------------
/** 7 修改用户名 */
#define LSEditUserName_PATH @"api/user/modifyUName"

/** 9 修改用户个性签名 */
#define LSEditUserSign_PATH @"api/user/modifyUSign"

/** 10 修改用户性别 */
#define LSEditUserSex_PATH @"api/user/modifyUSex"

/** 11 修改用户头像（文件） */
#define LSWodemModifyUserHeadPic_PATH @"api/user/modifyUHeader"

#endif /* UrlDefine_h */
