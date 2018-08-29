//
//  MatchRecordCell.m
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

//赛程记录cell
#import "LJMatchRecordCell.h"

@interface LJMatchRecordCell()

@property (weak, nonatomic) IBOutlet UIImageView *teamALogo;//球队1logo
@property (weak, nonatomic) IBOutlet UIImageView *teamBLogo;//球队2logo
@property (weak, nonatomic) IBOutlet UILabel *teamALab;//球队1
@property (weak, nonatomic) IBOutlet UILabel *teamBLab;//球队2
@property (weak, nonatomic) IBOutlet UILabel *teamAScoreLab;//球队1分数
@property (weak, nonatomic) IBOutlet UILabel *teamBScoreLab;//球队2分数
@property (weak, nonatomic) IBOutlet UILabel *matchStadium;//比赛体育场
@property (weak, nonatomic) IBOutlet UILabel *matchDate;//比赛时间

@end

@implementation LJMatchRecordCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"LJMatchRecordCell";
    LJMatchRecordCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LJMatchRecordCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithRecord:(LJMatchRecordModel *)record {
    [self.teamALogo sd_setImageWithURL:[NSURL URLWithString:record.home_logo_100x130] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    [self.teamBLogo sd_setImageWithURL:[NSURL URLWithString:record.away_logo_100x130] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.teamALab.text = record.home_name;
    self.teamBLab.text = record.away_name;
    self.teamAScoreLab.text = [NSString stringWithFormat:@"%ld", record.home_score];
    self.teamBScoreLab.text = [NSString stringWithFormat:@"%ld", record.away_score];
    if (record.home_score > record.away_score) {
        self.teamALab.textColor = FontColor;
        self.teamAScoreLab.textColor = FontColor;
        self.teamBLab.textColor = LightGrayColor;
        self.teamBScoreLab.textColor = LightGrayColor;
    } else if (record.home_score < record.away_score) {
        self.teamALab.textColor = LightGrayColor;
        self.teamAScoreLab.textColor = LightGrayColor;
        self.teamBLab.textColor = FontColor;
        self.teamBScoreLab.textColor = FontColor;
    } else if (record.home_score == record.away_score) {
        self.teamALab.textColor = FontColor;
        self.teamAScoreLab.textColor = FontColor;
        self.teamBLab.textColor = FontColor;
        self.teamBScoreLab.textColor = FontColor;
    }
    self.matchStadium.text = record.stadium_name;
    self.matchDate.text = [LJUtil timeInterverlToDateStr:record.natch_data_cn];
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
