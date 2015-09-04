//
//  EditHomePageListCell.h
//  samecity
//
//  Created by zengchao on 15/4/12.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "HomePageItem.h"

#define HOME_CELL_HEIGHT     70

@class EditHomePageListCell;

typedef enum {
    kFeedStatusNormal = 0,
    kFeedStatusLeftExpanded = 1,
    kFeedStatusLeftExpanding = 2,
}kFeedStatus;

typedef enum {
    FeedCellDirectionNone = 0,
    FeedCellDirectionRight = 1,
    FeedCellDirectionLeft = 2,
} FeedCellDirection;

@protocol EditCellDelegate <NSObject>

@optional
- (void)EditCellShowMenu:(EditHomePageListCell *)target;

//- (void)FMDownloadManagerCellShare:(FMDownloadManagerCell *)target;

- (void)EditCellUpdate:(EditHomePageListCell *)target;

- (void)EditCellDelete:(EditHomePageListCell *)target;

@end

@interface EditHomePageListCell : CommonTableViewCell
{
    //    UIView *bottomView;
//    UIButton *updateBtn;
    UIButton *deleteBtn;
    
    UIView *bottom;
    
    UIImageView *iconImageView;
    
    UILabel *titleLb;
    
    UILabel *addressLb;
    
    UILabel *priceLb;
    
    UILabel *dateLb;
}

@property (nonatomic ,assign) NSInteger row;

@property (nonatomic ,assign) id <EditCellDelegate> delegate;

@property (nonatomic ,retain) HomePageItem *item;

@property (nonatomic ,assign) kFeedStatus currentStatus;

- (void)_slideInContentViewFromDirection;

@end
