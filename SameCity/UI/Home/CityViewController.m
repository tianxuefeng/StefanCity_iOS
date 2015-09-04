//
//  CityViewController.m
//  SameCity
//
//  Created by zengchao on 14-6-28.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "CityViewController.h"
#import "FXZLocationManager.h"
#import "CitysViewController.h"
#import "RegionViewController.h"
#import "Global.h"
#import "UserLogin.h"

@interface CityViewController ()<CitysViewControllerDelegate,RegionViewControllerDelegate>

@end

@implementation CityViewController

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
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    RELEASE_SAFELY(_statusLb);
    RELEASE_SAFELY(_countryText);
    RELEASE_SAFELY(_cityText);
    RELEASE_SAFELY(_regionText);
    RELEASE_SAFELY(bgScrollView);
    
    RELEASE_SAFELY(managerRegionRequest);
    RELEASE_SAFELY(addRegionRequest);
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
    self.title = NSLocalizedString(lab_location_address, nil);
    
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *left = [UIBarButtonItem createBackBarButtonItemTarget:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = left;
    }
    else {
        UIImageView *sIcon = [[UIImageView alloc] initWithImage:ImageWithName(@"stefen_icon")];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:sIcon];
        self.navigationItem.leftBarButtonItem = left;
        
        RELEASE_SAFELY(sIcon);
        RELEASE_SAFELY(left);

    }
    
//    UIBarButtonItem *right = [UIBarButtonItem createBarButtonItemWithTitle:@"选择城市" target:self action:@selector(gotoCitys)];
//    self.navigationItem.rightBarButtonItem = right;
}

- (void)gotoCitys
{
    CitysViewController *next = [[CitysViewController alloc] init];
    next.delegate = self;
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

- (void)gotoRegion
{
    if (![NSString isNotEmpty:self.cityText.text]) {
        [self showTips:NSLocalizedString(hint_city, nil)];
        return;
    }
    
    RegionViewController *next = [[RegionViewController alloc] init];
    next.delegate = self;
//    next.cityId = self.selectCityID;
    next.cityName = self.selectCityName;
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

- (void)checkCanManager
{
    if (!managerRegionRequest.isLoading) {
        [managerRegionRequest isManagerCity:_cityText.text];
    }
}

- (void)postNewRegion
{
    if (!addRegionRequest.isLoading) {
        [addRegionRequest postCustomRegionParentRegionName:_cityText.text andRegionName:_regionText.text];
        [self performSelector:@selector(enterApp2) withObject:nil afterDelay:0.2];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [UIApplication sharedApplication]
    isReloadCity = NO;
    citySelectBtn.tag = 100;
    regionSelectBtn.tag = 101;
    
    [locationBtn setTitle:NSLocalizedString(title_refresh_location, nil) forState:UIControlStateNormal];
    [locationBtn setBackgroundImage:ImageWithName(@"btn_normal") forState:UIControlStateNormal];
    [locationBtn setBackgroundImage:ImageWithName(@"btn_press") forState:UIControlStateHighlighted];
    [locationBtn addTarget:self action:@selector(reloadLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [enterBtn addTarget:self action:@selector(enterApp) forControlEvents:UIControlEventTouchUpInside];
    
    self.countryText.enabled = NO;
    self.cityText.enabled = YES;
    self.regionText.enabled = YES;
    
    self.countryText.background = [ImageWithName(@"input_bg_2") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 90, 5, 10)];
    self.cityText.background = [ImageWithName(@"input_bg_2") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 90, 5, 10)];
    self.regionText.background = [ImageWithName(@"input_bg_2") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 90, 5, 10)];
    
    self.countryText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    tipsCityLb.text = NSLocalizedString(tips_locate_city, nil);
    countryLb.text = NSLocalizedString(lab_location_country, nil);
    cityLb.text = NSLocalizedString(lab_location_city, nil);
    regionLb.text = NSLocalizedString(lab_location_locality, nil);
    tipsLb.text = NSLocalizedString(msg_tips_setting, nil);
    
    [city_selectBtn setTitle:NSLocalizedString(lab_select, nil) forState:UIControlStateNormal];
    [regionSelectBtn setTitle:NSLocalizedString(lab_select, nil) forState:UIControlStateNormal];
    [enter_selectBtn setTitle:NSLocalizedString(btn_location_welcome, nil) forState:UIControlStateNormal];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, self.countryText.frame.size.height)];
    imageV.backgroundColor = [UIColor clearColor];
    self.countryText.leftViewMode = UITextFieldViewModeAlways;
    self.countryText.leftView = imageV;
    [imageV release];
    
    self.countryText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, self.countryText.frame.size.height)];
    imageV2.backgroundColor = [UIColor clearColor];
    self.cityText.leftViewMode = UITextFieldViewModeAlways;
    self.cityText.leftView = imageV2;
    [imageV2 release];
    
    self.countryText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, self.countryText.frame.size.height)];
    imageV3.backgroundColor = [UIColor clearColor];
    self.regionText.leftViewMode = UITextFieldViewModeAlways;
    self.regionText.leftView = imageV3;
    [imageV3 release];
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        //定位功能可用，开始定位
        self.statusLb.text = NSLocalizedString(msg_local_success, nil);
    }
    else if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        self.statusLb.text = @"是否打开定位功能";
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        self.statusLb.text = NSLocalizedString(msg_city_select_city_error, nil);
    }
    
    [self initUI];
    [self reloadUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI) name:LocationManagerLocationGetAddressNotificationKey object:nil];
    
    bgScrollView.scrollEnabled = YES;
    
    managerRegionRequest = [[RegionData alloc] init];
    managerRegionRequest.delegate = self;
    
    addRegionRequest = [[RegionData alloc] init];
    addRegionRequest.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.countryText resignFirstResponder];
    [self.cityText resignFirstResponder];
    [self.regionText resignFirstResponder];
}

