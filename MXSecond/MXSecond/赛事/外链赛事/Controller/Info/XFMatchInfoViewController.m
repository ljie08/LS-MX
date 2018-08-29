//
//  XFMatchInfoViewController.m
//  MXFootball
//
//  Created by FreeSnow on 2018/7/10.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "XFMatchInfoViewController.h"
#import "XFMatchInfoCell.h"
#import "XFBattleModel.h"
#import "XFMatchInfoModel.h"
#import "UITableView+HD_NoList.h"
#define ButtonTag 100      //按钮标签
@interface XFMatchInfoViewController ()<UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

//#define OddsButtonTag 200   //各种赔率

//#define Timestamps 1528340962 //2018-06-7 11:09:22 1528340962
//底部五个按钮
@property (nonatomic, strong) UIButton * fundamentalsBtn ;//基本面
@property (nonatomic, strong) UIButton * diskBtn ;//盘面
@property (nonatomic, strong) UIButton * lineupBtn ;//阵容
@property (nonatomic, strong) UIButton * viewpointBtn ;//观点

@property (nonatomic, strong) NSArray * oddsNameArray ;


@property (nonatomic, strong) UIView * blueView ; //头部蓝色视图
@property (nonatomic , strong) UIImageView * backImgView ; //
@property (nonatomic, strong) UILabel *vsLabel;/**< VS */

@property (nonatomic , strong) UILabel * timeLabel ;//比赛开始时间
@property (nonatomic , strong) UILabel * statusLabel ;//比赛状态

@property (nonatomic , strong) UILabel * aTeamNameL ;//主队名
@property (nonatomic , strong) UILabel * aNumberL ;//主队得分
@property (nonatomic , strong) UIImageView * homeLogoView ;//主队logo

@property (nonatomic , strong) UILabel * bTeamNameL ;//客队名
@property (nonatomic , strong) UILabel * bNumberL ;//客队得分
@property (nonatomic , strong) UIImageView * awayLogoView ;//客队logo

@property (nonatomic , assign) BOOL isGetData ;//获取基本面数据成功

@property (nonatomic , strong) XFMatchInfoModel * basicPanelModel ;

@property (nonatomic , strong) XFBattleModel * battleModel ;
@property (nonatomic, strong) NSMutableArray *dataSourrce;/**<  */
@property (nonatomic, strong) JJRefreshTabView *tableView;/**< tabelview */

@end

@implementation XFMatchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton:YES];
    [self.view addSubview:self.tableView];
    [self refreshTableViewHeader];
    [self updateUI];
    [self configUI];
}

#pragma mark - Handler Methods
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    //通过设置shadowImage移除黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor =  BGViewColor;
//    self.automaticallyAdjustsScrollViewInsets = NO ;
    self.title = _titleString ;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.view addSubview:self.blueView];
    
