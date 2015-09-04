//
//  HomePageListPopView.m
//  samecity
//
//  Created by zengchao on 15/2/2.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "HomePageListPopView.h"
#import "CommonTableViewCell.h"

#import "Global.h"
#import "AppDelegate.h"

@interface HomePageListPopView ()

@property (nonatomic ,strong) CustomRegionItem *region;

@end

@implementation HomePageListPopView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        _items = [[NSMutableArray alloc] init];
        _subItems = [[NSMutableArray alloc] init];
        
        _items1 = [[NSMutableArray alloc] init];
        _items2 = [[NSMutableArray alloc] init];
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:backgroundView];
        
//        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        bgBtn.frame = CGRectMake(0, 100, kMainScreenWidth, frame.size.height-100);
//        [self addSubview:bgBtn];
//        [bgBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        sTableView = [[UITableView alloc] initWithFrame:CGRectZero style:0];
//        sTableView.scrollEnabled = NO;
        sTableView.dataSource = self;
        sTableView.delegate = self;
        sTableView.backgroundColor = [UIColor clearColor];
        sTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:sTableView];
        
        sTableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:0];
        //        sTableView.scrollEnabled = NO;
        sTableView2.dataSource = self;
        sTableView2.delegate = self;
        sTableView2.backgroundColor = [UIColor clearColor];
        sTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:sTableView2];

        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64);
        sTableView.backgroundView = bgBtn;
        [bgBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *bgBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn2.frame = CGRectMake(0, 0, kMainScreenWidth*0.5, kMainScreenHeight-64);
        sTableView2.backgroundView = bgBtn2;
        [bgBtn2 addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.hidden = YES;
        
        regionData = [[RegionData alloc] init];
        regionData.delegate = self;
        
        regionData2 = [[RegionData alloc] init];
        regionData2.delegate = self;
        
        subRegionData = [[RegionData alloc] init];
        subRegionData.delegate = self;
    
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFELY(sTableView);
    RELEASE_SAFELY(regionData);
    RELEASE_SAFELY(regionData2);
    RELEASE_SAFELY(subRegionData);
    RELEASE_SAFELY(backgroundView);
    
    self.items1 = nil;
    self.items2 = nil;
    self.items = nil;
    self.cityId = nil;
    self.cityName = nil;
    self.delegate = nil;
    self.subItems = nil;
    
    [super dealloc];
}

- (void)setupUI
{
    if (self.popType == 0) {
        
        sTableView.frame = CGRectMake(0, 0, kMainScreenWidth, CGRectGetHeight(backgroundView.frame));
        
        return;
    }
    else {
        sTableView.frame = CGRectMake(0, 0, kMainScreenWidth*0.5, CGRectGetHeight(backgroundView.frame));
        sTableView2.frame = CGRectMake(kMainScreenWidth*0.5, 0, kMainScreenWidth*0.5, CGRectGetHeight(backgroundView.frame));
    }
    
    if (!_cityName) {
        NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_CITY];
        self.cityName = cityName;
    }
    
    if (_cityName) {
        [regionData getCustomRegionListParentRegionName:self.cityName];
    }
    
    if (_cityName && !_cityId) {
        self.cityId = [[Global ShareCenter] getCityID:_cityName];
    }
    
    NSLog(@"city...id...%@",self.cityId);
    
    if (_cityId) {
        [regionData2 postRegionCode:self.cityId];
    }
}

//- (CGFloat)returnTableHeight
//{
////    if (self.popType == 0) {
////        return 100.0;
////    }
////    else {
////        return kMainScreenHeight-64-100;
////    }
//    return kMainScreenHeight-64-100;
//}

- (void)show
{
    if (self.isPop) {
        return;
    }
    self.isPop = YES;
    self.hidden = NO;
    
    [UIView animateWithDuration:0.05 animations:^{
        //
        backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(backgroundView.frame),  CGRectGetHeight(backgroundView.frame));
        backgroundView.alpha = 1;
        
    }];

    if (_delegate && [_delegate respondsToSelector:@selector(homePagePopViewShow:)]) {
        [self.delegate homePagePopViewShow:self];
    }
}

