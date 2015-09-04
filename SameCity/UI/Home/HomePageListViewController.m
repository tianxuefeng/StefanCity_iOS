//
//  HomePageListViewController.m
//  SameCity
//
//  Created by zengchao on 14-6-28.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "HomePageListViewController.h"
#import "GoodsDetailViewController.h"
#import "Global.h"
#import "PublishViewController.h"
#import "HomePageListPopView.h"

static NSString *reuseIdetify = @"HomePageListCell";

@interface HomePageListViewController ()<PublishViewControllerDelegate,HomePageListPopViewDelegate>
{
    HomePageListPopView *popView;
    HomePageListPopView *popView2;
}
@end

@implementation HomePageListViewController

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
    RELEASE_SAFELY(listData);
    RELEASE_SAFELY(_items);
    RELEASE_SAFELY(indexTableView);
    
    RELEASE_SAFELY(popView);
    RELEASE_SAFELY(arrows);
    RELEASE_SAFELY(typeLabel);
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _items = [[NSMutableArray alloc] init];
    
    indexTableView = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-64-38-40) style:0];
    indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    indexTableView.dataSource = self;
    indexTableView.delegate = self;
    indexTableView.mjdelegate = self;
    [self.view addSubview:indexTableView];
    
    [indexTableView registerClass:[HomePageListCell class] forCellReuseIdentifier:reuseIdetify];
    
    [self setupHeadView];
    
    addButton = [CommonButton buttonWithType:UIButtonTypeCustom];
    addButton.tag = 100;
    //    myfavBtn.backgroundColor = COLOR_THEME;
    [addButton setTitle:NSLocalizedString(lab_local_add_good, nil) forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[[UIImage imageWithColor:COLOR_THEME] adjustSize] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[[UIImage imageWithColor:COLOR_THEME] adjustSize] forState:UIControlStateHighlighted];
    addButton.frame = CGRectMake((kMainScreenWidth-120)*0.5, 100, 120, 42);
    [indexTableView addSubview:addButton];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    addButton.layer.borderColor = UIColorFromRGB(0xbf2b41).CGColor;
    addButton.layer.borderWidth = 0.5;
    addButton.hidden = YES;
    
    NSString *city = [Global ShareCenter].city;
    NSString *region = [Global ShareCenter].region;
    
    listData = [[HomePageData alloc] initWithCity:city andRegion:region];
    listData.delegate = self;
    if (_cateItem) {
        listData.parentID = self.cateItem.ParentID;
        listData.categoryID = self.cateItem.ID;
    }
}

