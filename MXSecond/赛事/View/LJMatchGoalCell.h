//
//  LJMatchPlayerCell.h
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJMatchGoalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLab;
@property (weak, nonatomic) IBOutlet UILabel *rankingLab;//排名

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithGoal:(LJMatchGoalModel *)goal isCircle:(BOOL)isCircle;

@end
