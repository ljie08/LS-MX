//
//  MatchListViewController.m
//  MXSecond
//
//  Created by Libra on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "LJMatchListViewController.h"
#import "LJMatchGoalCell.h"//射手cell
#import "LJMatchAssistCell.h"//助攻cell
#import "LJMatchScoreCell.h"//积分cell
#import "LJMatchRecordCell.h"//记录cell

@interface LJMatchListViewController ()<RefreshTableViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet JJRefreshTabView *listTab;

@property (nonatomic, strong) NSMutableArray *assistArr;
@property (nonatomic, strong) NSMutableArray *goalArr;
@property (nonatomic, strong) NSMutableArray *scoreArr;
@property (nonatomic, strong) NSMutableArray *recordArr;

@end

@implementation LJMatchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //切换seg 刷新tableview显示类型
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWithIndex:) name:@"SegControl" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //切换slider的时候，默认选中上一个控制器的选中的seg
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    self.index = [[d objectForKey:@"segIndex"] integerValue];
    
    NSLog(@"0000 %ld", self.type);
    
//    if (self.index == 1) {
//        [self loadGoalData];
//    } else if (self.index == 2) {
//        [self loadScoreData];
//    } else if (self.index == 3) {
//        [self loadRecordData];
//    } else {//默认助攻榜
//        [self loadAssistData];
//    }
    
    [self loadData];
}

#pragma mark - data
- (void)loadData {
    if (self.index == 1) {
        [self loadGoalData];
    } else if (self.index == 2) {
        [self loadScoreData];
    } else if (self.index == 3) {
        [self loadRecordData];
    } else {//默认助攻榜
        [self loadAssistData];
    }
}
//- (void)loadData {
//    NSString *path = [NSString string];
//    if (self.index == 1) {
//        path = Goal_PATH;
//    } else if (self.index == 2) {
//        path = Score_PATH;
//    } else if (self.index == 3) {
//        path = Schedule_PATH;
//    } else {//默认助攻榜
//        path = Assist_PATH;
//    }
//
//    weakSelf(self);
//    [[WebManager sharedManager] getMatchListWithLeagueId:self.type path:path success:^(NSArray *assistArr, NSString *msg) {
//
//        NSLog(@"");
//    } failure:^(NSString *error) {
//        [weakSelf hideWaiting];
//        [weakSelf showMassage:error];
//    }];
//}

- (void)loadAssistData {
    [self showWaiting];
    weakSelf(self);
    [[WebManager sharedManager] getAssistListWithLeagueId:self.type seasonId:@"2017" success:^(NSArray *assistArr, NSString *msg) {
        NSLog(@"");
        [weakSelf hideWaiting];
        [weakSelf showMassage:msg];
        if (assistArr.count) {
            if (weakSelf.assistArr.count) {
                [weakSelf.assistArr removeAllObjects];
            }
            [weakSelf.assistArr addObjectsFromArray:assistArr];
            
            [weakSelf.listTab reloadData];
        }
        
    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];
    }];
}

- (void)loadGoalData {
    [self showWaiting];
    weakSelf(self);
    [[WebManager sharedManager] getGoalListWithLeagueId:self.type seasonId:@"2017" success:^(NSArray *goalArr, NSString *msg) {
        NSLog(@"");
        [weakSelf hideWaiting];
        [weakSelf showMassage:msg];
        if (goalArr.count) {
            if (weakSelf.goalArr.count) {
                [weakSelf.goalArr removeAllObjects];
            }
            [weakSelf.goalArr addObjectsFromArray:goalArr];
            
            [weakSelf.listTab reloadData];
        }
        
    } failure:^(NSString *error) {
        NSLog(@"");
    }];
}

- (void)loadScoreData {
    [self showWaiting];
    weakSelf(self);
    [[WebManager sharedManager] getScoreListWithLeagueId:self.type seasonId:@"2017" success:^(NSArray *scoreArr, NSString *msg) {
        NSLog(@"");
        [weakSelf hideWaiting];
        [weakSelf showMassage:msg];
        if (scoreArr.count) {
            if (weakSelf.scoreArr.count) {
                [weakSelf.scoreArr removeAllObjects];
            }
            [weakSelf.scoreArr addObjectsFromArray:scoreArr];
        }
        
        [weakSelf.listTab reloadData];
        
    } failure:^(NSString *error) {
        NSLog(@"");
    }];
}

- (void)loadRecordData {
    [self showWaiting];
    weakSelf(self);
    [[WebManager sharedManager] getRecordListWithLeagueId:self.type seasonId:@"2017" success:^(NSArray *recordArr, NSString *msg) {
        NSLog(@"");
        [weakSelf hideWaiting];
        [weakSelf showMassage:msg];
        if (recordArr.count) {
            if (weakSelf.recordArr.count) {
                [weakSelf.recordArr removeAllObjects];
            }
            [weakSelf.recordArr addObjectsFromArray:recordArr];
            
            [weakSelf.listTab reloadData];
        }
        
    } failure:^(NSString *error) {
        NSLog(@"");
    }];
}

