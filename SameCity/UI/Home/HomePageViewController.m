//
//  IndexViewController.m
//  SameCity
//
//  Created by zengchao on 14-4-23.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "HomePageViewController.h"
#import "CategoryViewController.h"
#import "AppDelegate.h"
#import "GoodsDetailViewController.h"
#import "UserLogin.h"
#import "MessageViewController.h"
#import "HomePageCell.h"
#import "CityBarItemView.h"
#import "CityViewController.h"
#import "RegionViewController.h"
#import "FXZLocationManager.h"
#import "Global.h"
//#import "HomePageListViewController.h"
#import "AdMoGoView.h"
#import "BUIView.h"
#import "RegisterViewController.h"

@interface HomePageViewController ()<RegionViewControllerDelegate,AdMoGoDelegate>

@end

@implementation HomePageViewController

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
    RELEASE_SAFELY(defaultCityLb);
    RELEASE_SAFELY(collectView);
    RELEASE_SAFELY(categoryData);
    RELEASE_SAFELY(memberRequest);
//    RELEASE_SAFELY(functionBg);
    
    [super dealloc];
}

- (void)setupNavi
{
    [super setupNavi];
    
//    self.title = @"同城";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:[CityBarItemView shareInstance]];
    [[CityBarItemView shareInstance].acButton addTarget:self action:@selector(gotoCityCtl:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    RELEASE_SAFELY(left);
    
    UIImageView *sIcon = [[UIImageView alloc] initWithImage:ImageWithName(@"stefen_icon")];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:sIcon];
    self.navigationItem.rightBarButtonItem = right;
    
    RELEASE_SAFELY(sIcon);
    RELEASE_SAFELY(right);
}

- (void)gotoCityCtl:(id)sender
{
    RegionViewController *next = [[RegionViewController alloc] init];
    next.delegate = self;
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[UserLogin instanse].categoryItems removeAllObjects];
    
    MainCate *cates = [[Global ShareCenter] getMainCateArray];
    if (cates && cates.cates) {
        self.pre_language = cates.language;
        [[UserLogin instanse].categoryItems addObjectsFromArray:cates.cates];
    }
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = CGSizeMake(kMainScreenWidth/4,kMainScreenWidth/4+20);
    //    layout.sectionInset                 = UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0);
    layout.minimumInteritemSpacing      = 0;
    layout.minimumLineSpacing           = 0;
    layout.headerReferenceSize          = CGSizeMake(0, 15.0);
    layout.footerReferenceSize          = CGSizeMake(0, 15.0);
    
    collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-20-44-49-50) collectionViewLayout:layout];
    collectView.backgroundColor = COLOR_BG;
    [collectView registerClass:[HomePageCell class]
    forCellWithReuseIdentifier:@"GradientCell"];
    collectView.delegate = self;
    collectView.dataSource = self;
//    collectView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//    collectView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    [self.view addSubview:collectView];
    
    [layout release];
    
    AdMoGoView *adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone
                                         adType:AdViewTypeNormalBanner                                adMoGoViewDelegate:self];
//    adView.adWebBrowswerDelegate = self;
    adView.frame = CGRectMake(0.0, kMainScreenHeight-20-44-49-50, kMainScreenWidth, 50.0);
    [self.view addSubview:adView];
    
//    CGSize asd = [adView getBannerCustomSize];
    
    categoryData = [[CategoryData alloc] init];
    categoryData.delegate = self;
    
    memberRequest = [[MemberData alloc] init];
    memberRequest.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cateReload:) name:CateReloadNotificationKey object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitle) name:LocationManagerLocationGetAddressNotificationKey object:nil];
//     self.view.backgroundColor = COLOR_BG;
}

- (void)checkManager
{
    if (![UserLogin instanse].isLogin && ![UserLogin instanse].hasAdminTips) {
        //
        if (!memberRequest.isLoading) {
            
//            [self startLoading];
            [memberRequest checkHasAdmin:[Global ShareCenter].city];
        }

    }
}

- (void)getCategarys
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_CITY];
    self.title = [NSString stringWithFormat:@"%@%@",city,NSLocalizedString(title_appname, nil)];
    [ApplicationDelegate.tabBarCtl hidesTabBar:NO animated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if (!isLoaded) {
        
        if (!categoryData.isLoading) {
            
            if ([UserLogin instanse].categoryItems.count == 0) {
                [self startLoading];
            }
            
            self.pre_language = currentLanguage;
            [categoryData getCategoryListParentID:@"0"];
        }
    }
    else {
        
        if (_pre_language) {
            if (![self.pre_language isEqualToString:currentLanguage]) {
                
                
                [[UserLogin instanse].categoryItems removeAllObjects];
                
                MainCate *cates = [[Global ShareCenter] getMainCateArray];
                if (cates && cates.cates) {
                    self.pre_language = cates.language;
                    [[UserLogin instanse].categoryItems addObjectsFromArray:cates.cates];
                }
                else {
                    if (!categoryData.isLoading) {
                        
                        if ([UserLogin instanse].categoryItems.count == 0) {
                            [self startLoading];
                        }
                        
                        self.pre_language = currentLanguage;
                        [categoryData getCategoryListParentID:@"0"];
                    }
                }
            }
        }
    }
}

