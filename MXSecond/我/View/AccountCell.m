//
//  AccountCell.m
//  MXFootball
//
//  Created by Libra on 2018/7/5.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "AccountCell.h"

@interface AccountCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation AccountCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"AccountCell";
    AccountCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setCellWithTitle:(NSString *)title content:(NSString *)content {
    if ([title isEqualToString:@"头像"]) {
        self.headerView.hidden = NO;
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:content] placeholderImage:Image(@"touxiang") options:SDWebImageAllowInvalidSSLCertificates];
        self.contentLab.hidden = YES;
    } else {
        self.headerView.hidden = YES;
        self.contentLab.hidden = NO;
    }
    self.titleLab.text = title;
    self.contentLab.text = content;
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
