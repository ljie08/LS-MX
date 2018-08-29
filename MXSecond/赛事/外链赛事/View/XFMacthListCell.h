//
//  XFMacthListCell.h
//  MXFootball
//
//  Created by FreeSnow on 2018/7/3.
//  Copyright © 2018年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFTableViewCell.h"
@interface XFMacthListCell : XFTableViewCell

@property (nonatomic, strong) void (^likeAction)(NSIndexPath * index);/**< 收藏或者取消 */

@property (weak, nonatomic) IBOutlet UIImageView *team1LogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *team2LogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *team1NameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeOrNotBtn;

@property (weak, nonatomic) IBOutlet UILabel *team2NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) XFMatchListModel *model;
@property (nonatomic, strong) NSIndexPath *index;/**< cell位置 */




- (void)setModel:(XFMatchListModel *)model;
@end
