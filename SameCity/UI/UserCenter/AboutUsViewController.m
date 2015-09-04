//
//  AboutUsViewController.m
//  SameCity
//
//  Created by zengchao on 14-7-13.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupNavi
{
    [super setupNavi];
    
    self.title = NSLocalizedString(title_aboutus, nil);
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.tabBarCtl hidesTabBar:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth-56)*0.5, 15, 56, 56)];
    icon.image = ImageWithName(@"AppIcon60x60");
    [self.view addSubview:icon];
    
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    UILabel *visionLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 56+30, kMainScreenWidth-40, 21)];
    visionLb.backgroundColor = [UIColor clearColor];
    visionLb.textColor = COLOR_CONTENT;
    visionLb.textAlignment = NSTextAlignmentCenter;
    visionLb.font = [UIFont systemFontOfSize:15];
    visionLb.text = [NSString stringWithFormat:@"Version:%@",versionStr];
    [self.view addSubview:visionLb];
    
    UILabel *descLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 56+30+25, kMainScreenWidth-40, 21)];
    descLb.backgroundColor = [UIColor clearColor];
    descLb.textColor = COLOR_TITLE;
    descLb.font = [UIFont systemFontOfSize:15];
    descLb.text = @"This is Stefan city-wide.";
    [self.view addSubview:descLb];
}

//- (float)getIOSVersion
//{
//    return [[[UIDevice currentDevice] systemVersion] floatValue];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
