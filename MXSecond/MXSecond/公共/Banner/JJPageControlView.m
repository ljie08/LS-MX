
//
//  JJPageControlView.m
//  JJMedia
//
//  Created by JJJR on 16/6/24.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import "JJPageControlView.h"

@implementation JJPageControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setCount:(long)count {
    _count = count;
    self.frame = CGRectMake(0, 0, (count-1) * 15 + 5 * count, 5);//圆点所在的view的frame。圆点间距15，宽高为3
    for (int i = 0; i < count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20 * i, 0, 5, 5)];//圆点大小
        view.layer.cornerRadius = 2.5;
        view.layer.masksToBounds = YES;
        view.tag = 10 + i;
        if (i == 0) {
            view.backgroundColor = MyColor;//选中的圆点颜色
        }else {//未选中的圆点颜色
           view.backgroundColor = [UIColor whiteColor];
        }
        [self addSubview:view];
    }
}

- (void)setCurrentPage:(long)currentPage {
    _currentPage = currentPage;
    for (int i = 0; i < (int)self.count; i++) {
        UIView * view = [self viewWithTag:10 + i];
        if (view.tag == 10+currentPage) {
            view.backgroundColor = MyColor;
        }else {
            view.backgroundColor = [UIColor whiteColor];
        }
    }
}

@end
