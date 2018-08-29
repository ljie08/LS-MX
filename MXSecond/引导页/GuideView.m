//
//  GuideView.m
//  MXSecond
//
//  Created by Libra on 2018/7/17.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "GuideView.h"

@interface GuideView () {
    NSTimer *_timer;//计时器
}

//读出图片的地址
@property (nonatomic, strong) NSMutableArray<UIImage *> *imageMutableArray;
//按钮
@property (nonatomic, strong) UIButton *firstBtn;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//判断当前第几页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation GuideView

- (instancetype)init {
    self = [super init];
    self.frame = [UIScreen mainScreen].bounds;
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.frame = [UIScreen mainScreen].bounds;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.frame = [UIScreen mainScreen].bounds;
    return self;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    //执行操作
    [self toDoList];
}

//guideview执行列表
- (void)toDoList {
    //如果读取不到图片，返回
    if (![self readImage]) {
        return;
    }
    //设置scrollview属性
    [self setScrollViewParams];
    //设置图片
    [self setScrollViewImages];
    //设置pageControl
    [self setScrollViewPageControl];
    //设置按钮
    [self setScrollViewButtons];
    //上次读取位置
//    [self setScrollViewLastReadPage];
}

//根据图片的名字获得图片数组
- (BOOL)readImage {
    if (!self.images || ![self.images isKindOfClass:[NSArray class]]) {
        return NO;
    } else if (self.images.count == 0) {
        return NO;
    } else {
        self.imageMutableArray = [NSMutableArray arrayWithCapacity:self.images.count];
        for (NSString *fileUrl in self.images) {
            UIImage *image = Image(fileUrl);
            if (image) {
                [self.imageMutableArray addObject:image];
            }
        }
        if (self.imageMutableArray.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

//设置scrollview属性
- (void)setScrollViewParams {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    self.scrollsToTop = NO;
    self.contentSize = CGSizeMake(self.bounds.size.width * self.imageMutableArray.count, self.bounds.size.height);
    self.pagingEnabled = YES;
    //监听offset
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

//监听scrollview的contentoffset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *pointValue = [change objectForKey:@"new"];
        CGPoint point;
        [pointValue getValue:&point];
        [self setCurrentPage:point];
    }
}

//设置pageControl当前的页码
- (void)setCurrentPage:(CGPoint)point{
    NSInteger index = fabs(point.x) / self.bounds.size.width;
    //保存页数
//    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:[JJAPPSingleton Instance].LastGuidPageIndex];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //设置最后一页按钮的显示隐藏
    if (index == self.imageMutableArray.count - 1) {
        //按钮出现
        [self buttonsShow];
        
    } else if (self.pageIndex == self.imageMutableArray.count - 1 && ((int)point.x)%((int)self.bounds.size.width) > 30){
        //按钮隐藏
        [self buttonsHidden];
    }
    
    if (self.pageIndex != index) {
        self.pageIndex = index;
        for (int i = 0; i < self.imageMutableArray.count; i++) {
            UIImageView *pageImageView = (UIImageView *)[self.pageControl viewWithTag:1000 + i];
            if (pageImageView.tag == self.pageIndex + 1000) {
                pageImageView.backgroundColor = MyColor;
            } else {
                pageImageView.backgroundColor = WhiteColor;
            }
        }
        [self setAndUpdataTimer:self.pageIndex];
    }
}

//设置图片
- (void)setScrollViewImages {
    for (int i = 0; i < self.imageMutableArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectOffset(self.bounds, self.bounds.size.width * i, 0);
        imageView.image = [self.imageMutableArray objectAtIndex:i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
    }
}

//设置pageControl
- (void)setScrollViewPageControl {
    self.pageIndex = 0;
    self.pageControl = [[UIView alloc] init];
    if (self.bounds.size.width - self.imageMutableArray.count * 30 > 0) {//根据图片的的个数来改变宽度，目前最大支持12张图片
        self.pageControl.frame = CGRectMake((self.bounds.size.width - self.imageMutableArray.count * 30 + 10) / 2, self.bounds.size.height - 50, self.imageMutableArray.count * 30 - 10, 20);
    } else {
        self.pageControl.frame = CGRectMake(0, self.bounds.size.height - 50, self.bounds.size.width, 20);
    }
    
    [self.superview addSubview:self.pageControl];
    for (int i = 0; i < self.imageMutableArray.count; i++) {
        UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 * i, 0, 20, 6)];
        pageImageView.layer.cornerRadius = 3;
        pageImageView.layer.masksToBounds = YES;
        pageImageView.tag = 1000 + i;
        if (i == 0) {
            pageImageView.backgroundColor = MyColor;
        } else {
            pageImageView.backgroundColor = WhiteColor;
        }
        [self.pageControl addSubview:pageImageView];
    }
}

//初始化最后一页的两个按钮
- (void)setScrollViewButtons {
    self.firstBtn = [[UIButton alloc] init];
    self.firstBtn.frame = CGRectMake(self.bounds.size.width * (self.imageMutableArray.count - 1) + (self.bounds.size.width - 130) / 2, self.bounds.size.height, 130, 35);
    self.firstBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.firstBtn setTitle:@"进去逛逛" forState:UIControlStateNormal];
    self.firstBtn.backgroundColor = MyColor;
    self.firstBtn.layer.cornerRadius = 17.5;
    self.firstBtn.layer.masksToBounds = YES;
    
//    [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"launchButtonImg"] forState:UIControlStateNormal];
    [self.firstBtn addTarget:self action:@selector(showHomePageController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.firstBtn];
}

- (void)showHomePageController {
    if ([self.guideDelegate respondsToSelector:@selector(buttonTapped:)]) {
        [self.guideDelegate buttonTapped:nil];
    }
}

//上次读取位置
//- (void)setScrollViewLastReadPage {
//    NSInteger lastRead = [[NSUserDefaults standardUserDefaults] integerForKey:[JJAPPSingleton Instance].LastGuidPageIndex];
//    if (lastRead > self.imageMutableArray.count - 1) {//防止上一版本的图片多于本版本导致错误
//        lastRead = self.imageMutableArray.count - 1;
//    }
//    self.contentOffset = CGPointMake(self.bounds.size.width * lastRead, 0);
//    [self setAndUpdataTimer:lastRead];
//}

//重置定时器，每张图片停留6s
- (void)setAndUpdataTimer:(NSInteger)num {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (num < self.imageMutableArray.count - 1) {//只有当前所在的图片小于图片总数减一时，才会开始定时器6s计时
        self.timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timechang:) userInfo:nil repeats:NO];
    }
}

//定时器执行方法
- (void)timechang:(id)sender {
    if (self.pageIndex < self.imageMutableArray.count - 1) {
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentOffset = CGPointMake(Screen_Width * (self.pageIndex + 1), 0);
        } completion:nil];
    }
}

//按钮出现
- (void)buttonsShow {
    CGRect frame = self.firstBtn.frame;
    CGFloat oY = self.bounds.size.height - frame.size.height - 90;
    if (self.bounds.size.height > 680) {
        oY = self.bounds.size.height - frame.size.height - 100;
    } else if (self.bounds.size.height < 600) {
        oY = self.bounds.size.height - frame.size.height - 80;
    }
    frame.origin.y = oY;
    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.firstBtn.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

//按钮隐藏
- (void)buttonsHidden {
    CGRect frame = self.firstBtn.frame;
    CGFloat oY = self.bounds.size.height;
    frame.origin.y = oY;
    [UIView animateWithDuration:0.2f delay:0.05f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.firstBtn.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}


@end
