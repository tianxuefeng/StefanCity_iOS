//
//  CommonNavigationController.m
//  BBYT
//
//  Created by zengchao on 14-1-15.
//  Copyright (c) 2014年 babyun. All rights reserved.
//

#import "CommonNavigationController.h"

@interface CommonNavigationController ()

@end

@implementation CommonNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __unsafe_unretained CommonNavigationController *weakSelf = self;
    self.delegate = weakSelf;
    //
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.navigationBar.exclusiveTouch = YES;
    self.navigationBar.userInteractionEnabled = YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    NSLog(@"hehe");
    
    self.navigationBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    [super pushViewController:viewController animated:animated];
    
//    isPush = YES;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
//    isPush = YES;
    
    self.navigationBar.userInteractionEnabled = NO;
        self.view.userInteractionEnabled = NO;
    //    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.interactivePopGestureRecognizer.enabled = NO;
    //    }
    
    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    self.navigationBar.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
    
    //    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.interactivePopGestureRecognizer.enabled = YES;
    //    }
    
//    isPush = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
