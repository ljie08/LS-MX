//
//  XFHomeViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFHomeViewController.h"
#import "BaseViewController.h"
#import "XFNewSViewController.h"
#import "XFFastNewViewController.h"
#import "XFVideoViewController.h"
#import "XFPhotosViewController.h"
#import "XFOssianViewController.h"
#import "XFWallPageViewController.h"
@interface XFHomeViewController ()
@property (nonatomic, strong) NSArray *titleData;
@end

@implementation XFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        
//        self.titleFontName = @"Copperplate-Bold";
        self.titleSizeNormal = RateSacel(14);
        self.titleSizeSelected = RateSacel(17);
        self.menuView.backgroundColor = MyColor;
        self.showOnNavigationBar = YES;
        self.menuViewStyle = 0;
        self.titleColorNormal = WhiteColor;
        self.titleColorSelected = WhiteColor;
//        self.progressColor = MyColor;
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titleData.count;
//        self.menuHeight = 50;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.backgroundColor = MyColor;
}

#pragma mark - WMPageController Helper Methods

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    return CGRectMake(0, 0, Screen_Width, RateSacel(45));
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, Screen_Width, Screen_Height - STATUS_TABBAR_NAVIGATION_HEIGHT);
}

-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titleData.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NSArray * controllerArr = @[
                                [[XFFastNewViewController alloc] init],
                                [[XFPhotosViewController alloc] init],
                                [[XFVideoViewController alloc] init],
                                [[XFOssianViewController alloc] init],
                                [[XFNewSViewController alloc] init],
                                [[XFWallPageViewController alloc] init],
                                
                                ];
    
    return controllerArr[index];
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}

#pragma mark - Lazy Loading
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"快讯", @"图集", @"视频", @"洲闻", @"新闻", @"壁纸", ];
    }
    return _titleData;
}

@end
