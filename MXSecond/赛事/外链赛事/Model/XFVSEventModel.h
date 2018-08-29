//
//  XFVSEventModel.h
//  MXFootball
//
//  Created by FreeSnow on 2018/7/11.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFVSEventModel : NSObject

@property (nonatomic , assign) NSInteger tolDrawn ;
@property (nonatomic , assign) NSInteger tolLost ;
@property (nonatomic , assign) NSInteger tolWon ;
@property (nonatomic , strong) NSArray * battle ;

@end
