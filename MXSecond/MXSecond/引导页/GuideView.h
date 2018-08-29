//
//  GuideView.h
//  MXSecond
//
//  Created by Libra on 2018/7/17.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuideViewDelegate <NSObject>

- (void)buttonTapped:(UIButton *)button;

@end

@interface GuideView : UIScrollView

//需要展示的图片名字
@property (nonatomic, strong, getter=getImages) NSArray<NSString *> *images;
//自定义pageControl
@property (nonatomic, strong) UIView *pageControl;

@property (nonatomic, assign) id<GuideViewDelegate> guideDelegate;

@end
