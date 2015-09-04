//
//  SubRegionViewController.m
//  samecity
//
//  Created by zengchao on 15/4/12.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "SubRegionViewController.h"
#import "NewRegionViewController.h"
#import "EditTableViewCell.h"
#import "Global.h"

@interface SubRegionViewController ()<EditCellDelegate,NewRegionViewControllerDelegate>

@end

@implementation SubRegionViewController

- (void)dealloc
{
    self.delegate = nil;
    RELEASE_SAFELY(_items);
    RELEASE_SAFELY(regionTableView);
    RELEASE_SAFELY(regionData);
//    RELEASE_SAFELY(_items1);
//    RELEASE_SAFELY(_items2);
//    self.cityName = nil;
//    self.cityId = nil;
    self.region = nil;
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.title = NSLocalizedString(lab_local_sel_subarea, nil);
    
    UIBarButtonItem *right = [UIBarButtonItem createBarButtonItemWithTitle:NSLocalizedString(btn_add, nil) target:self action:@selector(gotoNewRegion:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)gotoNewRegion:(id)sender
{
    NewRegionViewController *next = [[NewRegionViewController alloc] init];
    next.delegate = self;
    next.title = NSLocalizedString(lab_local_add_area, nil);
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

- (void)newRegionViewController:(NewRegionViewController *)target add:(NSString *)newText
{
    if (!addRegionRequest.isLoading && newText) {
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startLoading];
        
        
        if ([NSString isNotEmpty:target.ID]) {
            //
            [addRegionRequest updateRegionName:newText regionID:target.ID];
        }
        else {
            //
            [addRegionRequest postCustomRegionParentRegionName:self.region.RegionName andRegionName:newText];
        }
    }
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
    
    _items = [[NSMutableArray alloc] init];

    [self resetData];
    
    regionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:0];
    regionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    regionTableView.dataSource = self;
    regionTableView.delegate = self;
    [self.view addSubview:regionTableView];
    
    //    editBottomView = [[YLEditBottomView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-64-49, kMainScreenWidth, 49)];
    //    editBottomView.delegate = self;
    //    [self.view addSubview:editBottomView];
    
    regionData = [[RegionData alloc] init];
    regionData.delegate = self;
    
    addRegionRequest = [[RegionData alloc] init];
    addRegionRequest.delegate = self;
    
 
    [self getRegionList];
}

- (void)getRegionList
{
    [regionData getCustomRegionListParentRegionName:self.region.RegionName];
}

- (void)resetData
{
    [self.items removeAllObjects];
    
    if (_region) {
        CustomRegionItem *item = [[CustomRegionItem alloc] init];
        item.RegionName = @"全部";
        item.LanguageCode = self.region.LanguageCode;
        item.ParentRegionName = self.region.ParentRegionName;
        item.ID = self.region.ID;
        item.isCustom = self.region.isCustom;
        [self.items addObject:item];
    }
}

- (CustomRegionItem *)getSelectItem:(NSInteger)row
{
    if (_region) {
        if (row == 0) {
            return nil;
        }
    }
    return self.items[row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAULT_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *regionCellIdString = @"regioncell";
    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:regionCellIdString];
    
    if (!cell) {
        cell = [[[EditTableViewCell alloc] initWithStyle:0 reuseIdentifier:regionCellIdString] autorelease];
    }
    
    cell.row = indexPath.row;
    cell.delegate = self;
    
    CustomRegionItem *item = self.items[indexPath.row];
    cell.titleLb.text = item.RegionName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomRegionItem *item = [self getSelectItem:indexPath.row];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(subRegion:select:)]) {
        [self.delegate subRegion:self select:item];
    }
}


- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    //    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    [MBProgressHUD showError:@"找不到服务器" toView:self.view];
    [self stopLoading];
    
    if (target == regionData) {

        [self resetData];
        [self.items addObjectsFromArray:(NSArray *)response];
        [regionTableView reloadData];
        //        [self checkAllSelect];
    }
    else {
//        if (_cityName) {
        [regionData getCustomRegionListParentRegionName:self.region.RegionName];
//        }
//        
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startLoading];
    }
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error
{
    [self stopLoadingWithError:nil];
    
    [regionTableView reloadData];
}

- (void)EditCellShowMenu:(EditTableViewCell *)target
{
    NSArray *cells =  [regionTableView visibleCells];
    if (cells) {
        for (EditTableViewCell *cell in cells) {
            
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

- (void)EditCellUpdate:(EditTableViewCell *)target
{
    [target _slideInContentViewFromDirection];
    
    CustomRegionItem *item = [self getSelectItem:target.row];
    
    NewRegionViewController *next = [[NewRegionViewController alloc] init];
    next.delegate = self;
    next.originalText = item.RegionName;
    next.title = NSLocalizedString(lab_main_address, nil);
    next.ID = item.ID;
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

- (void)EditCellDelete:(EditTableViewCell *)target
{
    
    [target _slideInContentViewFromDirection];
    
    CustomRegionItem *item = [self getSelectItem:target.row];
    
    if (!item.isCustom) {
        //        [MBProgressHUD showMessag:@"只有自定义的区域才可以删除" toView:self.view];
        [self showTips:NSLocalizedString(msg_on_region, nil)];
        
        return;
    }
    
    if (!addRegionRequest.isLoading) {
        
        [self startLoading];
        
        [addRegionRequest deleteRegionName:item.ID];
    }
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
