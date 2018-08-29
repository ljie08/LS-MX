//
//  XFFastNewViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFFastNewViewController.h"
#import "XFBaseViewCell.h"
@interface XFFastNewViewController ()<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) JJRefreshTabView *tableView;/**<  */
@property (nonatomic, strong) NSMutableArray <XFNewsModel *>*dataSource;/**< 数据源 */
@property (nonatomic, strong) NSMutableArray <NSNumber *>*cellHeight;/**< 高度 */

@end

@implementation XFFastNewViewController



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
    [[WebManager sharedManager] getNewListWithPage:_page success:^(NSArray *resultArr, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resultArr.count) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.dataSource addObjectsFromArray:resultArr];
            for (NSInteger i = self.dataSource.count - resultArr.count; i < self.dataSource.count; i++) {
            
                self.dataSource[i].Description = [self.dataSource[i].Description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [self.dataSource[i].Description stringByReplacingOccurrencesOfString:@"" withString:@"\n"];
                CGSize csize = [LJUtil initWithSize:CGSizeMake(Screen_Width - 88, MAXFLOAT) string:self.dataSource[i].Description font:15];
                [self.cellHeight addObject:[NSNumber numberWithFloat:csize.height]];
            }
//            for (XFNewsModel * model in self.dataSource) {
//
//            }
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
    [[WebManager sharedManager]  getNewListWithPage:_page success:^(NSArray *resultArr, NSString *msg) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resultArr.count) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
                [self.cellHeight removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:resultArr];
            for (int i = 0; i < resultArr.count; i++) {
                
                self.dataSource[i].Description = [self.dataSource[i].Description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [self.dataSource[i].Description stringByReplacingOccurrencesOfString:@"" withString:@"\n"];
                CGSize csize = [LJUtil initWithSize:CGSizeMake(Screen_Width - 88, MAXFLOAT) string:self.dataSource[i].Description font:15];
                [self.cellHeight addObject:[NSNumber numberWithFloat:csize.height]];
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
    XFBaseViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.newsStyle = FastNewsStyle;
    cell.model = self.dataSource[indexPath.row];
    return cell;
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
    
    return 74 + self.cellHeight[indexPath.row].floatValue;
    //    else
    //        return 211.0f;
    //    return 152;
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
        [_tableView registerNib:[UINib nibWithNibName:@"XFBaseViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray <XFNewsModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        //
        //        [_dataSource addObjectsFromArray:@[@"1", @"2", @"0", @"2", @"0", @"1", @"0", @"2", @"0", @"1", @"2",@"1", @"2", @"0", @"2", @"0", @"1", @"0", @"2", @"2", @"1"]];
        
    }
    return _dataSource;
}

- (NSMutableArray <NSNumber *>*)cellHeight {
    if (_cellHeight == nil) {
        _cellHeight = [[NSMutableArray alloc] init];
    }
    return _cellHeight;
}

@end
