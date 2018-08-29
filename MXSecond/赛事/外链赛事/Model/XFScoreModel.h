//
//  XFScoreModel.h
//  MXFootball
//
//  Created by FreeSnow on 2018/7/11.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFScoreModel : NSObject

@property (nonatomic , assign) NSInteger against ;
@property (nonatomic , assign) NSInteger drawn ;
@property (nonatomic , assign) NSInteger goals ;
@property (nonatomic , assign) NSInteger lost ;

@property (nonatomic , assign) NSInteger pts ;
@property (nonatomic , assign) NSInteger rank ;
@property (nonatomic , assign) NSInteger teamId ;
@property (nonatomic , copy) NSString * teamNm ;
@property (nonatomic , assign) NSInteger won ;

@end
