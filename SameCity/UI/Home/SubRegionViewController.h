//
//  SubRegionViewController.h
//  samecity
//
//  Created by zengchao on 15/4/12.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "CommonViewController.h"
#import "RegionData.h"
#import "CustomRegionItem.h"
#import "YLEditBottomView.h"
#import "CustomRegionItem.h"

@class SubRegionViewController;

@protocol SubRegionViewControllerDelegate <NSObject>

- (void)subRegion:(SubRegionViewController *)target select:(CustomRegionItem *)region;

@end

@interface SubRegionViewController : CommonViewController<HttpServiceDelegate,UITableViewDataSource,UITableViewDelegate>
{
    RegionData *regionData;
//    RegionData *regionData2;
    RegionData *addRegionRequest;
    
    UITableView *regionTableView;
    
    //    YLEditBottomView *editBottomView;
}


@property (nonatomic ,retain) CustomRegionItem *region;

//@property (nonatomic ,retain) NSString *cityName;

//@property (nonatomic ,retain) NSString *cityId;

@property (nonatomic ,assign) id<SubRegionViewControllerDelegate>delegate;

@property (nonatomic ,retain) NSMutableArray *items;

//@property (nonatomic ,retain) NSMutableArray *items1;
//@property (nonatomic ,retain) NSMutableArray *items2;

@end
