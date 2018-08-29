//
//  XFNewDetailViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/16.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFNewDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
@interface XFNewDetailViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;/**< 注释 */
@property (nonatomic, strong) NSDictionary *dic;/**<  */
@property (nonatomic, strong) JSContext *content;/**< content */
@end

@implementation XFNewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton:YES];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - STATUS_AND_NAVIGATION_HEIGHT)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self loadData];
    
    [self.view addSubview:self.webView];
}

- (void)loadData {
    [self showWaiting];
    [[WebManager sharedManager] getNewDetailWithClassId:_classId.integerValue newId:_urlStrNewId.integerValue success:^(NSDictionary *dic, NSString *msg) {
        [self hideWaiting];
        self.dic = dic;
        self.title = self.dic[@"title"];
        NSString * bodyHtml = _dic[@"newstext"];
        NSArray * allphoto = self.dic[@"allphoto"];
        for (int i = 0; i< allphoto.count; i++) {
            
            NSDictionary * imgItem = allphoto[i];
            
            // 7.2取出站位标签
            NSString * ref = imgItem[@"ref"];
            // 7.3取出图片标题
            NSString * imgTitle = imgItem[@"caption"];
            // 7.4取出src
            NSString * url = imgItem[@"url"];
            NSString * imgHtml = [NSString stringWithFormat:@"<div><img src=\"\%@\"><div>\%@</div></div>", url, imgTitle];
            
            // 7.5替换body中的图片占位符
            bodyHtml = [bodyHtml stringByReplacingOccurrencesOfString:ref withString:imgHtml];
            
        }
        [self.webView loadHTMLString:[self reSizeImageWithHTML: bodyHtml] baseURL:nil];
    } failure:^(NSString *error) {
        [self hideWaiting];
        [self showMassage:error];
    }];
}
#pragma mark - WKWebViewDelgate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

  
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

- (NSString *)reSizeImageWithHTML:(NSString *)html {
    return [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@", Screen_Width - 20, html];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
