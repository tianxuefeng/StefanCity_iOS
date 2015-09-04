//
//  PublishManagerViewController.m
//  samecity
//
//  Created by zengchao on 15/4/12.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "PublishManagerViewController.h"
#import "EditHomePageListCell.h"
#import "GoodsDetailViewController.h"
#import "Global.h"

@interface PublishManagerViewController ()<EditCellDelegate>

@property (nonatomic ,retain) HomePageItem *deleteItem;

@end

@implementation PublishManagerViewController

- (void)dealloc
{
    RELEASE_SAFELY(myPublishedData);
    RELEASE_SAFELY(deletePublishedData);
    RELEASE_SAFELY(_items);
    RELEASE_SAFELY(myPublishedTableView);
    
    self.deleteItem = nil;
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
    self.title = NSLocalizedString(title_manager_posts, nil);
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _items = [[NSMutableArray alloc] init];
    
    myPublishedTableView = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:0];
    myPublishedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myPublishedTableView.dataSource = self;
    myPublishedTableView.delegate = self;
    myPublishedTableView.mjdelegate = self;
    [self.view addSubview:myPublishedTableView];
    
    myPublishedData = [[HomePageData alloc] init];
    myPublishedData.delegate = self;
    
    deletePublishedData = [[HomePageData alloc] init];
    deletePublishedData.delegate = self;
    
    [myPublishedTableView startPullDownRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.tabBarCtl hidesTabBar:YES animated:YES];
}

- (void)loadData
{
    if (!myPublishedData.isLoading) {
        int page = 0;
        if (isRefreshing) {
            page = 1;
        }
        else {
            if (self.items.count%PER_PAGE_SIZE != 0) {
                [myPublishedTableView endRefreshingAndReloadData];
                return;
            }
            else {
                page = (int)self.items.count/PER_PAGE_SIZE+1;
            }
        }
        
        NSString *city = [Global ShareCenter].city;
        NSString *region = [Global ShareCenter].region;
        NSString *subregion = [Global ShareCenter].subregion;
        myPublishedData.city = city;
        myPublishedData.region = region;
        myPublishedData.SubRegion = subregion;
        [myPublishedData searchHomeDataPageNum:page andPageSize:PER_PAGE_SIZE key:@""];
    }
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
    EditHomePageListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[[EditHomePageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify] autorelease];
    }
    
    cell.delegate = self;
    
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

- (void)EditCellShowMenu:(EditHomePageListCell *)target
{
    NSArray *cells =  [myPublishedTableView visibleCells];
    if (cells) {
        for (EditHomePageListCell *cell in cells) {
            
            if (cell == target) {
                continue;
            }
            if (cell.currentStatus != kFeedStatusNormal) {
                [cell _slideInContentViewFromDirection];
                break;
            }
        }
    }
}


- (void)EditCellDelete:(EditHomePageListCell *)target
{
    
    [target _slideInContentViewFromDirection];
    
    HomePageItem *item = self.items[target.row];
    
    self.deleteItem = item;
    
    if (!deletePublishedData.isLoading) {
        
        [self startLoading];
        
        [deletePublishedData deleteGoodsId:item.ID];
    }
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self stopLoading];
    
    if (target == myPublishedData) {
        //
        if (isRefreshing) {
            [self.items removeAllObjects];
        }
        
        [self.items addObjectsFromArray:(NSArray *)response];
        [myPublishedTableView endRefreshingAndReloadData];
    }
    else {
        //
        NSString *responseStr = (NSString *)response;
        if ([responseStr containsString:@"true|"]) {
            
            if (_deleteItem) {
                [self.items removeObject:self.deleteItem];
                [myPublishedTableView reloadData];
            }
            
            [myPublishedTableView startPullDownRefreshing];
        }
    }
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error{
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self stopLoadingWithError:NSLocalizedString(msg_server_error, nil)];
    
    if (target == myPublishedData) {
         [myPublishedTableView endRefreshingAndReloadData];
    }
   
}

- (void)MJRefreshTableViewStartRefreshing:(MJRefreshTableView *)target
{
    isRefreshing = YES;
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}

- (void)MJRefreshTableViewDidStartLoading:(MJRefreshTableView *)target
{
    isRefreshing = NO;
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
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
