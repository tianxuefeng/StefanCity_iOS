//
//  FeedbackViewController.m
//  SameCity
//
//  Created by zengchao on 14-7-13.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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
    
    self.title = NSLocalizedString(title_feedback, nil);
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [UIBarButtonItem createBarButtonItemWithTitle:NSLocalizedString(btn_submit, nil) target:self action:@selector(upload:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)upload:(id)sender
{
//    if (<#condition#>) {
//        <#statements#>
//    }
    if ([NSString isNotEmpty:feedText.text]) {
        //
        AlertMessage(NSLocalizedString(title_feedback_ok, nil));
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        AlertMessage(NSLocalizedString(history_NoInfo, nil));
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kMainScreenWidth-40, 21)];
    titleLb.font = [UIFont systemFontOfSize:15];
    titleLb.text = NSLocalizedString(title_feedback_desc, nil);
    titleLb.textColor = COLOR_CONTENT;
    [self.view addSubview:titleLb];
    
    feedText = [[UITextView alloc] initWithFrame:CGRectMake(20, 41, kMainScreenWidth-40, 100)];
    feedText.layer.cornerRadius = 5;
    feedText.layer.masksToBounds = YES;
    feedText.layer.borderColor = COLOR_CONTENT.CGColor;
    feedText.layer.borderWidth = 1;
    [self.view addSubview:feedText];
    
    [feedText becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.tabBarCtl hidesTabBar:YES animated:YES];
}

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
