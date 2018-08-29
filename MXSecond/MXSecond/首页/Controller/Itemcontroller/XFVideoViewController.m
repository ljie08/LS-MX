//
//  XFVideoViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFVideoViewController.h"

#import "XFBaseViewCell.h"
#import <WMPlayer/WMPlayer.h>
@interface XFVideoViewController ()<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate, WMPlayerDelegate>
{
    NSInteger _page;
}
@property(nonatomic,strong)WMPlayer *wmPlayer;
@property (nonatomic, strong) XFBaseViewCell *cuurentCell;/**< 注释 */
@property (nonatomic, strong) JJRefreshTabView *tableView;/**<  */
@property (nonatomic, strong) NSMutableArray <XFNewsModel *>*dataSource;/**< 数据源 */

@end

@implementation XFVideoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self.view addSubview:self.tableView];
    [self refreshTableViewHeader];
    
}

#pragma mark - Hander Methods
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange:(NSNotification *)notification{
    if (self.wmPlayer==nil){
        return;
    }
    if (self.wmPlayer.playerModel.verticalVideo) {
        return;
    }
    if (self.wmPlayer.isLockScreen){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            [self toOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
}

//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation{
    //获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [self.wmPlayer removeFromSuperview];
    //根据要旋转的方向,使用Masonry重新修改限制
    if (orientation ==UIInterfaceOrientationPortrait) {
        [self.cuurentCell addSubview:self.wmPlayer];
        self.wmPlayer.isFullscreen = NO;
        self.wmPlayer.backBtnStyle = BackBtnStyleNone;
        [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.wmPlayer.superview);
        }];
        
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];
        self.wmPlayer.isFullscreen = YES;
        self.wmPlayer.backBtnStyle = BackBtnStylePop;
        
        if(currentOrientation ==UIInterfaceOrientationPortrait){
            if (self.wmPlayer.playerModel.verticalVideo) {
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.wmPlayer.superview);
                }];
            }else{
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
                    make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.center.equalTo(self.wmPlayer.superview);
                }];
            }
            
        }else{
            if (self.wmPlayer.playerModel.verticalVideo) {
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.wmPlayer.superview);
                }];
            }else{
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
                    make.center.equalTo(self.wmPlayer.superview);
                }];
            }
            
        }
    }
    //iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    //也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    if (self.wmPlayer.playerModel.verticalVideo) {
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
        //更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
        //给你的播放视频的view视图设置旋转
        [UIView animateWithDuration:0.4 animations:^{
            self.wmPlayer.transform = CGAffineTransformIdentity;
            self.wmPlayer.transform = [WMPlayer getCurrentDeviceOrientation];
            [self.wmPlayer layoutIfNeeded];
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshDelegate
- (void)refreshTableViewFooter {
    _page += 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager]  getNewListWithVideoPage:_page success:^(NSArray *resultArr, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resultArr.count) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.dataSource addObjectsFromArray:resultArr];
        }else {
            _page -= 1;
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
        
    } failure:^(NSString *error) {
        _page -= 1;
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



- (void)refreshTableViewHeader {
    _page = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager]  getNewListWithVideoPage:_page success:^(NSArray *resultArr, NSString *msg) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resultArr.count) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:resultArr];
            [self.tableView reloadData];
        }else {
            
        }
    } failure:^(NSString *error) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark -- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFBaseViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.index = indexPath;
    cell.newsStyle = VideoNewsStyle;
    cell.model = self.dataSource[indexPath.row];
    weakSelf(self)
    cell.videoPlayer = ^(NSIndexPath *index, XFBaseViewCell *cell) {
        weakSelf.cuurentCell = cell;
        [weakSelf playeVideoWithIndex:index cell:cell];
    };
    return cell;
}

- (void)playeVideoWithIndex:(NSIndexPath * )index cell:(XFBaseViewCell *)cell{
    if (_wmPlayer != nil) {
        //切换下个播放源
        [_wmPlayer removeFromSuperview];
        _wmPlayer = nil;
        [_wmPlayer resetWMPlayer];
    }
        WMPlayerModel *playerModel = [WMPlayerModel new];
        playerModel.title = self.dataSource[index.row].title;
        playerModel.videoURL = [NSURL URLWithString:self.dataSource[index.row].url];
        _wmPlayer = [[WMPlayer alloc]initPlayerModel:playerModel];
        [cell.contentView addSubview:_wmPlayer];
        _wmPlayer.delegate = self;
        _wmPlayer.enableVolumeGesture = YES;
        _wmPlayer.enableFastForwardGesture = YES;
        weakSelf(self)
        [_wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(cell.contentView);
            make.height.mas_equalTo(weakSelf.wmPlayer.mas_width).multipliedBy(9.0/16);
        }];
        [_wmPlayer play];

 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}



#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource.count) {
        return 1;
    }else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count) {
        return self.dataSource.count;
    }else
        return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return Screen_Width * 9/16;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Video Player Delegate
//点击播放暂停按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn {
    
}
//点击关闭按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)backBtn  {
    if (wmplayer.isFullscreen) {
        [self toOrientation:UIInterfaceOrientationPortrait];
    }else{
        [self.wmPlayer pause];
        [self.wmPlayer removeFromSuperview];
        self.wmPlayer = nil;

    }

}
//点击全屏按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn {
    if (self.wmPlayer.isFullscreen) {//全屏
        [self toOrientation:UIInterfaceOrientationPortrait];
    }else{//非全屏
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }
    
}
//点击锁定🔒按钮的方法
//-(void)wmplayer:(WMPlayer *)wmplayer clickedLockButton:(UIButton *)lockBtn;
//单击WMPlayer的代理方法
//-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap;
//双击WMPlayer的代理方法
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap {
    [_wmPlayer pause];
}
//WMPlayer的的操作栏隐藏和显示
-(void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL )isHidden {
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView ==self.tableView){
        if (self.wmPlayer==nil) {
            return;
        }
        if (self.wmPlayer.superview) {
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.cuurentCell.index];
            CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
            if (rectInSuperview.origin.y<-self.cuurentCell.contentView.frame.size.height||rectInSuperview.origin.y>[UIScreen mainScreen].bounds.size.height-([WMPlayer IsiPhoneX]?88:64)-([WMPlayer IsiPhoneX]?83:49)) {//拖动
                [self.wmPlayer removeFromSuperview];
                self.wmPlayer = nil;
            }
        }
    }
}

#pragma mark - Lazy Loading
- (JJRefreshTabView *)tableView {
    if (_tableView == nil) {
        _tableView = [[JJRefreshTabView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - STATUS_TABBAR_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshDelegate = self;
        _tableView.CanRefresh = YES;
        
        _tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        [_tableView registerNib:[UINib nibWithNibName:@"XFBaseViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray <XFNewsModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];

    }
    return _dataSource;
}

@end
