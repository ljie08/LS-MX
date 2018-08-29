//
//  XFMacthListCell.m
//  MXFootball
//
//  Created by FreeSnow on 2018/7/3.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "XFMacthListCell.h"

@implementation XFMacthListCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeOrNot)];
//    [self.likeOrNotImageView addGestureRecognizer:tap];
}


- (IBAction)lieeActionBtn:(id)sender {
        if ([[PersonDataManager instance] hasLogin]) {
           [self.likeOrNotBtn setImage:!_model.isCollect?[UIImage imageNamed:@"ls_macth_like"]:[UIImage imageNamed:@"ls_macth_unlike"] forState:UIControlStateNormal];
    
        }
        self.likeAction(_index);
}

- (void)likeOrNot {
//    if ([[PersonDataManager instance] hasLogin]) {
//       self.likeOrNotImageView.image = !_model.isCollect?[UIImage imageNamed:@"ls_macth_like"]:[UIImage imageNamed:@"ls_macth_unlike"];
//
//    }
//    self.likeAction(_index);
    
}
- (void)setIndex:(NSIndexPath *)index  {
    _index = index;
}

- (void)setModel:(XFMatchListModel *)model {
    _model = model;
    
    self.team1NameLabel.text = _model.homeTeamName;
    [self.team1LogoImageView sd_setImageWithURL:[NSURL URLWithString:_model.homeTeamLogo] placeholderImage:[UIImage imageNamed:@"ls_macth_huilogo"]];
    self.team2NameLabel.text =_model.visitTeamName;
    [self.team2LogoImageView sd_setImageWithURL:[NSURL URLWithString:_model.visitTeamLogo] placeholderImage:[UIImage imageNamed:@"ls_macth_huilogo"]];
    self.categoryLabel.text = _model.eventName;
    
    switch (_model.matchStatus) {

        case 8:
            //完场
        {
            self.contentLabel.text = [NSString stringWithFormat:@"%d - %d", (int)_model.homeTeamScore, (int)_model.visitTeamScore];
            self.timeLabel.text = [self timeInterverlToDateStr:_model.startGameTime];
        }
            break;

        default:
            //其他
        {
            [self showContent];
        }
            break;
    }
 
}

#pragma mark - 显示内容
- (void)showContent {
    if (_model.matchStatus == 2 ||
        _model.matchStatus == 3 ||
        _model.matchStatus == 4 ||
        _model.matchStatus == 5 ||
        _model.matchStatus == 6 ||
        _model.matchStatus == 7) {
        self.contentLabel.textColor = [UIColor redColor];
        self.contentLabel.text = @"正在直播";
            [self.likeOrNotBtn setImage:_model.isCollect?[UIImage imageNamed:@"ls_macth_like"]:[UIImage imageNamed:@"ls_macth_unlike"] forState:UIControlStateNormal];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",[self matchtime]];
    }else {
        self.timeLabel.text = [self timeInterverlToDateStr:_model.startGameTime];
        self.contentLabel.textColor = [UIColor darkGrayColor];
        self.contentLabel.text = @"即将开始";
            [self.likeOrNotBtn setImage:_model.isCollect?[UIImage imageNamed:@"ls_macth_like"]:[UIImage imageNamed:@"ls_macth_unlike"] forState:UIControlStateNormal];
    }
}

#pragma mark - 时间
- (NSString *)matchtime {
    int matchStartTime = [[LJUtil getNowDateTimeString] doubleValue] - [_model.startBallTime doubleValue];
    NSString * startTime = @"" ;
    if (matchStartTime/3600) {
        startTime = [NSString stringWithFormat:@"%d:%02d:%02d",matchStartTime/3600,matchStartTime%3600/60,matchStartTime%60] ;
    } else if (matchStartTime/60) {
        startTime = [NSString stringWithFormat:@"%d:%02d",matchStartTime/60,matchStartTime%60] ;
    } else {
        startTime = [NSString stringWithFormat:@"%d",matchStartTime] ;
        
    }
    
    return startTime;
}

- (NSString *)timeInterverlToDateStr:(NSString *)timeStr {
    //timeStr时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式yyyy.MM.dd HH:mm
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
