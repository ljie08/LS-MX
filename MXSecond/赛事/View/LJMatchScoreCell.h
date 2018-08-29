//
//  MatchListCell.h
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJMatchScoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLab;//
@property (weak, nonatomic) IBOutlet UILabel *rankingLab;//排名

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithScore:(LJMatchScoreModel *)score isCircle:(BOOL)isCircle;

@end
