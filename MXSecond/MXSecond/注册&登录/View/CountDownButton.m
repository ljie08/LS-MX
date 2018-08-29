//
//  CountDownButton.m
//  MXFootball
//
//  Created by Libra on 2018/7/2.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "CountDownButton.h"

@interface CountDownButton () {
    NSInteger _countDown;
    NSTimer *_countDownTimer;
}

@end

@implementation CountDownButton

- (id)init {
    
    if (self = [super init]) {
        
        [self setUpView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpView];
    }
    
    return self;
}

- (void)setUpView {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    if (self.title) {
        [self setTitle:self.title forState:UIControlStateNormal];
    } else {
        
        [self setTitle:@"获取验证" forState:UIControlStateNormal];
    }
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
}

- (void)startCountDown {
    _countDown = 59;
    
    self.enabled = NO;
    [self setTitle:[NSString stringWithFormat:@"%lds", (long) _countDown] forState:UIControlStateNormal];
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
}

- (void)timeFireMethod {
    _countDown--;
    [self setTitle:[NSString stringWithFormat:@"%lds", (long) _countDown] forState:UIControlStateNormal];
    
    if (_countDown == 0) {
        [self reset];
    }
}

- (void)reset {
    if (_countDownTimer) {
        [_countDownTimer invalidate];
    }
    
    self.enabled = YES;
    if (self.title) {
        [self setTitle:self.title forState:UIControlStateNormal];
    } else {
        
        [self setTitle:@"获取验证" forState:UIControlStateNormal];
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
//        self.layer.borderColor = ;
        self.layer.cornerRadius = 5;
//        self.layer.borderColor = mx_BlueColor.CGColor;
        self.layer.borderWidth = 1;
//        self.backgroundColor = BrownThemeColor;
    } else {
//        self.backgroundColor = [UIColor grayColor];
    }
}

@end