#pragma mark - 通知
- (void)reloadDataWithIndex:(NSNotification *)notif {
    self.index = [notif.object integerValue];
    
    [self loadData];
//    if (self.index == 1) {
//        [self loadGoalData];
//    } else if (self.index == 2) {
//        [self loadScoreData];
//    } else if (self.index == 3) {
//        [self loadRecordData];
//    } else {//默认助攻榜
//        [self loadAssistData];
//    }

//    [self.listTab reloadData];
}

#pragma mark - refresh
- (void)refreshTableViewHeader {
    [self loadData];
}

- (void)refreshTableViewFooter {
    
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.index == 1) {
        return self.goalArr.count;
    } else if (self.index == 2) {
        return self.scoreArr.count;
    } else if (self.index == 3) {
        return self.recordArr.count;
    } else {//默认助攻榜
        return self.assistArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 3) {
        return 65;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.index == 3) {
        return CGFLOAT_MIN;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isCicle = indexPath.row < 5 ? YES : NO;
    if (self.index == 1) {//射手榜
        LJMatchGoalCell *cell = [LJMatchGoalCell myCellWithTableview:tableView];
        if (self.goalArr.count) {
            [cell setDataWithGoal:self.goalArr[indexPath.row] isCircle:isCicle];
        }
        
        return cell;
    } else if (self.index == 2) {//积分榜
        LJMatchScoreCell *cell = [LJMatchScoreCell myCellWithTableview:tableView];
        if (self.scoreArr.count) {
            [cell setDataWithScore:self.scoreArr[indexPath.row] isCircle:isCicle];
        }
        
        return cell;
    } else if (self.index == 3) {//赛程记录
        LJMatchRecordCell *cell = [LJMatchRecordCell myCellWithTableview:tableView];
        if (self.recordArr.count) {
            [cell setDataWithRecord:self.recordArr[indexPath.row]];
        }
        
        return cell;
    } else {//默认助攻榜
        LJMatchAssistCell *cell = [LJMatchAssistCell myCellWithTableview:tableView];
        if (self.assistArr.count) {
            [cell setDataWithAssist:self.assistArr[indexPath.row] isCircle:isCicle];
        }
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    if (self.index == 3) {
        return header;
    }
    
    header.backgroundColor = WhiteColor;
    CGFloat height = 40;
    if (self.index == 0) {//默认助攻榜
        LJMatchAssistCell *cell = [LJMatchAssistCell myCellWithTableview:tableView];
        cell.rankLab.hidden = NO;
        cell.rankingLab.hidden = YES;
        cell.contentView.frame = CGRectMake(0, 0, Screen_Width, height);
        [header addSubview:cell.contentView];
    } else if (self.index == 1) {
        LJMatchGoalCell *cell = [LJMatchGoalCell myCellWithTableview:tableView];
        cell.rankLab.hidden = NO;
        cell.rankingLab.hidden = YES;
        cell.contentView.frame = CGRectMake(0, 0, Screen_Width, height);
        
        [header addSubview:cell.contentView];
    } else if (self.index == 2) {
        LJMatchScoreCell *cell = [LJMatchScoreCell myCellWithTableview:tableView];
        cell.rankLab.hidden = NO;
        cell.rankingLab.hidden = YES;
        cell.contentView.frame = CGRectMake(0, 0, Screen_Width, height);
        [header addSubview:cell.contentView];
    }
    header.frame = CGRectMake(0, 0, Screen_Width, height);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.7, Screen_Width, 0.7)];
    line.backgroundColor = LightGrayColor;
    [header addSubview:line];
    
    return header;
}

#pragma mark - UI
- (void)initUIView {
    self.listTab.refreshDelegate = self;
    self.listTab.CanRefresh = YES;
    self.listTab.lastUpdateKey = NSStringFromClass([self class]);
    self.listTab.isShowMore = NO;
}

#pragma mark - lazy
- (NSMutableArray *)assistArr {
    if (!_assistArr) {
        _assistArr = [NSMutableArray array];
    }
    return _assistArr;
}

- (NSMutableArray *)goalArr {
    if (!_goalArr) {
        _goalArr = [NSMutableArray array];
    }
    return _goalArr;
}

- (NSMutableArray *)scoreArr {
    if (!_scoreArr) {
        _scoreArr = [NSMutableArray array];
    }
    return _scoreArr;
}

- (NSMutableArray *)recordArr {
    if (!_recordArr) {
        _recordArr = [NSMutableArray array];
    }
    return _recordArr;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:[NSNumber numberWithInteger:100] forKey:@"segIndex"];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
