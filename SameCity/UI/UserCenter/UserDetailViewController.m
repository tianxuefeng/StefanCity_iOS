//
//  UserDetailViewController.m
//  SameCity
//
//  Created by zengchao on 14-6-29.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "UserDetailViewController.h"
#import "MemberItem.h"
#import "UserLogin.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFELY(nameLb);
    RELEASE_SAFELY(IDLb);
    RELEASE_SAFELY(qqLb);
    RELEASE_SAFELY(phoneLb);
    RELEASE_SAFELY(emailLb);
    RELEASE_SAFELY(memberData);
    RELEASE_SAFELY(saveMemberData);
    RELEASE_SAFELY(nameLbb);
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
    self.title = NSLocalizedString(lab_detail_info, nil);
    
    UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
    if ([self.userID isEqualToStr:[UserLogin instanse].uid]) {
        UIBarButtonItem *right = [UIBarButtonItem createBarButtonItemWithTitle:NSLocalizedString(btn_submit, nil) target:self action:@selector(updateUserInfo:)];
        self.navigationItem.rightBarButtonItem = right;
    }
}

- (void)updateUserInfo:(id)sender
{
    [self.view endEditing:YES];
    
    if (![NSString isNotEmpty:nameLb.text]) {
        AlertMessage(NSLocalizedString(hint_username, nil));
        return;
    }
    
    __unsafe_unretained UserDetailViewController *weakSelf = self;
    
    [[UserLogin instanse] loginFrom:self succeed:^{
        //
        if (!weakSelf->saveMemberData.isLoading) {
            
            [weakSelf startLoading];
            
            [weakSelf->saveMemberData updateMemberDetailwithName:nameLb.text withPhone:phoneLb.text withQQSkype:qqLb.text withMemType:[UserLogin instanse].MemType withDeviceToken:@""];
        }
      
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    nameLbb.text = NSLocalizedString(lab_register_name, nil);
    
    emailLb.enabled = NO;
    IDLb.enabled = NO;
    
    if ([self.userID isEqualToStr:[UserLogin instanse].uid]) {
        qqLb.enabled = YES;
        phoneLb.enabled = YES;
        nameLb.enabled = YES;
    }
    else {
        qqLb.enabled = NO;
        phoneLb.enabled = NO;
        nameLb.enabled = NO;
    }

    
    nameLb.background = [ImageWithName(@"input_bg_2") adjustSize];
    IDLb.background = [ImageWithName(@"input_bg_2") adjustSize];
    qqLb.background = [ImageWithName(@"input_bg_2") adjustSize];
    phoneLb.background = [ImageWithName(@"input_bg_2") adjustSize];
    emailLb.background = [ImageWithName(@"input_bg_2") adjustSize];
    
    nameLb.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    IDLb.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    qqLb.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneLb.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailLb.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, nameLb.frame.size.height)];
    imageV.backgroundColor = [UIColor clearColor];
    
    nameLb.leftViewMode = UITextFieldViewModeAlways;
    nameLb.leftView = imageV;
    [imageV release];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, IDLb.frame.size.height)];
    imageV.backgroundColor = [UIColor clearColor];
    
    IDLb.leftViewMode = UITextFieldViewModeAlways;
    IDLb.leftView = imageV;
    [imageV release];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, qqLb.frame.size.height)];
    imageV.backgroundColor = [UIColor clearColor];
    
    qqLb.leftViewMode = UITextFieldViewModeAlways;
    qqLb.leftView = imageV;
    [imageV release];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, emailLb.frame.size.height)];
    imageV.backgroundColor = [UIColor clearColor];
    emailLb.leftViewMode = UITextFieldViewModeAlways;
    emailLb.leftView = imageV;
    [imageV release];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, phoneLb.frame.size.height)];
    imageV.backgroundColor = [UIColor clearColor];
    phoneLb.leftViewMode = UITextFieldViewModeAlways;
    phoneLb.leftView = imageV;
    [imageV release];
    
    
    memberData = [[MemberData alloc] init];
    memberData.delegate = self;
    
    saveMemberData = [[MemberData alloc] init];
    saveMemberData.delegate = self;
    
    if ([self.userID isEqualToStr:[UserLogin instanse].uid]) {
        if ([NSString isNotEmpty: [UserLogin instanse].email]) {
            nameLb.text =  [UserLogin instanse].name;
            emailLb.text =  [UserLogin instanse].email;
            IDLb.text =  [UserLogin instanse].uid;
            qqLb.text =  [UserLogin instanse].qqSkype;
            phoneLb.text =  [UserLogin instanse].phone;
        }
        else {
            //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self startLoading];
            
            [memberData getMemberDetail:self.userID];
        }
    }
    else {
        [self startLoading];
        
        [memberData getMemberDetail:self.userID];
    }

    
