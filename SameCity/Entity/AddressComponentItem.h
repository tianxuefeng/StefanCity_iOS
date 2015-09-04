//
//  AddressComponentItem.h
//  samecity
//
//  Created by zengchao on 15/5/27.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "JSONModel.h"

@protocol AddressComponentItem <NSObject> @end

@interface AddressComponentItem : JSONModel

@property (nonatomic ,strong) NSString *long_name;

@property (nonatomic ,strong) NSString *short_name;

@property (nonatomic ,strong) NSArray *types;

@end
