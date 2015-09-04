//
//  MyFavViewController.m
//  SameCity
//
//  Created by zengchao on 14-6-12.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "MyFavViewController.h"
#import "HomePageListCell.h"
#import "GoodsDetailViewController.h"

@interface MyFavViewController ()

@property (nonatomic ,retain)  HomePageItem *deleteItem;

@end

@implementation MyFavViewController

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
    RELEASE_SAFELY(myFavData);
    RELEASE_SAFELY(deleteFavData);
    RELEASE_SAFELY(_items);
    RELEASE_SAFELY(myFavTableView);
    self.deleteItem = nil;
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
    self.title = NSLocalizedString(lab_user_favorites, nil);
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [UIBarButtonItem createBarButtonItemWithTitle:@"编辑" target:self action:@selector(action:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)action:(id)sender
{
    myFavTableView.editing = !myFavTableView.editing;
    
    if (myFavTableView.editing) {
        UIBarButtonItem *right = [UIBarButtonItem createBarButtonItemWithTitle:@"取消" target:self action:@selector(action:)];
        self.navigationItem.rightBarButtonItem = right;
    }
    else {
        UIBarButtonItem *right = [UIBarButtonItem createBarButtonItemWithTitle:@"编辑" target:self action:@selector(action:)];
        self.navigationItem.rightBarButtonItem = right;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _items = [[NSMutableArray alloc] init];
    
    myFavTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:0];
    myFavTableView.dataSource = self;
    myFavTableView.delegate = self;
    myFavTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myFavTableView];
    
    myFavData = [[MyFavData alloc] init];
    myFavData.delegate = self;
    
    deleteFavData = [[MyFavData alloc] init];
    deleteFavData.delegate = self;
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startLoading];
    
    [myFavData getMyFavList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.tabBarCtl hidesTabBar:YES animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //
        self.deleteItem = self.items[indexPath.row];
        
        [self startLoading];
        [deleteFavData deleteMyFav:self.deleteItem.FavoriteID];
    }
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    [self stopLoading];
    
    if (target == myFavData) {
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:(NSArray *)response];
        [myFavTableView reloadData];
    }
    else if (target == deleteFavData) {
        
        if (response && [response isKindOfClass:[NSString class]]) {
            
            NSArray *results = [(NSString *)response componentsSeparatedByString:@"|"];
            
            if (results.count >= 2) {
                
                NSString *isLogin = results[0];
//                NSString *reason = results[1];
                
                if ([NSString isNotEmpty:isLogin] && [isLogin isEqualToString:@"true"]) {
                    
                    if (self.deleteItem) {
                        [self.items removeObject:self.deleteItem];
                        [myFavTableView reloadData];
                    }
                    
                    AlertMessage(NSLocalizedString(msg_cancel_favorite_success, nil));
                    
                    return;
                }
            }
        }
        
        AlertMessage(NSLocalizedString(msg_cancel_favorite_failed, nil));
    }
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self stopLoadingWithError:nil];
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
