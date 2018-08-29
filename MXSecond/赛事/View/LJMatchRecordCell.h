//
//  MatchRecordCell.h
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJMatchRecordCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithRecord:(LJMatchRecordModel *)record;

@end
