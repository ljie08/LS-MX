//
//  BaseViewController.m
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;//    自动滚动调整，默认为YES
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//
//    [self setThemeImgWithPicture:@"bg"];
    
    [self initViewModelBinding];
    [self initUIView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *themeName = [defaults objectForKey:@"themeName"];
//    [self setThemeImgWithPicture:themeName];
//    NSLog(@"themeName -> %@", themeName);
}


#pragma mark - 页面UI初始化搭建
- (void)initUIView {
}

#pragma mark - 设置背景图
- (void)setThemeImgWithPicture:(NSString *)name {
    UIImage *image = [[UIImage alloc] init];
    if (name == nil) {
        image = [UIImage imageNamed:@"bg"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    } else {
        image = [UIImage imageNamed:name];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:name]];
    }
    self.view.layer.contents = (id) image.CGImage;// 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
}

#pragma mark - 创建ViewModel，viewModel的参数初始化工作等

- (void)initViewModelBinding {
    
}

/**
 自定义标题字体、颜色、大小等
 
 @param title 标题
 */
- (void)initTitleViewWithTitle:(NSString *)title {
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.textColor = WhiteColor;
    self.navigationItem.titleView = titleLab;
}

/**
 * @brief  设置导航的标题 左右item
 *
 * @param
 *
 * @return
 */

/**
 设置导航栏
 
 @param title 标题
 @param left 左item
 @param right 右item
 @param view 标题view
 */
- (void)addNavigationWithTitle:(NSString *)title leftItem:(UIBarButtonItem  *)left rightItem:(UIBarButtonItem *)right titleView:(UIView *)view {
    if (title) {
        // 设置导航的标题
        self.navigationItem.title = title;
    }
    
    if (left) {
        // 设置左边的item
        self.navigationItem.leftBarButtonItem = left;
    }
    
    if (right) {
        // 设置右边的item
        self.navigationItem.rightBarButtonItem = right;
    }
    
    if (view) {
        // 设置标题view
        self.navigationItem.titleView = view;
    }
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@""];
}

//设置返回按钮是否显示
- (void)setBackButton:(BOOL)isShown {
    if (isShown) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 40, 40);
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//避免iOS 11上导航栏按钮frame小，点不到区域。将按钮设置大点，居左显示
        [backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        self.navigationItem.leftBarButtonItem = leftItem;//[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

//返回
- (void)goBack {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

//返回到根视图控制器
- (void)goRootBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 网络小菊花
//网络请求等待
- (MBProgressHUD *)showWaiting {
    return [self showWaitingOnView:self.view];
}

//停止网络请求等待
- (void)hideWaiting {
    [self hidewaitingOnView:self.view];
}

- (MBProgressHUD *)showWaitingOnView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud) {
        return hud;
    }
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = @"加载中...";
    return hud;
}

- (void)hidewaitingOnView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)showMassage:(NSString *)massage {//提示消息
    if (massage) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = massage;
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.margin = 10.f;
        [hud setOffset:CGPointMake(0, 0)];
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.0f];
        
    }
}

@end
