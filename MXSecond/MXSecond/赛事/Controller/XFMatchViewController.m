//
//  XFMatchViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFMatchViewController.h"
#import "SliderNavBar.h"
#import "LJMatchListViewController.h"

@interface XFMatchViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
    SliderNavBar *_navbar;//类型滑动控件
    UIView *_navView;//导航栏view
    UISegmentedControl *_matchControl;//切换
}

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pageArr;//子VC数组
@property (nonatomic, assign) NSInteger currentIndex;//当前页面index

@end

@implementation XFMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - Control Action
- (void)changeMatchList:(UISegmentedControl *)control {
    NSLog(@"--- %ld", control.selectedSegmentIndex);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SegControl" object:[NSNumber numberWithInteger:control.selectedSegmentIndex]];
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:[NSNumber numberWithInteger:control.selectedSegmentIndex] forKey:@"segIndex"];
}

#pragma mark - UIPageViewControllerDelegate & UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageArr indexOfObject:viewController];
    index --;
    if ((index < 0) || (index == NSNotFound)) {
        return nil;
    }
    return self.pageArr[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageArr indexOfObject:viewController];
    index ++;
    if (index >= self.pageArr.count) {
        return nil;
    }
    return self.pageArr[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        LJMatchListViewController *vc = pageViewController.viewControllers.firstObject;
        NSInteger index = [self.pageArr indexOfObject:vc];
        [_navbar moveToIndex:index];
        
        self.currentIndex = index;
    }
}

#pragma mark - UI
- (void)initUIView {
    self.navigationItem.title = nil;
    [self setupSlider];
    [self setSegControl];
    [self initPage];
}

//
- (void)setupSlider {
    if (!_navbar) {
        _navbar = [[SliderNavBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
        _navbar.buttonTitleArr = @[@"英超", @"西甲", @"意甲", @"德甲", @"法甲", @"欧冠", @"中超"];
        _navbar.mode = BottomLineModeNone;
        _navbar.fontSize = 14;
        _navbar.backgroundColor = [UIColor whiteColor];
        _navbar.selectedColor = FontColor;
        _navbar.unSelectedColor = WhiteColor;
        _navbar.backgroundColor = [UIColor clearColor];
        _navbar.canScrollOrTap = YES;
        [self.navigationController.navigationBar addSubview:_navbar];
    }
}

//
- (void)initPage {
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    _pageArr = [NSMutableArray array];
    for (int i = 0; i < _navbar.buttonTitleArr.count; i++) {
        LJMatchListViewController *list = [[LJMatchListViewController alloc] init];
        list.type = i+2;
        [_pageArr addObject:list];
    }
    
    [_pageViewController setViewControllers:[NSArray arrayWithObject:_pageArr[self.currentIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    _pageViewController.view.frame = CGRectMake(0, CGRectGetMaxY(_matchControl.frame)+5, Screen_Width, Screen_Height-40);
    
    __weak typeof (_pageViewController)weakPageViewController = _pageViewController;
    __weak typeof (_pageArr)weakPageArr = _pageArr;
    weakSelf(self);
    [_navbar setNavBarTapBlock:^(NSInteger index, UIPageViewControllerNavigationDirection direction) {
        [weakPageViewController setViewControllers:[NSArray arrayWithObject:weakPageArr[index]] direction:direction animated:YES completion:nil];
        weakSelf.currentIndex = index;
    }];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_navbar moveToIndex:self.currentIndex];
}

//
- (void)setSegControl {
    if (!_matchControl) {
        _matchControl = [[UISegmentedControl alloc] initWithItems:@[@"助攻榜", @"射手榜", @"积分榜", @"赛程记录"]];
        _matchControl.frame = CGRectMake(10, StatusBarHight+44+5, Screen_Width-20, 30);
        _matchControl.tintColor = FontColor;
        _matchControl.selectedSegmentIndex = 0;
        [_matchControl addTarget:self action:@selector(changeMatchList:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_matchControl];
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
