//
//  JJPageControlView.h
//  JJMedia
//
//  Created by JJJR on 16/6/24.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJPageControlView : UIView

@property (nonatomic, assign) long count;//根据banner 数量创建 多少个view
@property (nonatomic, assign) long currentPage;//当前选中的page

@end
