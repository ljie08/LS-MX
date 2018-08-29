//
//  XFMatchInfoCell.m
//  MXFootball
//
//  Created by FreeSnow on 2018/7/10.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "XFMatchInfoCell.h"

@implementation XFMatchInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(XFBattleModel *)model {
    _leftResultLabel.hidden = NO;
    _rightResultLabel.hidden =NO;
    _model = model;
    
    _timeLabel.text = [LJUtil timeInterverlToDateStr:[NSString stringWithFormat:@"%@", model.matchStartTime]] ;
    
    _categoryLabel.text = model.eventNm ;
    
    _rateLabel.text = [NSString stringWithFormat:@"%ld-%ld",model.homeScore,model.awayScore] ;
    _teamLabel.text = model.homeNm ;
    _team2Label.text = model.awayNm ;
    
    switch (model.matchRst) {
        case -1:
            _leftResultLabel.text = @"负" ;
            _rightResultLabel.text = @"胜";
            _leftResultLabel.backgroundColor = kColorWithRGBF(0x0082FF);
            _rightResultLabel.backgroundColor = MyColor;
            break;
        case 0:
            _leftResultLabel.text = @"平" ;
            _rightResultLabel.text = @"平";
            
            _leftResultLabel.backgroundColor = [UIColor greenColor];
            _rightResultLabel.backgroundColor = [UIColor greenColor];
            break;
        case 1:
            _leftResultLabel.text = @"胜" ;
            _rightResultLabel.text = @"负";
            _leftResultLabel.backgroundColor = MyColor;
            _rightResultLabel.backgroundColor = kColorWithRGBF(0x0082FF);
            
            break;
            
        default:
            break;
    }
    
}

- (void)setScoreModel:(XFScoreModel *)scoreModel {
    _scoreModel = scoreModel;
    _leftResultLabel.hidden = YES;
    _rightResultLabel.hidden = YES;
    
    _timeLabel.text =  [NSString stringWithFormat:@"胜/负/平%ld/%ld/%ld",scoreModel.won,scoreModel.drawn,scoreModel.lost];
    
    _categoryLabel.text = [NSString stringWithFormat:@"进/失%ld/%ld",scoreModel.goals,scoreModel.against];
    
    _rateLabel.text = _scoreModel.teamNm ;
    _teamLabel.text =  [NSString stringWithFormat:@"排名%ld",_scoreModel.rank];
    _team2Label.text = [NSString stringWithFormat:@"积分%ld",scoreModel.pts];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
