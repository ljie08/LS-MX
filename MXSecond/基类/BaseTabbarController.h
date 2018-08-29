//
//  BaseTabbarController.h
//  IOSFrame
//
//  Created by lijie on 2017/7/17.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface BaseTabbarController : UITabBarController

@property (nonatomic, strong) BaseNavigationController *currentNav;/**< 当前控制器 */

- (void)setChildVCWithViewController:(UIViewController *)controller title:(NSString *)title image:(UIImage *)image selectedImg:(UIImage *)selectedImg;

@end
