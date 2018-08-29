//
//  XFPhotoCollectionViewCell.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/13.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFPhotoCollectionViewCell.h"

@implementation XFPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray * colorArray = @[
                             kColorWithRGBF(0xEEDFCC),
                             kColorWithRGBF(0xEEE685),
                             kColorWithRGBF(0xE6E6FA),
                             kColorWithRGBF(0xCDB5CD),
                             kColorWithRGBF(0xCDB79E),
                             kColorWithRGBF(0xC6E2FF),
                             
                             ];
    self.photoImageView.backgroundColor = colorArray[arc4random() % colorArray.count];
}

@end
