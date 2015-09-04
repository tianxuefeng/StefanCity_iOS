//
//  YQLSDK.h
//  UITest
//
//  Created by Wen Yunlong on 14-8-8.
//  Copyright (c) 2014年 YuJie. All rights reserved.
//

#import "BuildSubject.h"


#define DR_INSERSCREEN  3   //插播广告
#define DR_FULLSCREEN   4   //全屏广告
#define DR_BANNER       5   //BANNER

/**********************************************/
/*初始化接口，必须初始化                          */
/*key   :applicationKey                       */
/*value :是否开启定位                           */
/*userid:用户id一般游戏的角色id                  */
/**********************************************/
#define DR_INIT(key, isuse, userid) [YQLSDK dianruInitialize:key dianruLocation:isuse dianruAppuserid:userid];


/*****************************************************************/
/*显示广告                                                        */
/*type  :广告类型  类如 DR_OFFERWALL                               */
/*view  :广告的父试图，广告大小由传入的view来决定，所以你可以创建一个适合
 大小的view传进来。也可以在回调里直接设置广告view的frame，但是一定要关闭
 SDK自适应，因为当屏幕旋转或者从后台切到前台以后，广告frame又会通过parentView
 自适应，之前回调设置的frame也就随之失效，所以想要使用回调设置frame，请关闭
 自适应，可以使用DR_SHOW_AUTO宏来关闭自适应，具体请看demo               */
/*dg    : 代理人 实现一些回调用的 如果用不到 传空就行                   */
/*****************************************************************/
#define DR_SHOW(type, view, dg) [YQLSDK dianruShow:type dianruOn:view dianruDelegate:dg];

/*****************************************************************/
/*同上 区别在于上面默认自适应屏幕旋转，当前宏的第4个参数可以设置是否自适应   */
/*autoresize: true or false                                      */
/*****************************************************************/
#define DR_SHOW_AUTO(type, view, dg, autoresize) [YQLSDK dianruShow:type dianruOn:view dianruDelegate:dg dianruAutoresize:autoresize];


/**************************************************/
/*创建广告view，没有添加到parentView上，所以要在回调里保持
 广告view，防止广告view释放，然后在需要的地方再使用即可   */
/*type :广告类型  类如 DR_OFFERWALL                 */
/*dg: 代理人 实现一些回调用的 如果用不到 传空就行        */
/**************************************************/
#define DR_CREATE(type, dg) [YQLSDK dianruCreate:type dianruDelegate:dg];

/*****************************************************************/
/*同上 区别在于上面默认自适应屏幕旋转，当前宏的第4个参数可以设置是否自适应   */
/*autoresize: true or false                                      */
/*****************************************************************/
#define DR_CREATE_AUTO(type, dg, autoresize) [YQLSDK dianruCreate:type dianruDelegate:dg dianruAutoresize:autoresize];


/**********************************************/
/*获取总积分                                    */
/*result:总分数                                */
/**********************************************/
#define GETSCORE(score_block) [YQLSDK getDianruScore:score_block];


/**********************************************/
/*消费积分接口                                  */
/*point :消费多少积分                           */
/*result:如果成功返回true,否则false              */
/**********************************************/
#define SPENDSCORE(sore,score_block) [YQLSDK getDianruSpendScore:sore dianruCallback:score_block];


@protocol YQLDelegate <NSObject>
@optional

/****************************************************/
/*广告列表回调                                        */
/*view :广告view                                     */
/*code :广告条数大于0，那么code=0，代表成功 反之code = -1 */
/****************************************************/
- (void)dianruDidDataReceived:(UIView *)view dianruCode:(int)code;

/*********************/
/*广告创建成功         */
/*********************/
- (void)dianruDidViewOpen:(UIView *)view;


/*********************/
/*点击关闭广告         */
/*不代表广告从内存中释放 */
/*********************/
- (void)dianruDidViewClose:(UIView *)view;

/*********************/
/*广告彻底释放         */
/*从内存中删除         */
/*********************/
- (void)dianruDidViewDestroy:(UIView *)view;

/*********************/
/*曝光回调            */
/*********************/
- (void)dianruDidReported:(UIView *)view dianruData:(id)data;

/*********************/
/*点击广告            */
/*********************/
- (void)dianruDidClicked:(UIView *)view dianruData:(id)data;

/*********************/
/*点击跳转            */
/*********************/
- (void)dianruDidJumped:(UIView *)view dianruData:(id)data;

@end

typedef void (^dianruScoreResultCallback)(int result);
typedef void (^dianruSpendScoreResultCallback)(NSString *result);

@interface YQLSDK : NSObject<NSURLConnectionDelegate>

+(void)dianruInitialize:(NSString *)key dianruLocation:(BOOL)value dianruAppuserid:(NSString *)appuserid;
// 广告显示位置
+(void)dianruShow:(NSInteger)space dianruOn:(UIView *)view dianruDelegate:(id<YQLDelegate>)delegate;
+(void)dianruShow:(NSInteger)space dianruOn:(UIView *)view dianruDelegate:(id<YQLDelegate>)delegate dianruAutoresize:(BOOL)value;
//创建广告视图
+(void)dianruCreate:(NSInteger)space dianruDelegate:(id<YQLDelegate>)delegate dianruAutoresize:(BOOL)value;
+(void)dianruCreate:(NSInteger)space dianruDelegate:(id<YQLDelegate>)delegate;
//取得积分
+(void)getDianruScore:(dianruScoreResultCallback) score;
//消费积分
+(void)getDianruSpendScore:(int) point dianruCallback :(dianruSpendScoreResultCallback) score;
#pragma mark 获取积分/积分回调 callback ?

@end

