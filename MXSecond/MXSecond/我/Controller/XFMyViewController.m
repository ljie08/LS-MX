//
//  XFMyViewController.m
//  MXSecond
//
//  Created by FreeSnow on 2018/7/12.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "XFMyViewController.h"
#import "LoginViewController.h"
#import "MyCell.h"
#import "MyHeaderCell.h"
#import "ResetPasswdViewController.h"
#import "AccountViewController.h"
#import "XFLikeViewController.h"

@interface XFMyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTable;

@end

@implementation XFMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = MyColor;
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self.myTable reloadData];
}

#pragma mark - 缓存
- (CGFloat)getCache {
    /* 获取缓存文件夹路径 */
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    /* 获取缓存文件夹的大小 */
    CGFloat size = [self folderSizeAtPath:cachPath];
    
    return size;
}

/* 通过回调函数，获取路径下的所有文件总大小 */
- (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *child = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [child nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:filePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

/* 获取单个文件的大小 */
- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)clearCache {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    /* 确认按钮 */
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        /* 清除缓存 */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 获取缓存文件夹路径 */
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            /* 获取缓存文件夹路径下 的所有文件 */
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            
            /* 遍历所有文件， 一一删除 */
            for(NSString *str in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:str];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            
            /* 缓存清除成功后的提醒 */
            UIAlertController *success = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"成功清除%.2fM缓存", [self getCache]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:success animated:YES completion:^{
                [self.myTable reloadData];
            }];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    [alert addAction:sure];
    
    /* 取消按钮 */
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"删除");
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section) {
        return 1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 100;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        MyHeaderCell *cell = [MyHeaderCell myCellWithTableview:tableView];
        [cell setHeaderDataWithUser:[PersonDataManager instance].user];
        
        return cell;
    } else {
        MyCell *cell = [MyCell myCellWithTableview:tableView];
        NSArray *titles = [NSArray arrayWithObjects:@"账户信息", @"收藏", @"安全", @"清理缓存", @"当前版本", nil];
        NSArray *images = [NSArray arrayWithObjects:@"zhanghu", @"save", @"safe", @"qingli", @"guanyu", nil];
        [cell setCellWithTitle:titles[indexPath.row] image:images[indexPath.row] cache:[self getCache]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section || (indexPath.section && !indexPath.row)) {
        if ([[PersonDataManager instance] hasLogin]) {
            //账户信息
            AccountViewController *account = [[AccountViewController alloc] init];
            account.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:account animated:YES];
        } else {
            LoginViewController *login = [[LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    if (indexPath.section) {
        if (indexPath.row == 1) {
            XFLikeViewController *like = [[XFLikeViewController alloc] init];
            like.type = 1;
            like.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:like animated:YES];
        } else if (indexPath.row == 2) {
            if (![PersonDataManager instance].hasLogin) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ReLoginNotification object:nil];
            } else {
                ResetPasswdViewController *reset = [[ResetPasswdViewController alloc] init];
                reset.hidesBottomBarWhenPushed = YES;
                reset.isHidden = YES;
                [self.navigationController pushViewController:reset animated:YES];
            }
        } else if (indexPath.row == 3) {
            //缓存
            [self clearCache];
        } else {
            
        }
    }
}

#pragma mark - ui
- (void)initUIView {
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStyleGrouped];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.scrollEnabled = NO;
//    self.myTable.tableFooterView = [UIView new];
    [self.view addSubview:self.myTable];
}

#pragma mark - ---
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