- (void)enterApp
{
    if (![NSString isNotEmpty:self.cityText.text]) {
        [self showTips:NSLocalizedString(hint_city, nil)];
        return;
    }
    
//    if (![NSString isNotEmpty:self.regionText.text]) {
//        [self showTips:NSLocalizedString(msg_not_region_name, nil)];
//        return;
//    }
    
    if ([NSString isNotEmpty:self.countryText.text]) {
        
        [[Global ShareCenter] setCountry:self.countryText.text];
    }
    
    self.selectCityName = self.cityText.text;
    
    if ([NSString isNotEmpty:self.selectCityName]) {
        
        [[Global ShareCenter] setCity:self.selectCityName];
    }
    
//    if ([NSString isNotEmpty:self.selectCityID]) {
//        [[NSUserDefaults standardUserDefaults] setObject:self.selectCityID forKey:DEFAULT_CITY_ID];
//    }
    
    [[Global ShareCenter] setRegion:self.selectRegion];
    [[Global ShareCenter] setSubregion:self.selectSubRegion];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UserLogin instanse].hasAdminTips = NO;
    
//    [self postNewRegion];
    [self checkCanManager];
}

- (void)enterApp2
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        CATransition *  tran=[CATransition animation];
        tran.removedOnCompletion = YES;
        tran.type = @"oglFlip";
        tran.duration= 0.46;
        tran.subtype = kCATransitionFromRight;
        [ApplicationDelegate.window.layer addAnimation:tran forKey:@"kongyu"];
        
        ApplicationDelegate.window.rootViewController = ApplicationDelegate.tabBarCtl;
    }
}

- (void)reloadLocation
{
    //获取地理位置
    isReloadCity = NO;
    [[FXZLocationManager sharedManager] startUploadLocation];
}

- (void)initUI
{
    self.countryText.text = [Global ShareCenter].country;
    self.selectCityName = [Global ShareCenter].city;
    self.selectRegion = [Global ShareCenter].region;
    self.selectSubRegion = [Global ShareCenter].subregion;
    
    self.cityText.text = self.selectCityName;
    if ([NSString isNotEmpty:self.selectSubRegion]) {
        self.regionText.text = self.selectSubRegion;
    }
    else {
        self.regionText.text = self.selectRegion;
    }
    
    if ([NSString isNotEmpty:self.countryText.text] && [NSString isNotEmpty:self.cityText.text]) {
        isReloadCity = YES;
    }
}

- (void)reloadUI
{
//    if ([NSString isNotEmpty:self.countryText.text]) {
//        return;
//    }
    if (isReloadCity) {
        return;
    }
    
    self.countryText.text = [FXZLocationManager sharedManager].country;
    self.selectCityName = [FXZLocationManager sharedManager].city;
    self.selectRegion = [FXZLocationManager sharedManager].region;
    
    self.cityText.text = self.selectCityName;
    self.regionText.text = self.selectRegion;
    self.selectSubRegion = @"";
    
    
    if ([NSString isNotEmpty:self.countryText.text] && [NSString isNotEmpty:self.cityText.text]) {
        isReloadCity = YES;
    }
}

- (void)CityDidSelect:(CityDto *)Dto
{
    if (Dto) {
        self.cityText.text = Dto.name;
//        self.selectCityID = Dto.identify;
        self.selectCityName = Dto.name;
        
        self.selectRegion = @"";
        self.selectSubRegion = @"";
        self.regionText.text = @"";
    }
}

- (void)region:(RegionViewController *)target select:(CustomRegionItem *)region andSubRegion:(CustomRegionItem *)subRegion
{
    
    if (subRegion) {
        self.regionText.text = subRegion.RegionName;
    }
    else if (region) {
        self.regionText.text = region.RegionName;
    }
    else {
        self.regionText.text = @"";
    }
    
    
    if (region) {
        self.selectRegion = region.RegionName;
    }
    else {
        self.selectRegion = @"";
    }
    
    if (subRegion) {
        self.selectSubRegion = subRegion.RegionName;
    }
    else {
        self.selectSubRegion = @"";
    }
    
    
    [self.navigationController popToViewController:self animated:YES];
}

- (IBAction)buttonClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        //
        [self gotoCitys];
    }
    else if (sender.tag == 101) {
        //
        [self gotoRegion];
    }
}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
    if (managerRegionRequest == target) {
        //
        if ([response isKindOfClass:[NSNumber class]]) {
            if (![(NSNumber *)response boolValue]) {
                //
                [self postNewRegion];
                return;
            }
        }
        
        [self performSelector:@selector(enterApp2) withObject:nil afterDelay:0.2];
    }
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error
{
    [self stopLoadingWithError:NSLocalizedString(msg_server_error, nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