//    [self.view addSubview:self.fundamentalsBtn];
    self.fundamentalsBtn.userInteractionEnabled = NO;
    //    [self.view addSubview:self.lineupBtn];

    if (Timestamps - [[LJUtil getNowDateTimeString] doubleValue]  > 0) {
        self.fundamentalsBtn.frame = CGRectMake(0, Screen_Height - RateSacel(44) - TABBAR_FRAME, Screen_Width / 2, RateSacel(44));
        self.lineupBtn.frame = CGRectMake(CGRectGetMaxX(self.fundamentalsBtn.frame) , CGRectGetMinY(self.fundamentalsBtn.frame), Screen_Width / 2, RateSacel(44));
        return ;
    } else {
        
    }
    
    self.fundamentalsBtn.frame = CGRectMake(0, Screen_Height - RateSacel(44)  - TABBAR_FRAME, Screen_Width, RateSacel(44));
}
- (void)updateUI {
    self.matchId = _model.matchId ;
    self.titleString = _model.eventShortName ;
    _status = _model.matchStatus;
    
    self.homeNm = _model.homeTeamName ;
    self.homeScore = [NSString stringWithFormat:@"%ld",_model.homeTeamScore] ;
    self.homeLogo = _model.homeTeamLogo ;
    
    self.awayNm = _model.visitTeamName ;
    self.awayScore = [NSString stringWithFormat:@"%ld",_model.visitTeamScore] ;
    self.awayLogo = _model.visitTeamLogo ;
    
    self.status = (int)_model.matchStatus ;
    self.matchStartTime = _model.startGameTime ;
    self.flashFlg = _model.flashFlg ;
    
}
-(void)createleftBarButtonItem{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //避免iOS 11上导航栏按钮frame小，点不到区域。将按钮设置大点，居左显示
    [backBtn setImage:[UIImage imageNamed:@"mxWodeBackbtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - Action Events
- (void)selectorButton:(UIButton *)button {
    NSInteger tag = button.tag - ButtonTag;
    
    if (Timestamps - [[LJUtil getNowDateTimeString] doubleValue]  > 0) {
        
        switch (tag) {
            case 1:
                self.lineupBtn.selected = NO;
                self.fundamentalsBtn.selected = YES;
                //                self.selectIndex = 0 ;
                break;
            case 3:
                self.fundamentalsBtn.selected = NO;
                self.lineupBtn.selected = YES;
                //                self.selectIndex = 1 ;
                break;
                
            default:
                break;
        }
        
        }
    
    self.fundamentalsBtn.selected = NO;
    self.diskBtn.selected = NO;
    self.lineupBtn.selected = NO;
    self.viewpointBtn.selected = NO;
    switch (tag) {
        case 1:
            self.fundamentalsBtn.selected = YES;
            break;
        case 2:
            self.diskBtn.selected = YES;
            break;
        case 3:
            self.lineupBtn.selected = YES;
            break;
        case 10:
            
            break;
        case 7:
            self.viewpointBtn.selected = YES;
            break;
            
        default:
            break;
    }
    
}

// 左上角按钮点击事件
-(void)backActon{
    [self.navigationController popViewControllerAnimated:YES];
    //    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setter  Methods
-(void)setModel:(XFMatchListModel *)model {
    _model = model;
}

#pragma mark - Lazy Loading
#pragma mark - 赛事信息
- (UIButton *)fundamentalsBtn {
    if (!_fundamentalsBtn) {
        _fundamentalsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fundamentalsBtn.backgroundColor = [UIColor whiteColor];
        [_fundamentalsBtn setTitle:@"基本面" forState:UIControlStateNormal];
        [_fundamentalsBtn setSelected:YES];
        [_fundamentalsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_fundamentalsBtn setTitleColor:MyColor forState:UIControlStateSelected];
        _fundamentalsBtn.tag = ButtonTag + 1;
        [_fundamentalsBtn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fundamentalsBtn;
}

#pragma mark - 赛况信息
- (UIView *)blueView {
    
    if (!_blueView) {
        _blueView = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, Screen_Width, RateSacel(110))];
        _blueView.backgroundColor = MyColor;
        
        self.backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, RateSacel(345), RateSacel(78))] ;
        //
        self.backImgView.center = CGPointMake(Screen_Width/2, RateSacel(39)) ;
        [_blueView addSubview:self.backImgView] ;
        self.vsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RateSacel(345), RateSacel(25))];
        self.vsLabel.textAlignment = 1;
        self.vsLabel.text = @"VS";
        self.vsLabel.textColor = [UIColor whiteColor];
        self.vsLabel.font = [UIFont boldSystemFontOfSize:28];
        [_blueView addSubview: self.vsLabel];
        self.vsLabel.hidden = YES;
        
        
        
        //比赛开始时间
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, RateSacel(17), Screen_Width, RateSacel(10))];
        //        timeLabel.text = @"2018-03-08 11:30";
        
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = SYSTEMFONT(RateSacel(10));
        self.timeLabel.textAlignment = 1;
        [_blueView addSubview:self.timeLabel];
        
        //比赛状态
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame) + RateSacel(7), Screen_Width, RateSacel(10))];
        //        statusLabel.text = @"完场";
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = SYSTEMFONT(RateSacel(10));
        self.statusLabel.textAlignment = 1;
        [_blueView addSubview:self.statusLabel];
        
        //按钮@“赛况”
        UIButton * situationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        situationBtn.frame = CGRectMake(0, 0, RateSacel(66), RateSacel(22));
        situationBtn.center = CGPointMake(Screen_Width/2, RateSacel(78 + 11 + 5));
        situationBtn.layer.masksToBounds = YES;
        situationBtn.layer.cornerRadius = RateSacel(11) ;
        [situationBtn setTitle:@"赛况" forState:(UIControlStateNormal)];
        situationBtn.titleLabel.font = SYSTEMFONT(RateSacel(10)) ;
        [situationBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [situationBtn setBackgroundColor:[UIColor whiteColor]];
        [situationBtn addTarget:self action:@selector(clickedSituationBtn) forControlEvents:UIControlEventTouchUpInside];
        //        [_blueView addSubview:situationBtn];
        
        
        
        self.aTeamNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width / 2 , RateSacel(10))];
        self.aTeamNameL.center = CGPointMake(Screen_Width/4, RateSacel(50));
        //        aTeamNameL.text = @"莱昂";
        
        self.aTeamNameL.textColor = [UIColor whiteColor];
        self.aTeamNameL.font = SYSTEMFONT(RateSacel(10));
        self.aTeamNameL.textAlignment = 1;
        [_blueView addSubview:self.aTeamNameL];
        
        self.aNumberL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width / 2 , RateSacel(31))];
        self.aNumberL.center = CGPointMake(Screen_Width/4, CGRectGetMidY(self.aTeamNameL.frame) -  RateSacel(22));
        //        aNumberL.text = @"4";
        self.aNumberL.textColor = [UIColor whiteColor];
        self.aNumberL.font = SYSTEMFONT(RateSacel(31));
        self.aNumberL.textAlignment = 1;
        [_blueView addSubview:self.aNumberL];
        
        self.homeLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, RateSacel(11), RateSacel(115), RateSacel(41))] ;
        self.homeLogoView.contentMode = UIViewContentModeScaleAspectFit ;
        //        homeLogo.backgroundColor = [UIColor redColor] ;
        [self.backImgView addSubview:self.homeLogoView] ;
        
        
        
        
        self.bTeamNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width / 2 , RateSacel(10))];
        self.bTeamNameL.center = CGPointMake(Screen_Width * 3.f/4, RateSacel(50));
        //        bTeamNameL.text = @"塞拉娅";
        
        self.bTeamNameL.textColor = [UIColor whiteColor];
        self.bTeamNameL.font = SYSTEMFONT(RateSacel(10));
        self.bTeamNameL.textAlignment = 1;
        [_blueView addSubview:self.bTeamNameL];
        
        self.bNumberL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width / 2 , RateSacel(31))];
        self.bNumberL.center = CGPointMake(Screen_Width * 3.f/4, CGRectGetMidY(self.bTeamNameL.frame) -  RateSacel(22));
        //        bNumberL.text = @"4";
        self.bNumberL.textColor = [UIColor whiteColor];
        self.bNumberL.font = SYSTEMFONT(RateSacel(31));
        self.bNumberL.textAlignment = 1;
        [_blueView addSubview:self.bNumberL];
        
        self.awayLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(RateSacel(230), RateSacel(11), RateSacel(115), RateSacel(41))] ;
        self.awayLogoView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.backImgView addSubview:self.awayLogoView] ;
        
        UITapGestureRecognizer * tapA = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectATeamDetail)] ;
        self.aNumberL.userInteractionEnabled = YES ;
        [self.aNumberL addGestureRecognizer:tapA] ;
        
        UITapGestureRecognizer * tapB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBTeamDetail)] ;
        self.bNumberL.userInteractionEnabled = YES ;
        [self.bNumberL addGestureRecognizer:tapB] ;
        
        
        [self setEventInfo] ;
        
        
    }
    return _blueView;
}
- (void)setEventInfo {
    
    if (![_matchStartTime isEqualToString:@""]) {
        self.timeLabel.text = [LJUtil timeInterverlToDateStr:_matchStartTime] ;
    }
    
    self.aTeamNameL.text = _homeNm ;
    self.bTeamNameL.text = _awayNm ;
    
    switch (_status) {
        case 0:
            self.statusLabel.text = @"比赛异常";
            break;
        case 1:
            self.statusLabel.text = @"未开赛";
            break;
        case 2:
            self.statusLabel.text = @"上半场";
            break;
        case 3:
            self.statusLabel.text = @"中场";
            break;
        case 4:
            self.statusLabel.text = @"下半场";
            break;
        case 5:
            self.statusLabel.text = @"加时赛上半场";
            break;
        case 6:
            self.statusLabel.text = @"加时赛下半场";
            break;
        case 7:
            self.statusLabel.text = @"点球决战";
            break;
        case 8:
            self.statusLabel.text = @"完场";
            break;
        case 9:
            self.statusLabel.text = @"推迟";
            break;
        case 10:
            self.statusLabel.text = @"中断";
            break;
        case 11:
            self.statusLabel.text = @"腰斩";
            break;
        case 12:
            self.statusLabel.text = @"取消";
            break;
        case 13:
            self.statusLabel.text = @"待定";
            break;
            
        default:
            break;
    }
    
    if (_status == 8) {
        
        self.aNumberL.text = _homeScore ;
        self.bNumberL.text = _awayScore ;
        self.aTeamNameL.textColor = [UIColor whiteColor] ;
        self.bTeamNameL.textColor = [UIColor whiteColor] ;
        
        self.backImgView.image = Image(@"") ;
        self.homeLogoView.image = Image(@"") ;
        self.awayLogoView.image = Image(@"") ;
        self.timeLabel.center = CGPointMake(Screen_Width/2, RateSacel(22));
        self.vsLabel.hidden = YES;
        
        self.aTeamNameL.center = CGPointMake(Screen_Width/4, RateSacel(50));
        self.bTeamNameL.center = CGPointMake(Screen_Width * 3.f/4, RateSacel(50));
        
    } else {
        self.aNumberL.text = @"" ;
        self.bNumberL.text = @"" ;
        self.vsLabel.hidden = NO;
        self.vsLabel.center = CGPointMake(Screen_Width/2, (RateSacel(50) - RateSacel(10)/2)/2);
        //        self.backImgView.image = Image(@"saishi_vs_beijing") ;
        self.aTeamNameL.textColor = [UIColor whiteColor] ;
        self.bTeamNameL.textColor = [UIColor whiteColor];
        self.timeLabel.center = CGPointMake(Screen_Width/2, RateSacel(50)) ;
        //        [self.homeLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_homeLogo]]];
        //        [self.awayLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_awayLogo]]] ;
        [self.homeLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_homeLogo]] placeholderImage:Image(@"saishi_huilogo")] ;
        [self.awayLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_awayLogo]] placeholderImage:Image(@"saishi_huilogo")] ;
        
        self.aTeamNameL.center = CGPointMake(self.homeLogoView.center.x + self.backImgView.frame.origin.x, CGRectGetMaxY(self.homeLogoView.frame) + RateSacel(10)) ;
        self.bTeamNameL.center = CGPointMake(self.awayLogoView.center.x + self.backImgView.frame.origin.x, CGRectGetMaxY(self.awayLogoView.frame) + RateSacel(10)) ;
    }
    
    self.statusLabel.frame = CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame) + RateSacel(7), Screen_Width, RateSacel(10)) ;
    
}

