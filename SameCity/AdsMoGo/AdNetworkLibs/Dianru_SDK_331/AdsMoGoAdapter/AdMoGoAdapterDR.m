//
//  AdMoGoAdapterDR.m
//  wanghaotest
//
//  Created by MOGO on 15-3-9.
//
//

#import "AdMoGoAdapterDR.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoDeviceInfoHelper.h"

#import "AdMoGoAdSDKBannerNetworkRegistry.h"
#import "PutNoise.h"
#import "BuildSubject.h"
#define BANNERHEIGHT 50.0f
#define V_FRAME      self.view.frame
@interface AdMoGoAdapterDR()<YQLDelegate>{
    BOOL isStop;
    NSTimer *timer;
    BOOL isStopTimer;
}
@end

@implementation AdMoGoAdapterDR
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeDR;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    isStop = NO;
    isStopTimer = NO;
    [adMoGoCore adapter:self didGetAd:@"domob"];
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    CGSize size = CGSizeZero;
//    float device_width = [UIScreen mainScreen].bounds.size.width;
    switch (type) {
        case AdViewTypeNormalBanner:
            size = CGSizeMake(320.0, 50.0);
            break;
        case AdViewTypeLargeBanner:
            size = CGSizeMake(768.0,120.0);
            break;
        case AdViewTypeiPadNormalBanner:
            size = CGSizeMake(320.0, 50.0);
            break;
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSString class]] && key != nil) {
        DR_INIT(key, NO, nil);
    }else{
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
    bannerView.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [bannerView setBackgroundColor:[UIColor redColor]];
    
    DR_SHOW_AUTO(DR_BANNER, bannerView, self,false);
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}


/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopBeingDelegate{
    
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
    [self stopBeingDelegate];
}

- (void)dealloc{
    
    [super dealloc];
}

#pragma mark -- DRDelegate

/****************************************************/
/*广告列表回调                                        */
/*view :广告view                                     */
/*code :广告条数大于0，那么code=0，代表成功 反之code = -1 */
/****************************************************/
- (void)dianruDidDataReceived:(UIView *)view
                   dianruCode:(int)code{}


/*********************************************/
/*广告打开，如果view为空，那么表示加载广告失败      */
/*********************************************/
- (void)dianruDidViewOpen:(UIView *)view{
    [self stopTimer];
 
    if (view!=nil) {
        [adMoGoCore adapter:self didReceiveAdView:view];
    }else{
        [adMoGoCore adapter:self didFailAd:nil];
    }
}

/*********************/
/*点击关闭广告         */
/*不代表广告从内存中释放 */
/*********************/
- (void)dianruDidViewClose:(UIView *)view{}

/*********************/
/*从内存中销毁         */
/*********************/
- (void)dianruDidViewDestroy:(UIView *)view{
    
}

/*********************/
/*曝光回调            */
/*********************/
- (void)dianruDidReported:(UIView *)view
               dianruData:(id)data{
}

/*********************/
/*点击广告            */
/*********************/
- (void)dianruDidClicked:(UIView *)view
              dianruData:(id)data{
}

/*********************/
/*点击跳转            */
/*********************/
- (void)dianruDidJumped:(UIView *)view
             dianruData:(id)data{}




@end
