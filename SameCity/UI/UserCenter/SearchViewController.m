//
//  SearchViewController.m
//  samecity
//
//  Created by zengchao on 14-8-10.
//  Copyright (c) 2014年 com.stefan. All rights reserved.
//

#import "SearchViewController.h"
#import "Global.h"
#import "HomePageListCell.h"
#import "GoodsDetailViewController.h"

static NSString *searchReuseIdetify = @"SearchHomePageListCell";

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    RELEASE_SAFELY(listTableView);
    RELEASE_SAFELY(listSearchBar);
    RELEASE_SAFELY(listData);
    RELEASE_SAFELY(_items);
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
    self.title = NSLocalizedString(lab_user_search, nil);
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIImageView *sIcon = [[UIImageView alloc] initWithImage:ImageWithName(@"stefen_icon")];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:sIcon];
    self.navigationItem.rightBarButtonItem = right;
    
    RELEASE_SAFELY(sIcon);
    RELEASE_SAFELY(right);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.tabBarCtl hidesTabBar:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view addSubview:searchBar];
    _items = [[NSMutableArray alloc] init];
    
    listTableView = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:0];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    listTableView.mjdelegate = self;
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listTableView];
    
    [listTableView registerClass:[HomePageListCell class] forCellReuseIdentifier:searchReuseIdetify];
    
    listSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    listSearchBar.delegate = self;
    listSearchBar.placeholder = NSLocalizedString(hint_keyword, nil);
    [listTableView setTableHeaderView:listSearchBar];
    
    NSString *city = [Global ShareCenter].city;
    NSString *region = [Global ShareCenter].region;
    
    listData = [[HomePageData alloc] initWithCity:city andRegion:region];
    listData.delegate = self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [listSearchBar resignFirstResponder];
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
    
    HomePageListCell *cell = [tableView dequeueReusableCellWithIdentifier:searchReuseIdetify];
    
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

- (void)getIndexData
{
    if (!listData.isLoading) {
        int page = 0;
        if (isRefreshing) {
            page = 1;
        }
        else {
            if (self.items.count%PER_PAGE_SIZE != 0) {
                [listTableView endRefreshingAndReloadData];
                return;
            }
            else {
                page = (int)self.items.count/PER_PAGE_SIZE+1;
            }
        }
        
        NSString *city = [Global ShareCenter].city;
        NSString *region = [Global ShareCenter].region;
        listData.city = city;
        listData.region = region;
        [listData searchHomeDataPageNum:page andPageSize:PER_PAGE_SIZE key:listSearchBar.text];
    }
    else {
        [listTableView endRefreshingAndReloadData];
    }
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    if (isRefreshing) {
        [self.items removeAllObjects];
    }
    
    if (response && [response isKindOfClass:[NSArray class]]) {
        [self.items addObjectsFromArray:(NSArray *)response];
    }
    
    if ([(NSArray *)response count] < PER_PAGE_SIZE) {
        [listTableView endRefreshingAndReloadDataNoMore];
    }
    else {
        [listTableView endRefreshingAndReloadData];
    }
    
    if (self.items.count == 0) {
        AlertMessage(NSLocalizedString(history_NoInfo, nil));
    }
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error
{
    [listTableView endRefreshingAndReloadData];
}

- (void)MJRefreshTableViewStartRefreshing:(MJRefreshTableView *)target
{
    isRefreshing = YES;
    //    [self startLoading];
    [self performSelector:@selector(getIndexData) withObject:nil afterDelay:0.1];
}

- (void)MJRefreshTableViewDidStartLoading:(MJRefreshTableView *)target
{
    isRefreshing = NO;
    //    [self startLoading];
    [self performSelector:@selector(getIndexData) withObject:nil afterDelay:0.1];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if (![NSString isNotEmpty:listSearchBar.text]) {
        AlertMessage(@"请输入关键词");
        return;
    }
    
    [listTableView startPullDownRefreshing];
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