- (void)hide
{
    if (!self.isPop) {
        return;
    }
    
    self.isPop = NO;
    
    [UIView animateWithDuration:0.05 animations:^{
        //
        backgroundView.frame = CGRectMake(0, - CGRectGetHeight(backgroundView.frame), CGRectGetWidth(backgroundView.frame),  CGRectGetHeight(backgroundView.frame));
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        //
        self.hidden = YES;
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(homePagePopViewHide:)]) {
        [self.delegate homePagePopViewHide:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == sTableView) {
        if (self.popType == 0) {
            return 2;
        }
        return self.items.count;
    }
    else {
        if (self.popType == 0) {
            return 0;
        }
        return self.subItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    CommonTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[CommonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = COLOR_TITLE;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (tableView == sTableView) {
        if (self.popType == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(lab_send_buyers, @"");
            }
            else {
                cell.textLabel.text = NSLocalizedString(lab_send_seller, @"");
            }
        }
        else {
            CustomRegionItem *item = self.items[indexPath.row];
            
            cell.textLabel.text = item.RegionName;
        }
    }
    else {
        CustomRegionItem *item = self.subItems[indexPath.row];
        cell.textLabel.text = item.RegionName;
    }

    cell.textLabel.backgroundColor = [UIColor clearColor];
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    if (tableView == sTableView) {
        //...
        if (self.popType == 0) {
            //...
            if (indexPath.row == 0) {
                self.isBuy = YES;
            }
            else {
                self.isBuy = NO;
            }
            
            //....
            [self completeBtnClick:nil];
        }
        else {
            if (self.items.count > 0) {
                self.region = self.items[indexPath.row];
                [self getRegionList];
            }
        }
  
    }
    else {
        if (_region) {
            
            self.regionId = self.region.ID;
            
            CustomRegionItem *subItem = self.subItems[indexPath.row];
            
            self.subRegionId = subItem.ID;
            self.subRegionName = subItem.RegionName;
            
            //...
            [self completeBtnClick:nil];
        }
    }
}

- (void)completeBtnClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homePagePopViewDidSelect:)]) {
        [self.delegate homePagePopViewDidSelect:self];
    }
    
    [self hide];
}

- (void)cancelBtnClick:(id)sender
{
    [self hide];
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    if (target == regionData) {
        
        [self.items removeAllObjects];
        [self.items1 removeAllObjects];
        [self.items1 addObjectsFromArray:(NSArray *)response];
        [self.items addObjectsFromArray:self.items1];
        [self.items addObjectsFromArray:self.items2];
        [sTableView reloadData];
        
        //        [self checkAllSelect];
        if (self.items.count > 0) {
            
            [sTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
            
            self.region = self.items[0];
            [self getRegionList];
        }
    }
    else if (target == regionData2) {
        
        [self.items removeAllObjects];
        [self.items2 removeAllObjects];
        [self.items2 addObjectsFromArray:(NSArray *)response];
        [self.items addObjectsFromArray:self.items1];
        [self.items addObjectsFromArray:self.items2];
        [sTableView reloadData];
        
        if (self.items.count > 0) {
            
            [sTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
            
            self.region = self.items[0];
            [self getRegionList];
        }
    }
    else if (target == subRegionData){
        [self resetData];
        [self.subItems addObjectsFromArray:(NSArray *)response];
        [sTableView2 reloadData];
    }
}

- (void)getRegionList
{
    if (_region) {
        [subRegionData getCustomRegionListParentRegionName:self.region.RegionName];
    }
}

- (void)resetData
{
    [self.subItems removeAllObjects];
    
    if (_region) {
        CustomRegionItem *item = [[CustomRegionItem alloc] init];
        item.RegionName = @"全部";
        item.LanguageCode = self.region.LanguageCode;
        item.ParentRegionName = self.region.ParentRegionName;
        item.ID = self.region.ID;
        item.isCustom = self.region.isCustom;
        [self.subItems addObject:item];
    }
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error
{
    [sTableView reloadData];
    [sTableView2 reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
