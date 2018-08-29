//
//  AppDelegate.m
//  MXSecond
//
//  Created by ljie on 2017/9/4.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabbarController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
//#import <IQKeyboardManager.h>

@interface AppDelegate ()

@property (nonatomic, strong) BaseTabbarController *tabVC;/**< <#注释#> */

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 20.0;
    
    [self setTabBarController];
    
    [self registerReloginNotification];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setTabBarController {
    self.tabVC = [[BaseTabbarController alloc] init];
    self.window.rootViewController = self.tabVC;
}

- (void)registerReloginNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRelogin) name:ReLoginNotification object:nil];
}

- (void)userRelogin {
    [[PersonDataManager instance] logOut];
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:login];
    [[self.tabVC.currentNav.viewControllers lastObject].navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
