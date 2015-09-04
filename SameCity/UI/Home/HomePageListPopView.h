//
//  HomePageListPopView.h
//  samecity
//
//  Created by zengchao on 15/2/2.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegionData.h"

@class HomePageListPopView;

@protocol HomePageListPopViewDelegate <NSObject>

- (void)homePagePopViewShow:(HomePageListPopView *)target;

- (void)homePagePopViewHide:(HomePageListPopView *)target;

//- (void)homePagePopViewCancel:(HomePageListPopView *)target;

- (void)homePagePopViewDidSelect:(HomePageListPopView *)target;

@end

@interface HomePageListPopView : UIView<UITableViewDataSource,UITableViewDelegate,HttpServiceDelegate>
{
    UITableView *sTableView;
    UITableView *sTableView2;
    UIView *backgroundView;
    
    RegionData *regionData;
    RegionData *regionData2;
    RegionData *subRegionData;
}

@property (nonatomic ,assign) int popType;

@property (nonatomic ,assign) BOOL isBuy;
@property (nonatomic ,retain) NSString *regionId;
@property (nonatomic ,retain) NSString *subRegionId;
@property (nonatomic ,retain) NSString *subRegionName;

@property (nonatomic ,retain) NSString *cityName;
@property (nonatomic ,retain) NSString *cityId;

@property (nonatomic ,retain) NSMutableArray *items;
@property (nonatomic ,retain) NSMutableArray *subItems;

@property (nonatomic ,retain) NSMutableArray *items1;
@property (nonatomic ,retain) NSMutableArray *items2;

@property (nonatomic ,assign) id <HomePageListPopViewDelegate> delegate;

@property (nonatomic ,assign) BOOL isPop;

- (void)setupUI;

- (void)show;
- (void)hide;

@end
