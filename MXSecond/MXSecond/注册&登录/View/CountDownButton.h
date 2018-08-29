//
//  CountDownButton.h
//  MXFootball
//
//  Created by Libra on 2018/7/2.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownButton : UIButton

@property(nonatomic, strong) NSString *title;

-(void)startCountDown;

-(void)reset;

@end