//    CommonButton *loginBtn = [CommonButton buttonWithType:UIButtonTypeCustom];
//    loginBtn.tag = 101;
//    loginBtn.backgroundColor = COLOR_THEME;
//    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [loginBtn setTitle:@"退出" forState:UIControlStateNormal];
//    [loginBtn setBackgroundImage:ImageWithName(@"btn_big_normal") forState:UIControlStateNormal];
//    [loginBtn setBackgroundImage:ImageWithName(@"btn_big_press") forState:UIControlStateHighlighted];
//    loginBtn.frame = CGRectMake(20, 300, kMainScreenWidth-40, 35);
//    [self.view addSubview:loginBtn];
//    [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(id)sender
{
    [[UserLogin instanse] clearUserInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.tabBarCtl hidesTabBar:YES animated:YES];
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self stopLoading];
    
    if (target == memberData) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            
            MemberItem *mItem = [[MemberItem alloc] initWithDictionary:(NSDictionary *)response error:nil];
            if (mItem) {
                //
                nameLb.text = mItem.Name;
                emailLb.text = mItem.Email;
                IDLb.text = mItem.ID;
                qqLb.text = mItem.QQSkype;
                phoneLb.text = mItem.Phone;
                
                if ([[UserLogin instanse].uid isEqualToStr: mItem.ID]) {
                    //...
                    [UserLogin instanse].name = mItem.Name;
                    [UserLogin instanse].email = mItem.Email;
                    [UserLogin instanse].qqSkype = mItem.QQSkype;
                    [UserLogin instanse].phone = mItem.Phone;
                    [UserLogin instanse].MemType = mItem.MemType;
                    
                    [[UserLogin instanse] saveUserInfo];
                }
            }
            RELEASE_SAFELY(mItem);
        }
    }
    else if (target == saveMemberData){
        
        if (response && [response isKindOfClass:[NSString class]]) {
            
            NSArray *results = [(NSString *)response componentsSeparatedByString:@"|"];
            
            if (results.count >= 2) {
                
                NSString *isLogin = results[0];
                NSString *reason = results[1];
                
                if ([NSString isNotEmpty:isLogin] && [isLogin isEqualToStr:@"true"]) {
                    
                    if ([[UserLogin instanse].uid isEqualToStr:self.userID]) {
                        //...
                        [UserLogin instanse].name = nameLb.text;
                        [UserLogin instanse].qqSkype = qqLb.text;
                        [UserLogin instanse].phone = phoneLb.text;
                        
                        [[UserLogin instanse] saveUserInfo];
                    }
                    
                    AlertMessage(NSLocalizedString(msg_update_user_success, nil));
                }
                else {
                    if ([NSString isNotEmpty:reason]) {
                        AlertMessage(reason);
                    }
                }
            }
        }
    }

}

- (void)httpService:(HttpService *)target Failed:(NSError *)error{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [MBProgressHUD showError:@"服务器错误" toView:self.view];
    
    [self stopLoadingWithError:NSLocalizedString(msg_server_error, nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
