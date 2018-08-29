//
//  XFPhotosViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFPhotosViewController.h"
#import <KSPhotoBrowser/KSPhotoBrowser.h>
#import "XFBaseViewCell.h"
//
//  XFFastNewViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFPhotosViewController.h"
#import "XFBaseViewCell.h"
@interface XFPhotosViewController ()<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) JJRefreshTabView *tableView;/**<  */
@property (nonatomic, strong) NSMutableArray <XFNewsModel *>*dataSource;/**< 数据源 */

@end

@implementation XFPhotosViewController



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
    [[WebManager sharedManager] getNewListWithClassId:54 pageIndex:_page type:1 success:^(NSArray *resultArr, NSString *msg) {
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
    _page = 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager] getNewListWithClassId:54 pageIndex:_page type:1 success:^(NSArray *resultArr, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
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
    }];}
#pragma mark -- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFBaseViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.index = indexPath;
    cell.newsStyle = PhotoNewsStyle;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *items = @[].mutableCopy;
    NSArray * _imageArrays = self.dataSource[indexPath.row].morepic;
    for (int i = 0; i < _imageArrays.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageBg"]];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_imageArrays[i]]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
    [browser showFromViewController:self];
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
    
    return Screen_Width* 9/16;
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
@end