- (void)setupHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIImageView *headline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, kMainScreenWidth, 1)];
//    headline.backgroundColor = [UIColor redColor];
    headline.image = ImageWithName(@"line_normal");
    [headView addSubview:headline];
    RELEASE_SAFELY(headline);
    

    
    if (_cateItem.type && _cateItem.type.intValue != 1) {
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth*0.5, 0, kMainScreenWidth*0.5-40, 40)];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.font = [UIFont boldSystemFontOfSize:16];
        typeLabel.backgroundColor = [UIColor clearColor];
        [headView addSubview:typeLabel];
        typeLabel.text = NSLocalizedString(lab_send_buyers, @"");
        
        arrows = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-50, 0, 40, 40)];
        arrows.contentMode = UIViewContentModeCenter;
        arrows.image = ImageWithName(@"arrow_down");
        [headView addSubview:arrows];
        
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(kMainScreenWidth*0.5, 0, kMainScreenWidth*0.5, 40);
        [headView addSubview:typeBtn];
        [typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth*0.5-40, 40)];
        areaLabel.textAlignment = NSTextAlignmentCenter;
        areaLabel.font = [UIFont boldSystemFontOfSize:16];
        areaLabel.backgroundColor = [UIColor clearColor];
        [headView addSubview:areaLabel];
        areaLabel.text = NSLocalizedString(lab_main_address, @"");
        
        arrows2 = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth*0.5-50, 0, 40, 40)];
        arrows2.contentMode = UIViewContentModeCenter;
        arrows2.image = ImageWithName(@"arrow_down");
        [headView addSubview:arrows2];
        
        UIButton *typeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn2.frame = CGRectMake(0, 0, kMainScreenWidth*0.5, 40);
        [headView addSubview:typeBtn2];
        [typeBtn2 addTarget:self action:@selector(regionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *vLine = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth*0.5, 0, 1, 40)];
        vLine.backgroundColor = COLOR_BG;
        [headView addSubview:vLine];

    }
    else {
        areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kMainScreenWidth-45, 40)];
        areaLabel.textAlignment = NSTextAlignmentCenter;
        areaLabel.font = [UIFont boldSystemFontOfSize:16];
        areaLabel.backgroundColor = [UIColor clearColor];
        [headView addSubview:areaLabel];
        areaLabel.text = NSLocalizedString(lab_main_address, @"");
        
        arrows2 = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-50, 0, 40, 40)];
        arrows2.contentMode = UIViewContentModeCenter;
        arrows2.image = ImageWithName(@"arrow_down");
        [headView addSubview:arrows2];
        
        UIButton *typeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn2.frame = CGRectMake(0, 0, kMainScreenWidth, 40);
        [headView addSubview:typeBtn2];
        [typeBtn2 addTarget:self action:@selector(regionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    RELEASE_SAFELY(headView);
    
    popView = [[HomePageListPopView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(indexTableView.frame), CGRectGetWidth(indexTableView.frame), CGRectGetHeight(indexTableView.frame))];
    popView.delegate = self;
    popView.popType = 1;
    [self.view addSubview:popView];
    
    popView2 = [[HomePageListPopView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(indexTableView.frame), CGRectGetWidth(indexTableView.frame), CGRectGetHeight(indexTableView.frame))];
    popView2.delegate = self;
    popView2.popType = 0;
    [self.view addSubview:popView2];
    
    [popView setupUI];
    [popView2 setupUI];
}

- (void)regionBtnClick:(id)sender
{
    if (popView2.isPop) {
        [popView2 hide];
    }
    
    if (popView.isPop) {
        [popView hide];
    }
    else {
        [popView show];
    }
}

- (void)typeBtnClick:(id)sender
{
    if (popView.isPop) {
        [popView hide];
    }
    
    if (popView2.isPop) {
        [popView2 hide];
    }
    else {
        [popView2 show];
    }
}

- (void)addButtonClick:(id)sender
{
    PublishViewController *next = [[PublishViewController alloc] initWithNibName:@"PublishViewController" bundle:nil];
    next.delegate = self;
    next.selectCate = self.cateItem;
    next.fromPush = YES;
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

- (void)publishedSuccceed:(PublishViewController *)target
{
    if (_cateItem && [Global ShareCenter].publishedID) {
        if ([self.cateItem.ID isEqualToString:[Global ShareCenter].publishedID]) {
            //
            isRefreshing = YES;
            [indexTableView startPullDownRefreshing];
            [Global ShareCenter].publishedID = nil;
        }
    }
}

- (void)viewDidLoaded
{
    if (self.items.count == 0) {
        isRefreshing = YES;
        [indexTableView startPullDownRefreshing];
    }
    else {
        if ([Global ShareCenter].mustRefresh) {
            isRefreshing = YES;
            [indexTableView startPullDownRefreshing];
        }
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
    
    HomePageListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    
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
                [indexTableView endRefreshingAndReloadData];
                return;
            }
            else {
                page = (int)self.items.count/PER_PAGE_SIZE+1;
            }
        }
        
        NSString *city = [Global ShareCenter].city;
        NSString *region = [Global ShareCenter].region;
        NSString *subregion = [Global ShareCenter].subregion;
        listData.city = city;
        listData.region = region;
        listData.SubRegion = subregion;
        [listData getHomeDataPageNum:page andPageSize:PER_PAGE_SIZE];
    }
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    if (target.tag == HOME_DATA_TAG) {
        if (isRefreshing) {
            [self.items removeAllObjects];
        }
        [self.items addObjectsFromArray:(NSArray *)response];
        
        if ([(NSArray *)response count] < PER_PAGE_SIZE) {
            [indexTableView endRefreshingAndReloadDataNoMore];
        }
        else {
            [indexTableView endRefreshingAndReloadData];
        }
        
        if (self.items.count == 0) {
            addButton.hidden = NO;
        }
        else {
            addButton.hidden = YES;
            [Global ShareCenter].mustRefresh = NO;
        }
    }
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error
{
    if (target.tag == HOME_DATA_TAG) {
        [indexTableView endRefreshingAndReloadData];
    }
    
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

- (void)homePagePopViewShow:(HomePageListPopView *)target
{
    if (target == popView) {
        [UIView animateWithDuration:0.1 animations:^{
            //
            arrows2.image = ImageWithName(@"arrow_up");
        }];
    }
    else {
        [UIView animateWithDuration:0.1 animations:^{
            //
            arrows.image = ImageWithName(@"arrow_up");
        }];
    }
}

- (void)homePagePopViewHide:(HomePageListPopView *)target
{
    if (target == popView) {
        [UIView animateWithDuration:0.1 animations:^{
            //
            arrows2.image = ImageWithName(@"arrow_down");
        }];
    }
    else {
        [UIView animateWithDuration:0.1 animations:^{
            //
            arrows.image = ImageWithName(@"arrow_down");
        }];
    }
}

- (void)homePagePopViewDidSelect:(HomePageListPopView *)target
{
    if (target == popView2) {
        
        if (target.isBuy) {
            typeLabel.text = NSLocalizedString(lab_send_buyers, @"");
            
            if (![listData.type isEqualToString:@"1"]) {
                listData.type = @"1";
                [indexTableView startPullDownRefreshing];
            }
        }
        else {
            typeLabel.text = NSLocalizedString(lab_send_seller, @"");
            
            if (![listData.type isEqualToString:@"0"]) {
                listData.type = @"0";
                [indexTableView startPullDownRefreshing];
            }
        }
    
    }
    else {
        listData.region = target.regionId;
        listData.SubRegion = target.subRegionId;
        [indexTableView startPullDownRefreshing];
    }
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
