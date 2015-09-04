//
//  BaiduMobAdInterstitial.h
//  BaiduMobAdWebSDK
//
//  Created by deng jinxiang on 13-8-1.
//
//
#import <UIKit/UIKit.h>
#import "BaiduMobAdInterstitialDelegate.h"

/*
 * 1 插屏广告：游戏暂停、过关、失败等场景中使用 BaiduMobAdViewTypeInterstitialGame
 * 2 插屏广告：阅读章节切换等场景中使用 BaiduMobAdViewTypeInterstitialReader
 * 3 插屏广告：开机启动场景中使用 BaiduMobAdViewTypeInterstitialLaunch
 * 4 插屏广告：网络刷新场景中使用 BaiduMobAdViewTypeInterstitialRefresh
 * 5 插屏广告：插屏广告：其他场景中使用 BaiduMobAdViewTypeInterstitialOther
 * 7 插屏广告：视频图片前贴片 BaiduMobAdViewTypeInterstitialBeforeVideo
 * 8 插屏广告：视频暂停贴片 BaiduMobAdViewTypeInterstitialPauseVideo
 */
typedef enum _BaiduMobAdInterstitialType {
    BaiduMobAdViewTypeInterstitialGame = 1,
    BaiduMobAdViewTypeInterstitialReader = 2,
    BaiduMobAdViewTypeInterstitialLaunch = 3,
    BaiduMobAdViewTypeInterstitialRefresh = 4,
    BaiduMobAdViewTypeInterstitialOther = 5,
    BaiduMobAdViewTypeInterstitialBeforeVideo = 7,
    BaiduMobAdViewTypeInterstitialPauseVideo = 8

} BaiduMobAdInterstitialType;

@interface BaiduMobAdInterstitial : NSObject


/**
 *  委托对象
 */
@property (nonatomic ,assign) id<BaiduMobAdInterstitialDelegate> delegate;


/**
 *  插屏广告类型
 */
@property (nonatomic) BaiduMobAdInterstitialType interstitialType;

/**
 *  插屏广告是否准备好
 */
@property (nonatomic) BOOL isReady;

/**
 *  SDK版本
 */
@property (nonatomic, readonly) NSString* Version;

/**
 *  加载插屏广告
 */
- (void)load;

/**
 *  展示插屏广告
 */
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

/**
 * 加载自定义大小的插屏,必须大于100*150
 */
- (void)loadUsingSize:(CGRect)rect;

/**
 * 展示自定义大小的插屏
 */
- (void)presentFromView:(UIView *)view;


@end