#pragma mark -- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFMatchInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model = nil;
        cell.scoreModel = self.basicPanelModel.score[indexPath.row];
        
    }else {
        switch (indexPath.section) {
            case 1:
                self.battleModel = self.basicPanelModel.vs.battle[indexPath.row];
                break;
            case 2:
                self.battleModel = self.basicPanelModel.homeVs.battle[indexPath.row] ;
                break;
            case 3:
                self.battleModel = self.basicPanelModel.awayVs.battle[indexPath.row] ;
                break;
                
            default:
                break;
        }
        cell.scoreModel = nil;
        cell.model = self.battleModel ;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, RateSacel(30))] ;
    headView.backgroundColor = RGBCOLOR(250, 250, 250, 1);
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, RateSacel(30))];
    view.backgroundColor = RGBCOLOR(242, 242, 242, 1);
    [headView addSubview:view] ;
    
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(RateSacel(10), 0, Screen_Width, RateSacel(30))];
    titleLable.font = SYSTEMFONT(RateSacel(11)) ;
    [view addSubview:titleLable];
    
    UILabel * results = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width/2, 0, Screen_Width/2 - RateSacel(10), RateSacel(30))];
    results.textAlignment = 2;
    //    results.text = @"1胜1平1负";
    results.font = SYSTEMFONT(RateSacel(11)) ;
    [view addSubview:results];
    
    
    switch (section) {
        case 0:
            titleLable.text = @"赛前积分排名";//春季分组-A组-赛前积分排名
            results.hidden = YES;
            break;
        case 1:
            titleLable.text = @"历史交战";
            results.hidden = NO;
            if (self.basicPanelModel.vs.battle.count) {
                results.text = [NSString stringWithFormat:@"%ld胜%ld平%ld负",
                                self.basicPanelModel.vs.tolWon,
                                self.basicPanelModel.vs.tolDrawn,
                                self.basicPanelModel.vs.tolLost] ;
            }
            break;
        case 2:
            titleLable.text = @"队A";
            results.hidden = NO;
            if (self.basicPanelModel.homeVs.battle.count) {
                results.text = [NSString stringWithFormat:@"%ld胜%ld平%ld负",
                                self.basicPanelModel.homeVs.tolWon,
                                self.basicPanelModel.homeVs.tolDrawn,
                                self.basicPanelModel.homeVs.tolLost] ;
            }
            break;
        case 3:
            if (self.basicPanelModel.awayVs.battle.count) {
                results.text = [NSString stringWithFormat:@"%ld胜%ld平%ld负",
                                self.basicPanelModel.awayVs.tolWon,
                                self.basicPanelModel.awayVs.tolDrawn,
                                self.basicPanelModel.awayVs.tolLost] ;
            }
            titleLable.text = @"队B";
            results.hidden = NO;
            break;
            
        default:
            break;
    }
    
    return headView;
}

