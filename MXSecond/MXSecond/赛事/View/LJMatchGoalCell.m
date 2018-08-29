//
//  LJMatchPlayerCell.m
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

//射手cell
#import "LJMatchGoalCell.h"

@interface LJMatchGoalCell()

@property (weak, nonatomic) IBOutlet UILabel *playerLab;//球员
@property (weak, nonatomic) IBOutlet UILabel *teamLab;//球队
@property (weak, nonatomic) IBOutlet UILabel *goalLab;///进球
@property (weak, nonatomic) IBOutlet UILabel *penaltyLab;//点球

@end

@implementation LJMatchGoalCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"LJMatchGoalCell";
    LJMatchGoalCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LJMatchGoalCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithGoal:(LJMatchGoalModel *)goal isCircle:(BOOL)isCircle {
    if (isCircle) {
        self.rankingLab.textColor = WhiteColor;
        self.rankingLab.layer.cornerRadius = 9;
        self.rankingLab.layer.masksToBounds = YES;
        self.rankingLab.backgroundColor = RankColor;
    } else {
        self.rankingLab.textColor = FontColor;
        self.rankingLab.layer.cornerRadius = 0;
        self.rankingLab.layer.masksToBounds = YES;
        self.rankingLab.backgroundColor = [UIColor clearColor];
    }
    self.rankingLab.text = [NSString stringWithFormat:@"%ld", goal.rank_index];
    self.playerLab.text = goal.player_name;
    self.teamLab.text = goal.team_name;
    self.penaltyLab.text = [NSString stringWithFormat:@"%ld", goal.pen_goal_count];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
