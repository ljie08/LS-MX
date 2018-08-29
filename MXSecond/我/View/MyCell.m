//
//  MyCell.m
//  MXFootball
//
//  Created by Libra on 2018/7/4.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "MyCell.h"

@interface MyCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIImageView *youView;

@end

@implementation MyCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MyCell";
    MyCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setCellWithTitle:(NSString *)title image:(NSString *)image cache:(CGFloat)cache {
    if ([title isEqualToString:@"清理缓存"]) {
        self.youView.hidden = YES;
        self.cacheLabel.hidden = NO;
        self.cacheLabel.text = [NSString stringWithFormat:@"%.2fM", cache];
    } else if ([title isEqualToString:@"当前版本"]) {
        self.youView.hidden = YES;
        self.cacheLabel.hidden = NO;
        self.cacheLabel.text = @"1.0.0";
    } else {
        self.youView.hidden = NO;
        self.cacheLabel.hidden = YES;
    }
    self.iconView.image = [Image(image) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconView.tintColor = MyColor;
    self.titleLab.text = title;
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