#pragma mark - JRrefreshDelegate
- (void)refreshTableViewHeader {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager] getMatchInfoWithClassId:_model.matchId success:^(LSLJSuccessData *data, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([data.code isEqualToString:@"0"]) {
            
            self.basicPanelModel = [XFMatchInfoModel mj_objectWithKeyValues:data.data] ;
            
            if (!self.basicPanelModel.matchId) {
                [self.tableView showNoView:@"暂无数据" image:nil certer:CGPointZero x:10];
            }
            
        } else {
            [self.tableView showNoView:[NSString stringWithFormat:@"%@", msg] image:nil certer:CGPointZero x:10];
            [self showMassage:msg];
        }
        [self.tableView reloadData];
        
    } failure:^(NSString *error) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showMassage:error];
    }];
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.basicPanelModel.matchId) {
        return 4 ;
    }
    return 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.basicPanelModel.matchId) {
        switch (section) {
            case 0:
                if (self.basicPanelModel.score.count) {
                    return self.basicPanelModel.score.count ;
                }
                break;
            case 1:
                if (self.basicPanelModel.vs.battle.count) {
                    return self.basicPanelModel.vs.battle.count ;
                }
                break;
            case 2:
                if (self.basicPanelModel.homeVs.battle.count) {
                    return self.basicPanelModel.homeVs.battle.count ;
                }
                break;
            case 3:
                if (self.basicPanelModel.awayVs.battle.count) {
                    return self.basicPanelModel.awayVs.battle.count;
                }
                break;
                
            default:
                break;
        }
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 85;
    }else {
        return 115;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RateSacel(30);
}

#pragma mark - Lazy Loading
-(NSMutableArray *)dataSourrce {
    if (_dataSourrce == nil) {
        _dataSourrce = [[NSMutableArray  alloc] init];
        
    }
    return _dataSourrce;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[JJRefreshTabView alloc]  initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + RateSacel(110), Screen_Width, Screen_Height - STATUS_AND_NAVIGATION_HEIGHT - RateSacel(110)) style:UITableViewStylePlain];
        _tableView.CanRefresh = YES;
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.refreshDelegate = self;
        _tableView.mj_footer = nil;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"XFMatchInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark - 赛况
-(void)clickedSituationBtn {
    
    
    if (!self.isGetData) {
        return ;
    }
    
}


@end
