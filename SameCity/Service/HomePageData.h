//
//  HomePageData.h
//  SameCity
//
//  Created by zengchao on 14-5-3.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

//#import "SoapService.h"
#import "HttpService.h"

@interface HomePageData : HttpService

@property (nonatomic ,retain) NSString *city;

@property (nonatomic ,retain) NSString *region;

@property (nonatomic ,retain) NSString *SubRegion;

@property (nonatomic ,retain) NSString *categoryID;

@property (nonatomic ,retain) NSString *parentID;

@property (nonatomic ,retain) NSString *type;

- (id)initWithCity:(NSString *)city andRegion:(NSString *)region;

- (void)getHomeDataPageNum:(int)pageNum andPageSize:(int)pageSize;

- (void)insertNewItemTitle:(NSString *)title
                      desc:(NSString *)desc
                     price:(NSString *)price
                    images:(NSString *)images
                     phone:(NSString *)phone
                   address:(NSString *)address
                    cateID:(NSString *)cateID
                      type:(BOOL)isBuy;

- (void)getMyPublishedItems;

- (void)searchHomeDataPageNum:(int)pageNum andPageSize:(int)pageSize key:(NSString *)key;

- (void)deleteGoodsId:(NSString *)goodsid;

@end
