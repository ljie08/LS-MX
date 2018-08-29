//
//  AccountViewController.m
//  MXFootball
//
//  Created by Libra on 2018/7/5.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountCell.h"
#import "InputViewController.h"

@interface AccountViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet JJRefreshTabView *accountTable;
@property (nonatomic, strong) User *user;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.user = [PersonDataManager instance].user;
    
    if (self.user.userId) {
        [self.accountTable reloadData];
    } else {
        [self goBack];
    }
}

#pragma mark - 修改性别
- (void)editUserSex {
    NSString *timeStr = [LJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(self.user.userId) forKey:@"userId"];
    [parameters setObject:self.user.sex forKey:@"sex"];
    [parameters setObject:timeStr forKey:@"time"];
    [parameters setObject:self.user.token forKey:@"token"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    weakSelf(self);
//    [self showWaiting];
    [[WebManager sharedManager] LSEditSexWithParameters:allParams success:^(LSLJSuccessData *data) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:data.msg];
        if ([data.code isEqualToString:@"0"]) {
            weakSelf.user.sex = [data.data objectForKey:@"sex"];
            [PersonDataManager instance].user = weakSelf.user;
        }
        [weakSelf.accountTable reloadData];

    } failure:^(NSString *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error];

    }];
}

#pragma mark - 修改头像
- (void)editHeaderPicWithPic:(UIImage *)pic {
//    NSData *imageData = UIImageJPEGRepresentation(pic, 0.6);
//    NSString *dataStr = [imageData base64EncodedStringWithOptions:0];//使用base64上传所需
    
    NSString *timeStr = [LJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(self.user.userId) forKey:@"userId"];
    [parameters setObject:timeStr forKey:@"time"];
    [parameters setObject:self.user.token forKey:@"token"];
    
    NSMutableDictionary *allParams = [LJUtil sortedDictionary:parameters];
    
    weakSelf(self);
//    [self showWaiting];
    
    [[WebManager sharedManager] uploadModifyUHeaderImages:@[pic] urlString:LSWodemModifyUserHeadPic_PATH params:allParams success:^(id responseObject) {
        [weakSelf hideWaiting];

        NSDictionary *dic = (NSDictionary *)responseObject;
        LSLJSuccessData *result = [LSLJSuccessData mj_objectWithKeyValues:dic];
        [weakSelf showMassage:result.msg];
        
        if (![result.code integerValue]) {
            NSString *header = [result.data objectForKey:@"headerPic"];
            weakSelf.user.headerPic = header;
            [PersonDataManager instance].user = weakSelf.user;
        }
        [weakSelf.accountTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:error.localizedDescription];
    }];    
}

#pragma mark - logout
- (void)logOut {
    [[PersonDataManager instance] logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:ReLoginNotification object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

//跳转输入VC
- (void)gotoInputVCWithTitle:(NSString *)title {
    InputViewController *input = [[InputViewController alloc] init];
    input.navTitle = title;
    [self.navigationController pushViewController:input animated:YES];
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountCell *cell = [AccountCell myCellWithTableview:tableView];
    NSArray *titles = [NSArray arrayWithObjects:@"头像", @"昵称", @"性别", @"签名", nil];
    NSArray *contents = [NSArray arrayWithObjects:self.user.headerPic, self.user.username, self.user.sex, self.user.userSign, nil];
    if (self.user.userId) {
        [cell setCellWithTitle:titles[indexPath.row] content:contents[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            NSArray *titles = [NSArray arrayWithObjects:@"拍照", @"相册", nil];
            [self showActionSheetWithTitles:titles type:0];
        }
            
            break;
        case 1:
            [self gotoInputVCWithTitle:@"修改昵称"];
            
            break;
        case 2: {
            NSArray *titles = [NSArray arrayWithObjects:@"男", @"女", nil];
            [self showActionSheetWithTitles:titles type:1];
        }
            
            break;
        case 3:
            [self gotoInputVCWithTitle:@"修改签名"];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {//取消图片选择
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {//选择图片
    UIImage *image = info[UIImagePickerControllerEditedImage];//获取图片
    
    [self editHeaderPicWithPic:image];
      
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ui
- (void)initUIView {
    [self initTitleViewWithTitle:@"个人信息"];
    [self setBackButton:YES];
    
    UIButton *logOut = [UIButton buttonWithType:UIButtonTypeCustom];
    logOut.frame = CGRectMake(20, 10, Screen_Width-40, 50);
    logOut.backgroundColor = MyColor;
    [logOut setTitle:@"退出" forState:UIControlStateNormal];
    [logOut addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    logOut.layer.cornerRadius = 5;
    logOut.layer.masksToBounds = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 60)];
    [view addSubview:logOut];
    self.accountTable.tableFooterView = view;
}

/**
 显示选项框

 @param titles 选项
 @param type 类型 0为头像 1为性别
 */
- (void)showActionSheetWithTitles:(NSArray *)titles type:(NSInteger)type {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:titles[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (type) {
            self.user.sex = titles[0];
            [self editUserSex];
        } else {
            //选择图片
            [self showImagePickerWithIndex:0];
        }
        
        [PersonDataManager instance].user = self.user;
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:titles[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (type) {
            self.user.sex = titles[1];
            [self editUserSex];
        } else {
            [self showImagePickerWithIndex:1];
        }
        
        [PersonDataManager instance].user = self.user;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImagePickerWithIndex:(NSInteger)index {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (index == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            [self showMassage:@"设备不支持拍照"];
            return;
        }
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            return;
        }
    }
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - lazy
- (User *)user {
    if (!_user) {
        _user = [[User alloc] init];
    }
    return _user;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
