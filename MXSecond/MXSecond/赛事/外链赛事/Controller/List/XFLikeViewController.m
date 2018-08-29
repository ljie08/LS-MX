//
//  XFLikeViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/17.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFLikeViewController.h"
#import "XFMatchInfoViewController.h"
#import "XFMacthListCell.h"
#import "LoginViewController.h"
@interface XFLikeViewController ()<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) JJRefreshTabView *tableView;/**<  */
@property (nonatomic, strong) NSMutableArray *sectionsArray;/**< 组*/
@property (nonatomic, strong) NSMutableArray <NSMutableArray *>*dataSource;/**< 数据源 */

@end

@implementation XFLikeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == 1) {
        [self setBackButton:YES];
        self.title = @"收藏";
    }
    [self.view addSubview:self.tableView];
    [self refreshTableViewHeader];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshDelegate
//- (void)refreshTableViewFooter {
//    _page += 1;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[WebManager sharedManager] getMatchListWithClassId:3 pageIndex:_page success:^(NSArray *resultArr, NSString *msg) {
//
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (resultArr.count) {
//            if (self.tableView.mj_footer.isRefreshing) {
//                [self.tableView.mj_footer endRefreshing];
//            }
//
//            for (int i = 0; i < resultArr.count; i++) {
//                [self.sectionsArray addObject:resultArr[i][@"groupType"]];
//                [self.dataSource addObject:[XFMatchListModel mj_objectArrayWithKeyValuesArray:resultArr[i][@"match"]]];
//            }
//        }else {
//            _page -= 1;
//            if (self.tableView.mj_footer.isRefreshing) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
//        [self.tableView reloadData];
//
//    } failure:^(NSString *error) {
//        _page -= 1;
//        if (self.tableView.mj_footer.isRefreshing) {
//            [self.tableView.mj_footer endRefreshing];
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//}
- (void)refreshTableViewHeader {
    _page = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager]getMatchListWithClassId:3 pageIndex:_page success:^(NSArray *resultArr, NSString *msg) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.dataSource.count) {
            [self.dataSource removeAllObjects];
            [self.sectionsArray removeAllObjects];
        }
        if (resultArr.count) {
            
            for (int i = 0; i < resultArr.count; i++) {
                [self.sectionsArray addObject:resultArr[i][@"groupType"]];
                [self.dataSource addObject:[XFMatchListModel mj_objectArrayWithKeyValuesArray:resultArr[i][@"match"]]];
            }
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
    XFMacthListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.index = indexPath;
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    MJWeakSelf
    cell.likeAction = ^(NSIndexPath *index) {
        [weakSelf collect:index];
    };
    return cell;
}

- (void) collect:(NSIndexPath *)index {
    if ([[PersonDataManager instance] hasLogin]) {
         XFMatchListModel * model = self.dataSource[index.section][index.row];
        model.isCollect = !model.isCollect;

        [[WebManager sharedManager] getMatchListWithClassId:model.matchId potType:model.isCollect success:^(NSString *msg) {
//            [self showMassage:@"收藏成功"];
            [self.tableView reloadData];
        } failure:^(NSString *error) {
            [self showMassage:error];
            //失败
            model.isCollect = !model.isCollect;
        }];
        
    }else {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataSource.count) {
        return [UIView new];
    }else {
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.tableView.frame.size.height)];
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.sectionsArray.count) {
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.tableView.frame.size.height)];
        label.text = self.sectionsArray[section];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = kColorWithRGBF(0x999999);
        return label;
    }else {
        return [UIView new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XFMatchListModel * model = self.dataSource[indexPath.section][indexPath.row];
    XFMatchInfoViewController *detail = [[XFMatchInfoViewController alloc]init];
    detail.model = model;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sectionsArray.count) {
        return self.sectionsArray.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sectionsArray.count) {
        return self.dataSource[section].count;
    }else
        return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;

}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.sectionsArray.count) {
        return 1;
    }
    return self.tableView.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.sectionsArray.count) {
        return 44;
    }else{
        return 1;
    }
}

#pragma mark - Lazy Loading
- (JJRefreshTabView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[JJRefreshTabView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, _type?Screen_Height - STATUS_AND_NAVIGATION_HEIGHT:Screen_Height - STATUS_TABBAR_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshDelegate = self;
        _tableView.CanRefresh = YES;
        _tableView.mj_footer = nil;
        _tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        [self.tableView registerNib:[UINib nibWithNibName:@"XFMacthListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray <NSMutableArray *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
    }
    return _dataSource;
}
- (NSMutableArray *)sectionsArray {
    if (_sectionsArray == nil) {
        _sectionsArray = [[NSMutableArray alloc] init];
    }
    return _sectionsArray;
}

@end
