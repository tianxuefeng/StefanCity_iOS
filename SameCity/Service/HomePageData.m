//
//  HomePageData.m
//  SameCity
//
//  Created by zengchao on 14-5-3.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "HomePageData.h"
#import "HomePageItem.h"
#import "UserLogin.h"
#import "HttpConstant.h"
#import "Constant.h"

@implementation HomePageData

- (id)initWithCity:(NSString *)pCity andRegion:(NSString *)pRegion
{
    if (self = [super init]) {
        //
        self.tag = HOME_DATA_TAG;
        self.city = pCity;
        self.region = pRegion;
        self.categoryID = @"1";
        self.type = @"1";
        self.SubRegion = @"";
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    RELEASE_SAFELY(_city);
    RELEASE_SAFELY(_region);
    RELEASE_SAFELY(_categoryID);
    RELEASE_SAFELY(_parentID);
    RELEASE_SAFELY(_type);
    RELEASE_SAFELY(_SubRegion);
    
    [super dealloc];
}

- (NSString *)city
{
    if ([NSString isNotEmpty:_city]) {
        return _city;
    }
    return @"";
}

- (NSString *)region
{
    if ([NSString isNotEmpty:_region]) {
        return _region;
    }
    return @"";
}

- (NSString *)SubRegion
{
    if ([NSString isNotEmpty:_SubRegion]) {
        return _SubRegion;
    }
    return @"";
}

- (NSString *)categoryID
{
    if ([NSString isNotEmpty:_categoryID]) {
        return _categoryID;
    }
    return @"";
}

- (void)getHomeDataPageNum:(int)pageNum andPageSize:(int)pageSize
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params addObject:self.city forKey:@"City"];
    [params addObject:self.region forKey:@"Region"];
    [params addObject:self.categoryID forKey:@"CategoryID"];
    [params addObject:self.parentID forKey:@"ParentID"];
    [params addObject:[NSString stringWithFormat:@"%d",pageNum] forKey:@"page"];
    [params addObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [params addObject:self.SubRegion forKey:@"SubRegion"];
    [params addObject:self.type forKey:@"Type"];
    
    [self GetAsync:combineStr(ITEM_SERVICE_URL, GET_PAGE_LIST_URL) andParams:params Success:^(NSObject *response) {
        //
        NSMutableArray *items = [NSMutableArray array];
        
        if (response && [response isKindOfClass:[NSArray class]]) {
            for (NSDictionary *tmpDic in (NSArray *)response) {
                HomePageItem *indexDto = [[HomePageItem alloc] initWithDictionary:tmpDic error:nil];
                if (indexDto) {
                    NSString *timeString = indexDto.CreateDate;
                    timeString = [timeString stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
                    timeString = [timeString stringByReplacingOccurrencesOfString:@")/" withString:@""];
                    indexDto.CreateDate = timeString;
                    [items addObject:indexDto];
                }
                RELEASE_SAFELY(indexDto);
            }
        }
        
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:items];
        }
        
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)insertNewItemTitle:(NSString *)title desc:(NSString *)desc price:(NSString *)price images:(NSString *)images phone:(NSString *)phone address:(NSString *)address cateID:(NSString *)cateID type:(BOOL)isBuy
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params addObject:title forKey:@"Title"];
    [params addObject:desc forKey:@"Description"];

    if ([NSString isNotEmpty:price]) {
        [params addObject:price forKey:@"Price"];
    }
    else {
        [params addObject:@"0" forKey:@"Price"];
    }
    
    [params addObject:phone forKey:@"Phone"];
    
    [params addObject:self.city forKey:@"City"];
    
    [params addObject:self.region forKey:@"Region"];
    [params addObject:self.SubRegion forKey:@"SubRegion"];
    [params addObject:cateID forKey:@"CategoryID"];
    
    if (images) {
        [params addObject:images forKey:@"Images"];
    }
    else {
        [params addObject:@"" forKey:@"Images"];
    }
    
    [params addObject:address forKey:@"Address"];
    [params addObject:@"1" forKey:@"Rank"];
    [params addObject:[UserLogin instanse].uid forKey:@"UserID"];
    [params addObject:@"1" forKey:@"Status"];
    [params addObject:@"1" forKey:@"Sequence"];
    
    [params addObject:@"" forKey:@"QQSkype"];
    [params addObject:@"" forKey:@"PostalCode"];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    [params addObject:[currentLocale objectForKey:NSLocaleCountryCode] forKey:@"CountryCode"];
    
    if (isBuy) {
        [params addObject:@"0" forKey:@"Type"];
    }
    else {
        [params addObject:@"1" forKey:@"Type"];
    }

    
    [self PostAsync:combineStr(ITEM_SERVICE_URL, POST_NEWITEM_URL) andParams:params Success:^(NSObject *response) {
        //

        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)getMyPublishedItems
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params addObject:[UserLogin instanse].uid forKey:@"UserID"];
    
    [self GetAsync:combineStr(ITEM_SERVICE_URL, GET_USER_PUBLISHED_URL) andParams:params Success:^(NSObject *response) {
        //
        NSMutableArray *items = [NSMutableArray array];
        
        if (response && [response isKindOfClass:[NSArray class]]) {
            for (NSDictionary *tmpDic in (NSArray *)response) {
                HomePageItem *indexDto = [[HomePageItem alloc] initWithDictionary:tmpDic error:nil];
                if (indexDto) {
                    NSString *timeString = indexDto.CreateDate;
                    timeString = [timeString stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
                    timeString = [timeString stringByReplacingOccurrencesOfString:@")/" withString:@""];
                    indexDto.CreateDate = timeString;
                    [items addObject:indexDto];
                }
                RELEASE_SAFELY(indexDto);
            }
        }
        
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:items];
        }
        
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];

}

- (void)searchHomeDataPageNum:(int)pageNum andPageSize:(int)pageSize key:(NSString *)key
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params addObject:self.city forKey:@"City"];
    [params addObject:key forKey:@"keyword"];
    [params addObject:[NSString stringWithFormat:@"%d",pageNum] forKey:@"page"];
    [params addObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    
    [self GetAsync:combineStr(ITEM_SERVICE_URL, GET_SEARCH_LIST_URL) andParams:params Success:^(NSObject *response) {
        //
        NSMutableArray *items = [NSMutableArray array];
        
        if (response && [response isKindOfClass:[NSArray class]]) {
            for (NSDictionary *tmpDic in (NSArray *)response) {
                HomePageItem *indexDto = [[HomePageItem alloc] initWithDictionary:tmpDic error:nil];
                if (indexDto) {
                    NSString *timeString = indexDto.CreateDate;
                    timeString = [timeString stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
                    timeString = [timeString stringByReplacingOccurrencesOfString:@")/" withString:@""];
                    indexDto.CreateDate = timeString;
                    [items addObject:indexDto];
                }
                RELEASE_SAFELY(indexDto);
            }
        }
        
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:items];
        }
        
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];

}

- (void)deleteGoodsId:(NSString *)goodsid
{

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params addObject:goodsid forKey:@"ID"];
    
    [self GetAsync:combineStr(ITEM_SERVICE_URL, DELETE_ITEM_URL) andParams:params Success:^(NSObject *response) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

@end
