//
//  PeopleManagerViewController.m
//  samecity
//
//  Created by zengchao on 15/4/12.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "PeopleManagerViewController.h"
#import "MemberItem.h"
#import "CommonTableViewCell.h"
#import "Global.h"
#import "UserLogin.h"
#import "BUIView.h"

#import "UserDetailViewController.h"

@interface PeopleManagerViewController ()

@property (nonatomic ,retain) MemberItem *bockItem;

@property (nonatomic ,retain) MemberItem *unBockItem;

@end

@implementation PeopleManagerViewController

- (void)dealloc
{
    RELEASE_SAFELY(memberTableView);
    RELEASE_SAFELY(_items);

    RELEASE_SAFELY(memberData);
    RELEASE_SAFELY(memberData2);
    self.bockItem = nil;
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
    self.title = NSLocalizedString(title_manager_users, nil);
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _items = [[NSMutableArray alloc] init];
    
    memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:0];
    memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    memberTableView.dataSource = self;
    memberTableView.delegate = self;
    [self.view addSubview:memberTableView];
    
    memberData = [[MemberData alloc] init];
    memberData.delegate = self;
    
    memberData2 = [[MemberData alloc] init];
    memberData2.delegate = self;
    
    memberData3 = [[MemberData alloc] init];
    memberData3.delegate = self;
    
    [self getData];
}

- (void)getData
{
    if (!memberData.isLoading) {
        [memberData getMemberListByCity:[Global ShareCenter].city];
    }
}

- (void)postBock:(NSString *)uid
{
    if (!memberData2.isLoading) {
        [self startLoading];
        [memberData2 bockUser:uid];
    }
}

- (void)postUnBock:(NSString *)uid
{
    if (!memberData3.isLoading) {
        [self startLoading];
        [memberData3 cancelBockUser:uid];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.tabBarCtl hidesTabBar:YES animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"HomePageCell";
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[[CommonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdetify] autorelease];
    }
    
    MemberItem *item = self.items[indexPath.row];

    if (item.MemType.intValue == 0) {
        cell.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if ([item.ID isEqualToStr:[UserLogin instanse].uid]) {
        //
        cell.detailTextLabel.text = @"当前用户";
    }
    else if (item.MemType.intValue == 0) {
        cell.detailTextLabel.text = @"已屏蔽";
    }
    else {
        cell.detailTextLabel.text = @"可操作";
    }
    
    
    cell.textLabel.text  = item.Name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberItem *item = self.items[indexPath.row];
    
    if ([item.ID isEqualToStr:[UserLogin instanse].uid]) {
        //
//        cell.detailTextLabel.text = @"当前用户";
        
        UserDetailViewController *next = [[UserDetailViewController alloc] init];
        next.userID = item.ID;
        [self.navigationController pushViewController:next animated:YES];
        [next release];
        
    }
    else if (item.MemType.intValue == 0) {
//        cell.detailTextLabel.text = @"已屏蔽";
        
        __unsafe_unretained PeopleManagerViewController *weakSelf = self;
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        [sheet addButtonWithTitle:NSLocalizedString(view_user, nil)];
        [sheet addButtonWithTitle:NSLocalizedString(unblock_user, nil)];
        [sheet addButtonWithTitle:NSLocalizedString(btnNO, nil)];
        
        sheet.destructiveButtonIndex = 1;
        sheet.cancelButtonIndex = 2;
        
        [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
            //
            if (buttonIndex == 0) {
                //
                UserDetailViewController *next = [[UserDetailViewController alloc] init];
                next.userID = item.ID;
                [weakSelf.navigationController pushViewController:next animated:YES];
                [next release];
            }
            else if (buttonIndex == 1) {
                //
                weakSelf.unBockItem = item;
                [weakSelf postUnBock:item.ID];
            }
        }];

        
    }
    else {
//        cell.detailTextLabel.text = @"可操作";
        
//        __unsafe_unretained PeopleManagerViewController *weakSelf = self;
//        
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:NSLocalizedString(btnNO, nil) destructiveButtonTitle:NSLocalizedString(view_user, nil) otherButtonTitles:NSLocalizedString(block_user, nil), nil];
//        [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
//            //
//            if (buttonIndex == 1) {
//                //
//                weakSelf.bockItem = item;
//                [weakSelf postBock:item.ID];
//            }
//        }];
        
        __unsafe_unretained PeopleManagerViewController *weakSelf = self;
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        [sheet addButtonWithTitle:NSLocalizedString(view_user, nil)];
        [sheet addButtonWithTitle:NSLocalizedString(block_user, nil)];
        [sheet addButtonWithTitle:NSLocalizedString(btnNO, nil)];
        
        sheet.destructiveButtonIndex = 1;
        sheet.cancelButtonIndex = 2;
        
        [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
            //
            if (buttonIndex == 0) {
                //
                UserDetailViewController *next = [[UserDetailViewController alloc] init];
                next.userID = item.ID;
                [weakSelf.navigationController pushViewController:next animated:YES];
                [next release];
            }
            else if (buttonIndex == 1) {
                //
                weakSelf.bockItem = item;
                [weakSelf postBock:item.ID];
            }
        }];


    }
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self stopLoading];
    
    if (target == memberData) {
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:(NSArray *)response];
        [memberTableView reloadData];
    }
    else if (target == memberData2) {
  
        NSString *reponseStr = (NSString *)response;
        
        if ([reponseStr containsString:@"true|"]) {
            self.bockItem.MemType = @"0";
            [memberTableView reloadData];
        }
    }
    else if (target == memberData3) {
        
        NSString *reponseStr = (NSString *)response;
        
        if ([reponseStr containsString:@"true|"]) {
            self.unBockItem.MemType = @"1";
            [memberTableView reloadData];
        }
    }
    
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error{
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self stopLoadingWithError:NSLocalizedString(msg_server_error, nil)];
}

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
