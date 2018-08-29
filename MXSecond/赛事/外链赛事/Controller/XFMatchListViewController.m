//
//  XFMatchListViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/17.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFMatchListViewController.h"
#import "BaseViewController.h"
#import "XFLikeViewController.h"
#import "XFNowViewController.h"
#import "XFFinishedViewController.h"
#import "XFMiddleViewController.h"
@interface XFMatchListViewController ()
@property (nonatomic, strong) NSArray *titleData;
@end

@implementation XFMatchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;//    自动滚动调整，默认为YES
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        
        
        self.titleSizeNormal = RateSacel(14);
        self.titleSizeSelected = RateSacel(17);
        self.menuView.backgroundColor = MyColor;
        self.showOnNavigationBar = YES;
        self.menuViewStyle = 0;
        self.titleColorNormal = [UIColor groupTableViewBackgroundColor];
        self.titleColorSelected = [UIColor whiteColor];
        self.progressColor = MyColor;
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
                                [[XFLikeViewController alloc] init],
                                [[XFNowViewController alloc] init],
                                [[XFFinishedViewController alloc] init],
                                [[XFMiddleViewController alloc] init],
                                [[XFMiddleViewController alloc] init],
                                
                                ];
    
    
    return controllerArr[index];
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}


#pragma mark - Lazy Loading
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"收藏", @"即时", @"完场", @"中超", @"西甲",];
    }
    return _titleData;
}

@end
