//
//  Header.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#ifndef Header_h
#define Header_h

//当前的windows
#define CurrentKeyWindow [UIApplication sharedApplication].keyWindow
#define ScreenBounds [[UIScreen mainScreen] bounds]     //屏幕frame
#define Screen_Height [[UIScreen mainScreen] bounds].size.height //屏幕高度
#define Screen_Width [[UIScreen mainScreen] bounds].size.width   //屏幕宽度
#define SYSTEMFONT(a) [UIFont systemFontOfSize:a]//字体

//iPhone X
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONEX (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0)
//状态栏高度
#define STATUS_HEIGHT (UI_IS_IPHONEX ? 44: 20)
//iphoneX底部
//#define iPhoneXBottomHeight 34
//导航栏+状态栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT (STATUS_HEIGHT + 44)
//tabbar高度
#define TABBAR_HEIGHT (UI_IS_IPHONEX ? 83: 49)
//底部高度
#define TABBAR_FRAME (UI_IS_IPHONEX ? 34: 0)
//导航栏+状态栏+tabbar高度
#define STATUS_TABBAR_NAVIGATION_HEIGHT (STATUS_AND_NAVIGATION_HEIGHT + TABBAR_HEIGHT)

#define StatusBarHight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度


#define Width_Scale         Screen_Width / 375.0
#define Heigt_Scale         Screen_Height / 667.0
#define RateSacel(a)        a * Screen_Height / 667.0

#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)] //颜色
#define kColorWithRGBF(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
//当前的windows
#define CurrentKeyWindow [UIApplication sharedApplication].keyWindow
#define weakSelf(self) @autoreleasepool{} __weak typeof(self) weak##Self = self;//定义弱引用

#define DateType @"yyyy-MM-dd" //日期格式

#define MyColor [LJUtil hexStringToColor:@"#D4237A"] //主题色
#define FontColor [LJUtil hexStringToColor:@"#333333"] //深灰色字体
#define ProgressColor [LJUtil hexStringToColor:@"#A0CB90"] //深灰色字体
#define LightGrayColor [LJUtil hexStringToColor:@"#666666"] //浅灰色
#define WhiteColor [UIColor whiteColor] //白色
#define RankColor [LJUtil hexStringToColor:@"#F6BC57"] //橙色
#define BGViewColor kColorWithRGBF(0xf0f0f0)//背景色
#define Image(name) [UIImage imageNamed:name] //图片


#define SYSTEMFONT(a) [UIFont systemFontOfSize:a]//字体

#define OddsButtonTag 200   //各种赔率

#define Timestamps 1528340962 //2018-06-7 11:09:22 1528340962
//上一次翻到第几页的key
//#define CityViewLastRead @"CityViewLastReadPage"

//重新登录
#define ReLoginNotification @"Relogin"

#endif /* Header_h */
