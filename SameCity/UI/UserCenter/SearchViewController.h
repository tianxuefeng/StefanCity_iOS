//
//  SearchViewController.h
//  samecity
//
//  Created by zengchao on 14-8-10.
//  Copyright (c) 2014年 com.stefan. All rights reserved.
//

#import "CommonViewController.h"
#import "HomePageData.h"
#import "MJRefreshTableView.h"

@interface SearchViewController : CommonViewController<HttpServiceDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshTableViewDelegate,UISearchBarDelegate>
{
    UISearchBar *listSearchBar;
    
    HomePageData *listData;
    
    MJRefreshTableView *listTableView;
    
    BOOL isRefreshing;
}

@property (nonatomic ,retain) NSMutableArray *items;

@end
