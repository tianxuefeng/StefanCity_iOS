//
//  PeopleManagerViewController.h
//  samecity
//
//  Created by zengchao on 15/4/12.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "CommonViewController.h"
#import "MemberData.h"

@interface PeopleManagerViewController : CommonViewController<HttpServiceDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *memberTableView;
    
    MemberData *memberData;
    MemberData *memberData2;
    MemberData *memberData3;
}

@property (nonatomic ,retain) NSMutableArray *items;

@end
