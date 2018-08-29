//
//  XFBaseViewCell.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFBaseViewCell.h"

@implementation XFBaseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.onePhotoView.hidden = YES;
    self.thireePhotoView.hidden = YES;
    self.PhotoView.hidden = YES;
    self.videoView.hidden = YES;
//    self.photoImageView.userInteractionEnabled = NO;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicShow)];
//    [self.photoImageView addGestureRecognizer:tap];
}

-(void)setModel:(XFNewsModel *)model {
    _model = model;
    if (_newsStyle == DefaultNewsType || _newsStyle == OssNewsStyle || _newsStyle == WallPhotoNewsStyle) {
        if (model.morepic.count) {
            self.style = ThreePhotoStyle;
        }else if(model.titlepic.length){
            self.style = OnePhotoStyle;
        }else {
            self.style = DefaultCellStyle;
        }
    }else if(_newsStyle == PhotoNewsStyle) {
        self.style = PhotoSrtyle;
    }else {
        if (_newsStyle == FastNewsStyle) {
            self.style = DefaultCellStyle;
        }else {
            self.style = VideoStyle;
        }
    }
    
    
}

- (void)setNewsStyle:(NewType)newsStyle {
    _newsStyle = newsStyle;
}

-(void)setStyle:(CellStyle)style {
    _style = style;
    self.onePhotoView.hidden = YES;
    self.thireePhotoView.hidden = YES;
    self.PhotoView.hidden = YES;
    self.videoView.hidden = YES;
    self.defaultView.hidden = YES;
    switch (_style) {
        case DefaultCellStyle:
        {
            [self.contentView addSubview:self.defaultView];
            [self updateUI];
        }
            
            break;
        case OnePhotoStyle:
        {
            [self updateOnePhotoUI];
            [self.contentView addSubview:self.onePhotoView];
            
        }
            break;
            
        case ThreePhotoStyle:
        {
            [self updateThreeePhotoUI];
            [self.contentView addSubview:self.thireePhotoView];
            
        }
            break;
            
        case PhotoSrtyle:
        {
            [self updatePhotoUI];
            [self.contentView addSubview:self.PhotoView];
        }
            break;
            
        case VideoStyle:
        {
            [self updateVideoUI];
            [self.contentView addSubview:self.videoView];
        }
            break;
            
            
        default:
            break;
    }
}

- (void)updateUI {
    self.defaultView.hidden = NO;
    
    
    if (_newsStyle == FastNewsStyle) {
        self.timeWidthConstant.constant = 40;
        self.titleLabel.text = _model.title;
        self.contentLabel.text = _model.Description;
        self.timeLabel.text = [[LJUtil timeInterverlToDateStr:_model.pubTime formatter:@"yyyy-MM-dd HH:mm"] substringFromIndex:11];
    }else {
        self.timeWidthConstant.constant = 0;
        self.titleLabel.text = _model.title;
        self.contentLabel.text = _model.smalltext;
        self.timeLabel.text = @"";
    }
}

- (void)updateVideoUI {
    self.videoView.hidden = NO;
    self.videoTitleLbel.text = _model.title;
    self.videoTimeLabel.text = @"";
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"ImageBg"]];
}

- (void)updateOnePhotoUI {
    self.onePhotoView.hidden = NO;
    self.oneTimeLabel.text = [LJUtil timeInterverlToDateStr:[NSString stringWithFormat:@"%@", _model.newstime]];
    self.onetitleLabel.text = _model.title;
    [self.onePhotoImageView sd_setImageWithURL:[NSURL URLWithString:_model.titlepic]  placeholderImage:[UIImage imageNamed:@"ImageBg"]];
}

- (void)updateThreeePhotoUI {
    self.thireePhotoView.hidden = NO;
    for (int i = 0; i < _model.morepic.count; i++) {
        if (i == 0) {
            [self.threePhotoImageViewOne sd_setImageWithURL:[NSURL URLWithString:_model.morepic[0]]  placeholderImage:[UIImage imageNamed:@"ImageBg"]];
        }else if (i == 1) {
            [self.threePhotoImageViewTwo sd_setImageWithURL:[NSURL URLWithString:_model.morepic[1]]  placeholderImage:[UIImage imageNamed:@"ImageBg"]];
        }else {
            [self.threePhotoImageViewThree sd_setImageWithURL:[NSURL URLWithString:_model.morepic[2]]  placeholderImage:[UIImage imageNamed:@"ImageBg"]];
        }
    }
    
    
    self.threeTitleLabel.text = _model.title;
    self.threetimeLabel.text = [LJUtil timeInterverlToDateStr:[NSString stringWithFormat:@"%@", _model.newstime]];
}


- (void)updatePhotoUI {
    self.PhotoView.hidden = NO;
//    self.photoImageView.userInteractionEnabled = YES;
    self.photoTitleLabel.text = _model.title;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_model.titlepic]  placeholderImage:[UIImage imageNamed:@"ImageBg"]];
}
- (void)setIndex:(NSIndexPath *)index {
    _index = index;
}

- (IBAction)videoPlayeBtn:(UIButton *)sender {
    self.videoPlayer(_index, self);
}

//- (void)clickPicShow {
//    self.videoPlayer(_index, self);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
