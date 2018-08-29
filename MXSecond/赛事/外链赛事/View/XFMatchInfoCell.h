//
//  XFMatchInfoCell.h
//  MXFootball
//
//  Created by FreeSnow on 2018/7/10.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFBattleModel.h"
#import "XFScoreModel.h"
@interface XFMatchInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *team2Label;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (nonatomic, strong) XFBattleModel *model;/**< model */
@property (nonatomic, strong) XFScoreModel *scoreModel;/**< 注释 */
@end
