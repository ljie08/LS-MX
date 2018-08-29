//
//  XFTableViewCell.m
//  MXFootball
//
//  Created by FreeSnow on 2018/7/3.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "XFTableViewCell.h"

@implementation XFTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
