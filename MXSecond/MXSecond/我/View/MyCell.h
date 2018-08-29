//
//  MyCell.h
//  MXFootball
//
//  Created by Libra on 2018/7/4.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableView;

- (void)setCellWithTitle:(NSString *)title image:(NSString *)image cache:(CGFloat)cache;

@end
