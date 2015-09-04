//
//  CategoryItem.m
//  SameCity
//
//  Created by zengchao on 14-6-12.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "CategoryItem.h"

@implementation CategoryItem

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        _ID  = [[aDecoder decodeObjectForKey:CATE_ID] copy];
        _Title  = [[aDecoder decodeObjectForKey:CATE_Title] copy];
        _Description  = [[aDecoder decodeObjectForKey:CATE_Description] copy];
        _ParentID  = [[aDecoder decodeObjectForKey:CATE_ParentID] copy];
        _CountryCode  = [[aDecoder decodeObjectForKey:CATE_CountryCode] copy];
        _Images  = [[aDecoder decodeObjectForKey:CATE_Images] copy];
        _Sequence  = [[aDecoder decodeObjectForKey:CATE_Sequence] copy];
        _CreateUser  = [[aDecoder decodeObjectForKey:CATE_CreateUser] copy];
        _type = [[aDecoder decodeObjectForKey:CATE_Type] copy];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:CATE_ID];
    [aCoder encodeObject:self.Title forKey:CATE_Title];
    [aCoder encodeObject:self.Description forKey:CATE_Description];
    [aCoder encodeObject:self.ParentID forKey:CATE_ParentID];
    [aCoder encodeObject:self.CountryCode forKey:CATE_CountryCode];
    [aCoder encodeObject:self.Images forKey:CATE_Images];
    [aCoder encodeObject:self.Sequence forKey:CATE_Sequence];
    [aCoder encodeObject:self.CreateUser forKey:CATE_CreateUser];
    [aCoder encodeObject:self.type forKey:CATE_Type];
}

- (void)dealloc
{
    RELEASE_SAFELY(_ID);
    RELEASE_SAFELY(_Title);
    RELEASE_SAFELY(_Description);
    RELEASE_SAFELY(_ParentID);
    RELEASE_SAFELY(_CountryCode);
    RELEASE_SAFELY(_Images);
    RELEASE_SAFELY(_Sequence);
    RELEASE_SAFELY(_CreateUser);
    RELEASE_SAFELY(_type);
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    CategoryItem *item = [[CategoryItem allocWithZone:zone] init];
    
    item.ID = self.ID;
    item.Title = self.Title;
    item.Description = self.Description;
    item.ParentID = self.ParentID;
    item.CountryCode = self.CountryCode;
    item.Images = self.Images;
    item.CreateUser = self.CreateUser;
    item.Sequence = self.Sequence;
    item.type = self.type;
    
    return item;
}

@end
