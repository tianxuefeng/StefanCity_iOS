//
//  CategoryItem.h
//  SameCity
//
//  Created by zengchao on 14-6-12.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "JSONModel.h"

#define CATE_ID                 @"cate_ID"
#define CATE_Title              @"cate_Title"
#define CATE_Description        @"cate_Description"
#define CATE_ParentID           @"cate_ParentID"
#define CATE_CountryCode        @"cate_CountryCode"
#define CATE_Images             @"cate_Images"
#define CATE_CreateUser         @"cate_CreateUser"
#define CATE_Sequence           @"cate_Sequence"
#define CATE_Type               @"cate_Type"

@interface CategoryItem : JSONModel<NSCopying,NSCoding>

@property (nonatomic ,retain) NSString *ID;

@property (nonatomic ,retain) NSString *Title;

@property (nonatomic ,retain) NSString *Description;

@property (nonatomic ,retain) NSString *ParentID;

@property (nonatomic ,retain) NSString *CountryCode;

@property (nonatomic ,retain) NSString *Images;

@property (nonatomic ,retain) NSString *CreateUser;

@property (nonatomic ,retain) NSString *Sequence;

@property (nonatomic ,retain) NSString *type;

@end
