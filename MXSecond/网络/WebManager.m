//
//  WebManager.m
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "WebManager.h"

@implementation WebManager

+ (instancetype)sharedManager {
    static WebManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://httpbin.org/"]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"*.qiuyoule.com" ofType:@".cer"];
//        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//        NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//
//        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//        // 如果是需要验证自建证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = YES;
//        //设置是否需要验证域名
//        securityPolicy.validatesDomainName = YES;
//
//        securityPolicy.pinnedCertificates = cerSet;
        
        AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        [security setValidatesDomainName:NO];

        security.allowInvalidCertificates = YES;
//
        self.securityPolicy = security;
        
        
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 5;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

#pragma mark - Data
#pragma mark - 新闻大猪猡

#pragma mark 新闻

/**
 新闻
 
 @param classId 新闻id
 @param index 页数
 @param type 类别
 @param success success description
 @param failure failure description
 */
- (void)getNewListWithClassId:(NSInteger)classId pageIndex:(NSInteger)index type:(NSInteger)type success:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSString *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@?table=news&classid=%d&pageIndex=%d&type=%d",BaseURL, NEWS_PATH, (int)classId, (int)index, (int)type];
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [self requestWithMethod:GET WithUrl:url WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 200) {
            msg = @"加载成功";
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
        }
        NSArray *results = [XFNewsModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(results, msg);
        NSLog(@"..");
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}
#pragma mark 快讯

/**
 新闻
 
 @param page 页数
 @param success success description
 @param failure failure description
 */
- (void)getNewListWithPage:(NSInteger)page success:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSString *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@?page=%d",BaseURL, FASTNEWS_PATH, (int)page];
    //    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [self requestWithMethod:GET WithUrl:url WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 200) {
            msg = @"加载成功";
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
        }
        NSArray *results = [XFNewsModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(results, msg);
        NSLog(@"..");
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 视频

/**
 视频
 
 @param page 页数
 @param success success description
 @param failure failure description
 */
- (void)getNewListWithVideoPage:(NSInteger)page success:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSString *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@?page=%d",BaseURL, VIDEO_PATH,  (int)page];
    //    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [self requestWithMethod:GET WithUrl:url WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 200) {
            msg = @"加载成功";
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
        }
        NSArray *results = [XFNewsModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(results, msg);
        NSLog(@"..");
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

- (void)getNewDetailWithClassId:(NSInteger)classId newId:(NSInteger)newId success:(void (^)(NSDictionary *, NSString *))success failure:(void (^)(NSString *))failure {
    NSString * url = [NSString stringWithFormat:@"%@%@?classid=%d&id=%d", BaseURL, NEWCONTENT_PATH, classId, newId];
    [self requestWithMethod:GET WithUrl:url WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
//        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if ([dic[@"code"] integerValue] == 200) {
            msg = @"加载成功";
        }
        if ([dic[@"code"] integerValue] == 404) {
            msg = @"加载失败，请稍后再试";
        }
        
//        NSArray *results = [XFNewsModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(dic[@"result"], msg);
        NSLog(@"..");
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark - 赛事
/**
 赛事
 
 @param classId 赛事id
 @param index 页数
 @param success success description
 @param failure failure description
 */
- (void)getMatchListWithClassId:(NSInteger)classId pageIndex:(NSInteger)index success:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSString *))failure {
    NSString *opid = [NSString stringWithFormat:@"%d", (int)classId];
    NSString *platform = @"ios";
    NSString *page = [NSString stringWithFormat:@"%d", (int)index];
    NSString *limit = @"10";
    NSString *time = [LJUtil getNowDateTimeString];
    NSDictionary *dic = @{
                          @"opid":opid,
                          @"platform":platform,
                          @"page":page,
                          @"limit":limit,
                          @"time":time,
                          };
    if ([[PersonDataManager instance] hasLogin]) {
        NSString *userId =[NSString stringWithFormat:@"%d", (int)[PersonDataManager instance].user.userId];
        dic = @{
                              @"opid":opid,
                              @"platform":platform,
                              @"page":page,
                              @"limit":limit,
                              @"time":time,
                              @"userId":userId
                              };
    }
    NSString *url = [QYLBaseUrl stringByAppendingString:LSApiCommonInstant2];
    NSMutableDictionary * params = [LJUtil sortedDictionary:[NSMutableDictionary dictionaryWithDictionary:dic]];
    [self requestWithMethod:GET WithUrl:url WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *responseObject = [LSLJSuccessData mj_objectWithKeyValues:dic];
        NSArray * mArray = responseObject.data[@"matches"];
        success(mArray, responseObject.msg);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
    
}

- (void)getMatchListWithClassId:(NSInteger)classId potType:(NSInteger)type success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSString *url = [QYLBaseUrl stringByAppendingString: LSEventCollectMatchePATH];
    
    NSString * userId = [NSString stringWithFormat:@"%d", (int)[PersonDataManager instance].user.userId];
    NSString * optType = type?@"1":@"0";
    NSString *matchId = [NSString stringWithFormat:@"%ld", (long)classId];
    NSString * time = [LJUtil getNowDateTimeString];
    
    NSDictionary * params = @{
                              @"userId":userId,
                              @"optType":optType,
                              @"matchId":matchId,
                              @"time":time,
                              };
    NSMutableDictionary * dic = [LJUtil sortedDictionary:[NSMutableDictionary dictionaryWithDictionary:params]];
 
    [self requestWithMethod:GET WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 0) {
            msg = @"加载成功";
            success(msg);
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
            success([NSString stringWithFormat:@"%@", msg]);
        }
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 基本面
 
 @param classId 赛事id
 @param success success description
 @param failure failure description
 */

- (void)getMatchInfoWithClassId:(NSInteger)classId success:(void (^)(LSLJSuccessData *, NSString *))success failure:(void (^)(NSString *))failure {
    NSString *url = [QYLBaseUrl stringByAppendingString:LSEventBasicPanelPATH];

    NSString *matchId = [NSString stringWithFormat:@"%ld", (long)classId];
    NSString * time = [LJUtil getNowDateTimeString];
    
    NSDictionary * params = @{
                              @"matchId":matchId,
                              @"time":time
                              };
    NSMutableDictionary * dic = [LJUtil sortedDictionary:[NSMutableDictionary dictionaryWithDictionary:params]];
    
    [self requestWithMethod:GET WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *succe = [LSLJSuccessData mj_objectWithKeyValues:dic];
        
        success(succe, succe.msg);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 数据
 
 @param leagueId 分类 2，3，4，5，6，7。。。
 @param path url路径 助攻、射手、积分、记录
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getMatchListWithLeagueId:(NSInteger )leagueId path:(NSString *)path success:(void (^)(NSArray *assistArr, NSString *msg))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseURL, path];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:leagueId] forKey:@"league_id"];
    [param setObject:@2017 forKey:@"season_id"];
    
    [self requestWithMethod:GET WithUrl:url WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 200) {
            msg = @"加载成功";
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
        }
        NSArray *results = [LJMatchAssistModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(results, msg);
        NSLog(@"..");
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}
/**
 助攻榜
 
 @param leagueId 分类
 @param seasonId 固定值，2017
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getAssistListWithLeagueId:(NSInteger )leagueId seasonId:(NSString *)seasonId success:(void (^)(NSArray *assistArr, NSString *msg))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseURL, Assist_PATH];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:leagueId] forKey:@"league_id"];
    [param setObject:seasonId forKey:@"season_id"];
    
    [self requestWithMethod:GET WithUrl:url WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 200) {
            msg = @"加载成功";
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
        }
        NSArray *results = [LJMatchAssistModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(results, msg);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 射手榜
 
 @param leagueId 分类
 @param seasonId 固定值，2017
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getGoalListWithLeagueId:(NSInteger )leagueId seasonId:(NSString *)seasonId success:(void (^)(NSArray *goalArr, NSString *msg))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseURL, Goal_PATH];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:leagueId] forKey:@"league_id"];
    [param setObject:seasonId forKey:@"season_id"];
    
    [self requestWithMethod:GET WithUrl:url WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 200) {
            msg = @"加载成功";
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
        }
        NSArray *results = [LJMatchGoalModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(results, msg);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 积分榜
 
 @param leagueId 分类
 @param seasonId 固定值，2017
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getScoreListWithLeagueId:(NSInteger )leagueId seasonId:(NSString *)seasonId success:(void (^)(NSArray *scoreArr, NSString *msg))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseURL, Score_PATH];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:leagueId] forKey:@"league_id"];
    [param setObject:seasonId forKey:@"season_id"];
    
    [self requestWithMethod:GET WithUrl:url WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 200) {
            msg = @"加载成功";
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
        }
        NSArray *results = [LJMatchScoreModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(results, msg);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 赛程记录
 
 @param leagueId 分类
 @param seasonId 固定值，2017
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getRecordListWithLeagueId:(NSInteger )leagueId seasonId:(NSString *)seasonId success:(void (^)(NSArray *recordArr, NSString *msg))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseURL, Schedule_PATH];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:leagueId] forKey:@"league_id"];
    [param setObject:seasonId forKey:@"season_id"];
    
    [self requestWithMethod:GET WithUrl:url WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        SuccessData *succe = [SuccessData mj_objectWithKeyValues:dic];
        
        NSString *msg = [NSString string];
        if (succe.code == 200) {
            msg = @"加载成功";
        }
        if (succe.code == 404) {
            msg = @"加载失败，请稍后再试";
        }
        NSArray *results = [LJMatchRecordModel mj_objectArrayWithKeyValuesArray:succe.result];
        
        success(results, msg);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark - 注册登录
/**
 判断手机号是否被绑定
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetCheckPhoneBindWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
//    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSCheckTelBind_PATH];
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSCheckTelBind_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 获取短信验证码
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetSendCodeWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSSendCode_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 新用户注册
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetReginsterWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSReginster_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 注册协议
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetLookProtocolWithParameters:(NSDictionary *)parameters success:(void (^)(JProtocol *protocol))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSProtocol_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        JProtocol *pro = [JProtocol mj_objectWithKeyValues:data.data];
        success(pro);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 登录
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetLoginWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSLogin_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 忘记密码
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSGetForgetPasswdWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *msg, NSString *code))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSForgetPasswd_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        success(data.msg, data.code);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark - 我的
/**
 修改昵称
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSEditNameWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSEditUserName_PATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 修改性别
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSEditSexWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSEditUserSex_PATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 修改签名
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)LSEditSignWithParameters:(NSDictionary *)parameters success:(void (^)(LSLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", QYLBaseUrl, LSEditUserSign_PATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        LSLJSuccessData *data = [LSLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

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
                          failure: (void(^)(NSError *error))failure {
    //1.拼接服务器地址
    NSString *url = [QYLBaseUrl stringByAppendingString:urlString];
    //2.发起网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5;
    
    //上传头像图片
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage *image in imagesArr) {
            
            UIImage *newImage = image;
            if (image.size.width > 640) {
                
                newImage = [image resizeImage:640];
                
            }
            NSData *data = UIImageJPEGRepresentation(newImage, 0.9);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            //设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark ----
#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
                  WithUrl:(NSString *)url
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
         WithFailureBlock:(requestFailureBlock)failure {
    
//    url = [NSString stringWithFormat:@"%@%@", BaseURL, url];
    NSLog(@"url --> %@", url);
    
    switch (method) {
        case GET:{
            [self GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
//                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                failure(error);
            }];
            break;
        }
        case POST:{
            [self POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                //账号被顶掉，需要重新登录
                if ([[responseObject objectForKey:@"code"] integerValue] == 1005 && [PersonDataManager instance].hasLogin) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReLoginNotification object:nil];
                } else {
                    success(responseObject);
                }
                
                NSLog(@"JSON: %@", responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}


@end


