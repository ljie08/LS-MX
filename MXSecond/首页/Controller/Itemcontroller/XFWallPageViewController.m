//
//  XFWallPageViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFWallPageViewController.h"
#import "XFPhotoCollectionViewCell.h"
#import "KSPhotoBrowser.h"
@interface XFWallPageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic, strong) NSMutableArray *imageArrays;/**< 图片 */
@property (nonatomic, strong) NSMutableArray <XFNewsModel *>*dataSource;
@property (nonatomic, strong) UICollectionView *tableView;/**<  */

@end

@implementation XFWallPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshDelegate
- (void)refreshTableViewFooter {
    _page += 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager] getNewListWithClassId:55 pageIndex:_page type:1 success:^(NSArray *resultArr, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resultArr.count) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.dataSource addObjectsFromArray:resultArr];
            for (int i = 0; i < resultArr.count; i++) {
                [self.imageArrays addObject:self.dataSource[self.dataSource.count -  resultArr.count + i].titlepic];
            }
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
    _page = 2;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebManager sharedManager] getNewListWithClassId:55 pageIndex:_page type:1 success:^(NSArray *resultArr, NSString *msg) {
        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resultArr.count) {
            
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
                [self.imageArrays removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:resultArr];
            for (int i = 0; i < self.dataSource.count; i++) {
                [self.imageArrays addObject:self.dataSource[i].titlepic];
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XFPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.row].titlepic] placeholderImage:nil];
    
    return cell;
    
}




#pragma mark - tableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count?1:0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < _imageArrays.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageBg"]];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_imageArrays[i]]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
    [browser showFromViewController:self];
}

#pragma mark - Lazy Loading
- (UICollectionView *)tableView {
    if (_tableView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.itemSize = CGSizeMake(Screen_Width/3 - 2, (Screen_Width/3 - 2) * 16/9);
        
        _tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - STATUS_TABBAR_NAVIGATION_HEIGHT) collectionViewLayout:layout];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableViewHeader)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshTableViewFooter)];
        [self refreshTableViewHeader];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        [_tableView registerNib:[UINib nibWithNibName:@"XFPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_tableView reloadData];
//        [_tableView :[UINib nibWithNibName:@"XFBaseViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray <XFNewsModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
    }
    return _dataSource;
}

-(NSMutableArray *)imageArrays {
    if (_imageArrays == nil) {
        _imageArrays = [[NSMutableArray alloc] init];
    }
    return _imageArrays;
}

@end