- (void)reloadTitle
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_CITY];
    self.title = [NSString stringWithFormat:@"%@%@",city,NSLocalizedString(title_appname, nil)];
}

- (void)cateReload:(id)sender
{
    if ([UserLogin instanse].categoryItems.count == 0) {
        [categoryData getCategoryListParentID:@"0"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkManager];

    [self getCategarys];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setupCategory
{
//    for (UIView *tmpView in functionBg.subviews) {
//        [tmpView removeFromSuperview];
//    }
//    
//    CGFloat width = 20;
//
//    for (int i=0; i<[UserLogin instanse].categoryItems.count; i++) {
//        //
//        CategoryItem *categoryItem = [UserLogin instanse].categoryItems[i];
//        
//        CommonButton *categoryBtn = [CommonButton buttonWithType:UIButtonTypeCustom];
//        categoryBtn.tag = 100+i;
//        [functionBg addSubview:categoryBtn];
//        if ([NSString isNotEmpty:categoryItem.Title]) {
//            
//            CGSize size = [NSString calculateTextHeight:categoryBtn.titleLabel.font givenText:categoryItem.Title givenWidth:100];
//            
//            categoryBtn.frame = CGRectMake(width, 10, size.width, 20);
//            [categoryBtn setTitle:categoryItem.Title forState:UIControlStateNormal];
//            
//            width += size.width+20;
//        }
//        [categoryBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    functionBg.contentSize = CGSizeMake(width+20, functionBg.frame.size.height);
}

//- (void)buttonClick:(UIButton *)sender
//{
//    NSInteger tag = sender.tag-100;
//    
//    CategoryItem *categoryItem = [UserLogin instanse].categoryItems[tag];
//    
//    CategoryViewController *next = [[CategoryViewController alloc] init];
//    next.cItem = categoryItem;
//    next.title = categoryItem.Title;
//    [self.navigationController pushViewController:next animated:YES];
//    [next release];
//    
//}

- (void)httpService:(HttpService *)target Succeed:(NSObject *)response
{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self stopLoading];
    
    if (target.tag == CATEGORY_DATA_TAG) {
        
        if ([(NSArray *)response count] > 0) {
            isLoaded = YES;
        }
        
        if ([UserLogin instanse].categoryItems.count == 0) {
            [[UserLogin instanse].categoryItems removeAllObjects];
            [[UserLogin instanse].categoryItems addObjectsFromArray:(NSArray *)response];
            //        [self setupCategory];
            [collectView reloadData];
        }
   
        [[Global ShareCenter] deleteAllCates];
        
        [[Global ShareCenter] insertNewCates:(NSArray *)response];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CateObtainNotificationKey object:nil];
    }
    else if (target.tag == MEMBER_CHECK_TAG) {
    
        [UserLogin instanse].hasAdminTips = YES;
        
        NSString *responseStr = (NSString *)response;
        
        if (responseStr && [responseStr isKindOfClass:[NSNumber class]]) {
            //
            if (!responseStr.boolValue) {
                //
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该城市没有管理员，是否成为管理员?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //            [alert show];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    //
                    if (buttonIndex == 1) {
                        //
                        RegisterViewController *next = [[RegisterViewController alloc] init];
                        next.isAdmin = YES;
                        
                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
                        [self.navigationController presentViewController:navi animated:YES completion:NULL];
                    }
                }];
            }
        }
    }
}

- (void)httpService:(HttpService *)target Failed:(NSError *)error
{
    if (target.tag == CATEGORY_DATA_TAG) {
        if ([UserLogin instanse].categoryItems.count == 0) {
            [self stopLoadingWithError:nil];
        }
        else {
            [self stopLoading];
        }
    }
    else {
        [self stopLoading];
    }
    
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [UserLogin instanse].categoryItems.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    HomePageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CategoryItem *citem = [UserLogin instanse].categoryItems[indexPath.row];
    cell.cItem = citem;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryItem *citem = [UserLogin instanse].categoryItems[indexPath.row];
    
    CategoryViewController *next = [[CategoryViewController alloc] init];
    next.cItem = citem;
    next.title = citem.Title;
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

#pragma mark -- RegionDelegate
- (void)region:(RegionViewController *)target select:(CustomRegionItem *)region andSubRegion:(CustomRegionItem *)subRegion
{
    if (region) {
        [[Global ShareCenter] setRegion:region.RegionName];
    }
    else {
        [[Global ShareCenter] setRegion:@""];
    }
    
    if (subRegion) {
        [[Global ShareCenter] setSubregion:subRegion.RegionName];
    }
    else {
        [[Global ShareCenter] setSubregion:@""];
    }
    
    [self.navigationController popToViewController:self animated:YES];
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
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
