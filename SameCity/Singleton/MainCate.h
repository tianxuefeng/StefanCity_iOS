//
//  MainCate.h
//  samecity
//
//  Created by zengchao on 15/2/2.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MainCate : NSManagedObject

@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) id cates;

@end
