//
//  MatchListCell.m
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

//榜单cell
#import "LJMatchScoreCell.h"

@interface LJMatchScoreCell()

@property (weak, nonatomic) IBOutlet UILabel *teamLab;//球队
@property (weak, nonatomic) IBOutlet UILabel *matchLab;//赛
@property (weak, nonatomic) IBOutlet UILabel *winLab;//胜
@property (weak, nonatomic) IBOutlet UILabel *drawLab;//平
@property (weak, nonatomic) IBOutlet UILabel *loseLab;//负
@property (weak, nonatomic) IBOutlet UILabel *goalOrLoseLab;//进/失
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;//积分

@end

@implementation LJMatchScoreCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"LJMatchScoreCell";
    LJMatchScoreCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LJMatchScoreCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithScore:(LJMatchScoreModel *)score isCircle:(BOOL)isCircle {
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
    self.rankingLab.text = [NSString stringWithFormat:@"%ld", score.rank_index];
    self.teamLab.text = score.name_zh;
    self.matchLab.text = [NSString stringWithFormat:@"%ld", score.played];
    self.winLab.text = [NSString stringWithFormat:@"%ld", score.win];
    self.drawLab.text = [NSString stringWithFormat:@"%ld", score.draw];
    self.loseLab.text = [NSString stringWithFormat:@"%ld", score.lost];
    self.goalOrLoseLab.text = [NSString stringWithFormat:@"%ld/%ld", score.hits, score.miss];
    self.scoreLab.text = [NSString stringWithFormat:@"%ld", score.score];
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
