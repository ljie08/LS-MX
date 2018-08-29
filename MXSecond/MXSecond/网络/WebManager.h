//
//  WebManager.h
//  MXSecond
//
//  Created by 仙女本人🎀 on 2018/2/6.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface WebManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

#pragma mark - Data
#pragma mark - 新闻大猪猡
//classid=54&pageIndex=1&type=1

/**
 新闻

 @param classId 新闻id
 @param index 页数
 @param type 类别
 @param success success description
 @param failure failure description
 */
- (void)getNewListWithClassId:(NSInteger )classId pageIndex:(NSInteger)index type:(NSInteger)type success:(void (^)(NSArray *resultArr, NSString *msg))success failure:(void (^)(NSString *error))failure;

/**
 快讯
 
 @param page 页数
 @param success success description
 @param failure failure description
 */
- (void)getNewListWithPage:(NSInteger)page success:(void (^)(NSArray *resultArr, NSString *msg))success failure:(void (^)(NSString *error))failure;

/**
 视频
 
 @param page 页数
 @param success success description
 @param failure failure description
 */
- (void)getNewListWithVideoPage:(NSInteger)page success:(void (^)(NSArray *resultArr, NSString *msg))success failure:(void (^)(NSString *error))failure;

/**
 详情
 
 @param classId 分类id
 @param newId 新闻id
 @param success success description
 @param failure failure description
 */
- (void)getNewDetailWithClassId:(NSInteger)classId newId:(NSInteger)newId success:(void (^)(NSDictionary *dic, NSString *msg))success failure:(void (^)(NSString *error))failure;

#pragma mark - 赛事

/**
 赛事
 
 @param classId 赛事id
 @param index 页数
 @param success success description
 @param failure failure description
 */
- (void)getMatchListWithClassId:(NSInteger)classId pageIndex:(NSInteger)index success:(void (^)(NSArray *resultArr, NSString *msg))success failure:(void (^)(NSString *error))failure;

/**
 收藏
 
 @param classId 赛事id
 @param type 是否是收藏
 @param success success description
 @param failure failure description
 */
- (void)getMatchListWithClassId:(NSInteger)classId potType:(NSInteger)type success:(void (^) (NSString *msg))success failure:(void (^)(NSString *error))failure;

/**
 基本面
 
 @param classId 赛事id
 @param success success description
 @param failure failure description
 */
- (void)getMatchInfoWithClassId:(NSInteger)classId success:(void (^) (LSLJSuccessData * data, NSString *msg))success failure:(void (^)(NSString *error))failure;


/**
 数据

 @param leagueId 分类 2，3，4，5，6，7。。。
 @param path url路径 助攻、射手、积分、记录
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getMatchListWithLeagueId:(NSInteger )leagueId path:(NSString *)path success:(void (^)(NSArray *assistArr, NSString *msg))success failure:(void (^)(NSString *error))failure;
/**
 助攻榜

 @param leagueId 分类
 @param seasonId 固定值，2017
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getAssistListWithLeagueId:(NSInteger )leagueId seasonId:(NSString *)seasonId success:(void (^)(NSArray *assistArr, NSString *msg))success failure:(void (^)(NSString *error))failure;

/**
 射手榜
 
 @param leagueId 分类
 @param seasonId 固定值，2017
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getGoalListWithLeagueId:(NSInteger )leagueId seasonId:(NSString *)seasonId success:(void (^)(NSArray *goalArr, NSString *msg))success failure:(void (^)(NSString *error))failure;

/**
 积分榜
 
 @param leagueId 分类
 @param seasonId 固定值，2017
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getScoreListWithLeagueId:(NSInteger )leagueId seasonId:(NSString *)seasonId success:(void (^)(NSArray *scoreArr, NSString *msg))success failure:(void (^)(NSString *error))failure;

/**
 赛程记录
 
 @param leagueId 分类
 @param seasonId 固定值，2017
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getRecordListWithLeagueId:(NSInteger )leagueId seasonId:(NSString *)seasonId success:(void (^)(NSArray *recordArr, NSString *msg))success failure:(void (^)(NSString *error))failure;

#pragma mark - 注册登录
/**
 判断手机号是否被绑定
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetCheckPhoneBindWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

/**
 获取短信验证码
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetSendCodeWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

/**
 新用户注册
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetReginsterWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

/**
 注册协议
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetLookProtocolWithParameters:(NSDictionary *)parameters success:(void (^)(JProtocol *protocol))success failure:(void (^)(NSString *error))failure;

/**
 登录
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetLoginWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

/**
 忘记密码
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetForgetPasswdWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *msg, NSString *code))success failure:(void (^)(NSString *error))failure;

#pragma mark - 我的
/**
 修改头像
 
 @param pics 图片数组
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
//- (void)LSEditHeaderPicWithPics:(NSArray *)pics parameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

/**
 修改昵称
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSEditNameWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

/**
 修改性别
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSEditSexWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

/**
 修改签名
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSEditSignWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

/**
 修改头像

 @param imagesArr 图片数组
 @param urlString 修改头像的url
 @param params <#params description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)uploadModifyUHeaderImages: (NSArray *)imagesArr
                        urlString: (NSString *) urlString
                           params: (NSDictionary *)params
                          success: (void(^)(id responseObject))success
                          failure: (void(^)(NSError *error))failure;

#pragma mark -----
#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
WithUrl:(NSString *)url
WithParams:(NSDictionary*)params
WithSuccessBlock:(requestSuccessBlock)success
WithFailureBlock:(requestFailureBlock)failure;

@end


