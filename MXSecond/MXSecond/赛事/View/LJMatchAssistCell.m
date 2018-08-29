//
//  LJMatchAssistCell.m
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

//助攻cell
#import "LJMatchAssistCell.h"

@interface LJMatchAssistCell()

@property (weak, nonatomic) IBOutlet UILabel *playerLab;
@property (weak, nonatomic) IBOutlet UILabel *teamLab;
@property (weak, nonatomic) IBOutlet UILabel *assistLab;

@end

@implementation LJMatchAssistCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"LJMatchAssistCell";
    LJMatchAssistCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LJMatchAssistCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithAssist:(LJMatchAssistModel *)assist isCircle:(BOOL)isCircle {
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
    self.rankingLab.text = [NSString stringWithFormat:@"%ld", assist.rank_index];
    self.playerLab.text = assist.player_name;
    self.teamLab.text = assist.team_name;
    self.assistLab.text = [NSString stringWithFormat:@"%ld", assist.assist_count];
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
