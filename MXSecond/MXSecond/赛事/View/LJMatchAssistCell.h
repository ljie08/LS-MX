//
//  LJMatchAssistCell.h
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJMatchAssistCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLab;
@property (weak, nonatomic) IBOutlet UILabel *rankingLab;

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithAssist:(LJMatchAssistModel *)assist isCircle:(BOOL)isCircle;

@end
