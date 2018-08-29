 //
//  BaseTabbarController.m
//  IOSFrame
//
//  Created by lijie on 2017/7/17.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "BaseTabbarController.h"
#import "BaseNavigationController.h"
//#import "HomeViewController.h"
//#import "MeViewController.h"
#import "BaseViewController.h"
#import "WKViewController.h"
#import "GuideView.h"

#import "XFHomeViewController.h"
#import "WKViewController.h"
#import "XFMyViewController.h"

@interface BaseTabbarController ()<GuideViewDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) GuideView *guideView;

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    if ([PersonDataManager instance].isFirstRun) {
        NSLog(@"yes");
        [self setSubView];
        [self initGuide];
    } else {
        NSLog(@"no");
        [self setSubView];
    }
}

- (void)setSubView {
    
    NSArray * vcArray = @[
                          @"XFHomeViewController",
                          @"XFMatchListViewController",
                          @"WKViewController",
                          @"XFMyViewController",
                          ];
    NSArray * titleArr = @[
                           @"资讯",
                           @"赛事",
                           @"cup",
                           @"我",
                           ];
    NSArray * imageArr = @[
                           @"info",
                           @"cup",
                           @"match",
                           @"mine",
                           ];
    
    for (NSInteger i = 0; i< vcArray.count; i++) {
        BaseViewController * vc = [[NSClassFromString(vcArray[i]) alloc] init];
        NSString *simage = [NSString stringWithFormat:@"%@_s", imageArr[i]];
        [self setChildVCWithViewController:vc title:titleArr[i] image:[UIImage imageNamed:imageArr[i]] selectedImg:[UIImage imageNamed:simage]];
    }
}

- (void)setChildVCWithViewController:(UIViewController *)controller title:(NSString *)title image:(UIImage *)image selectedImg:(UIImage *)selectedImg {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:controller];
    self.tabBar.tintColor = MyColor;
    controller.navigationController.navigationBar.barTintColor = MyColor;
    [controller.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    controller.title = title;
    nav.tabBarItem.image = image;
    nav.tabBarItem.selectedImage = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

#pragma mark - tabbar
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.currentNav = (BaseNavigationController *)viewController;
}

#pragma mark - guide
- (void)initGuide {
    self.guideView = [[GuideView alloc] init];
//    if (Screen_Height == 480) {
//        self.guideView.images = @[@"", @"", @""];
//    } else if (Screen_Height == 568) {
//        self.guideView.images = @[@"", @"", @""];
//    } else if (Screen_Height == 667) {
//        self.guideView.images = @[@"", @"", @""];
//    } else if (Screen_Height == 812) {
//        self.guideView.images = @[@"", @"", @""];
//    } else {
//    }
    self.guideView.images = @[@"1", @"2", @"3"];
    self.guideView.guideDelegate = self;
    [self.view addSubview:self.guideView];
    [self.view addSubview:self.guideView.pageControl];
}

- (void)buttonTapped:(UIButton *)button {
    [self.guideView removeFromSuperview];
    [self.guideView.pageControl removeFromSuperview];
}

@end
