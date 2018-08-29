//
//  MyHeaderCell.m
//  MXFootball
//
//  Created by Libra on 2018/7/4.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "MyHeaderCell.h"

@interface MyHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *signLab;

@end

@implementation MyHeaderCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MyHeaderCell";
    MyHeaderCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyHeaderCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setHeaderDataWithUser:(User *)user {
    if (user.userId) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:user.headerPic] placeholderImage:Image(@"touxiang") options:SDWebImageAllowInvalidSSLCertificates];
        self.nameLab.text = user.username;
        self.signLab.text = user.userSign;
    } else {
        self.headerView.image = Image(@"touxiang");
        self.nameLab.text = @"未登录";
        self.signLab.text = @"未登录";
    }
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
