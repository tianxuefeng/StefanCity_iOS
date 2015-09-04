//
//  AddressGoogleItem.h
//  samecity
//
//  Created by zengchao on 15/5/27.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "JSONModel.h"
#import "AddressComponentItem.h"

@interface AddressGoogleItem : JSONModel

@property (nonatomic ,strong) NSArray <AddressComponentItem> *address_components;

@property (nonatomic ,strong) NSString *formatted_address;

@property (nonatomic ,strong) NSString *place_id;

@property (nonatomic ,strong) NSArray *types;

@end
