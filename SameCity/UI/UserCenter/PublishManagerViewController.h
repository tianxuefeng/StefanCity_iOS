//
//  PublishManagerViewController.h
//  samecity
//
//  Created by zengchao on 15/4/12.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "CommonViewController.h"
#import "HomePageData.h"
#import "MJRefreshTableView.h"

@interface PublishManagerViewController : CommonViewController<HttpServiceDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshTableViewDelegate>
{
    MJRefreshTableView *myPublishedTableView;
    
    HomePageData *myPublishedData;
    HomePageData *deletePublishedData;
    
    BOOL isRefreshing;
}

@property (nonatomic ,retain) NSMutableArray *items;

@end
