//
//  XFBaseViewCell.h
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CellStyle)
{
    DefaultCellStyle,//无图新闻
    OnePhotoStyle,//一图新闻
    ThreePhotoStyle,//三图新闻
    PhotoSrtyle,//一图
    VideoStyle,//视频
    
};
typedef NS_ENUM(NSInteger, NewType)
{
    DefaultNewsType,//新闻
    FastNewsStyle,//快讯新闻
    PhotoNewsStyle,//图集
    WallPhotoNewsStyle,//壁纸
    OssNewsStyle,//洲闻
    VideoNewsStyle,//视频
    
};

@interface XFBaseViewCell : UITableViewCell
@property (nonatomic, assign) CellStyle style;/**< 展示模式 */
@property (nonatomic, assign) NewType newsStyle;/**< 新闻类型 */


//0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeWidthConstant;

@property (weak, nonatomic) IBOutlet UIView *defaultView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//1
@property (weak, nonatomic) IBOutlet UIView *onePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *onetitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onePhotoImageView;

//2
@property (weak, nonatomic) IBOutlet UIView *thireePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *threeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *threetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *threePhotoImageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *threePhotoImageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *threePhotoImageViewThree;
//3
@property (weak, nonatomic) IBOutlet UIView *PhotoView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;


//4
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLbel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic, strong) XFNewsModel *model;/**< model */
@property (nonatomic, strong) NSIndexPath *index;/**< indez */
@property (nonatomic, strong)  void(^videoPlayer)(NSIndexPath *index, XFBaseViewCell * cell);/**< 注释 */

@end
