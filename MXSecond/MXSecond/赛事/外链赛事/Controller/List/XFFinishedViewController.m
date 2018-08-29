//
//  XFFinishedViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/17.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFFinishedViewController.h"

#import "XFMatchInfoViewController.h"
#import "XFMacthListCell.h"
#import "LoginViewController.h"
@interface XFFinishedViewController ()<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) JJRefreshTabView *tableView;/**<  */
@property (nonatomic, strong) NSMutableArray <XFMatchListModel *>*dataSource;/**< 数据源 */

@end

@implementation XFFinishedViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self refreshTableViewHeader];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshDelegate
- (void)refreshTableViewFooter {
    _page += 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager] getMatchListWithClassId:1 pageIndex:_page success:^(NSArray *resultArr, NSString *msg) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resultArr.count) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.dataSource addObjectsFromArray:[XFMatchListModel mj_objectArrayWithKeyValuesArray:resultArr]];
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
    _page = 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager]getMatchListWithClassId:1 pageIndex:_page success:^(NSArray *resultArr, NSString *msg) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resultArr.count) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:[XFMatchListModel mj_objectArrayWithKeyValuesArray:resultArr]];
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

- (void) collect:(NSInteger)index {
    if ([[PersonDataManager instance] hasLogin]) {
        self.dataSource[index].isCollect = !self.dataSource[index].isCollect;
        XFMatchListModel * model = self.dataSource[index];
        [[WebManager sharedManager] getMatchListWithClassId:model.matchId potType:self.dataSource[index].isCollect success:^(NSString *msg) {
//            [self showMassage:@"收藏成功"];
//            [self.tableView reloadData];
        } failure:^(NSString *error) {
            [self showMassage:error];
            //失败
            self.dataSource[index].isCollect = !self.dataSource[index].isCollect;
        }];
        
    }else {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark -- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFMacthListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.index = indexPath;
    cell.model = self.dataSource[indexPath.row];
    MJWeakSelf
    cell.likeAction = ^(NSIndexPath *index) {
        [weakSelf collect:index.row];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XFMatchListModel * model = self.dataSource[indexPath.row];
    XFMatchInfoViewController *detail = [[XFMatchInfoViewController alloc]init];
    detail.model = model;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
    return 75;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
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
        [self.tableView registerNib:[UINib nibWithNibName:@"XFMacthListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray <XFMatchListModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
    }
    return _dataSource;
}
@end
