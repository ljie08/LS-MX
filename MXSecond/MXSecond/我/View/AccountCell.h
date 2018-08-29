//
//  AccountCell.h
//  MXFootball
//
//  Created by Libra on 2018/7/5.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableView;
- (void)setCellWithTitle:(NSString *)title content:(NSString *)content;

@end
