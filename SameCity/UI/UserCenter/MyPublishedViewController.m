//
//  MyPublishedViewController.m
//  SameCity
//
//  Created by zengchao on 14-6-29.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "MyPublishedViewController.h"
#import "HomePageListCell.h"
#import "GoodsDetailViewController.h"

@interface MyPublishedViewController ()

@end

@implementation MyPublishedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFELY(myPublishedData);
    RELEASE_SAFELY(_items);
    RELEASE_SAFELY(myPublishedTableView);
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
    self.title = NSLocalizedString(lab_user_send, nil);
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _items = [[NSMutableArray alloc] init];
    
    myPublishedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:0];
    myPublishedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myPublishedTableView.dataSource = self;
    myPublishedTableView.delegate = self;
    [self.view addSubview:myPublishedTableView];
    
    myPublishedData = [[HomePageData alloc] init];
    myPublishedData.delegate = self;
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startLoading];
    
    [myPublishedData getMyPublishedItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.tabBarCtl hidesTabBar:YES animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"HomePageCell";
    HomePageListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[[HomePageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify] autorelease];
    }
    
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    cell.item = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageItem *item = self.items[indexPath.row];
    
    GoodsDetailViewController *next = [[GoodsDetailViewController alloc] init];
    next.item = item;
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self stopLoading];
    
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:(NSArray *)response];
    [myPublishedTableView reloadData];
    
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self stopLoadingWithError:NSLocalizedString(msg_server_error, nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
