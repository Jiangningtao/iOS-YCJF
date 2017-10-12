//
//  AppDelegate+AppService.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/8.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "AppDelegate.h"

#define ReplaceRootViewController(vc) [[AppDelegate shareAppDelegate] replaceRootViewController:vc]
/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)


//单例
+ (AppDelegate *)shareAppDelegate;
/**
 当前顶层控制器
 */

//分享功能
-(void)setShareSdk;

//友盟数据统计
- (void)umengAppAnalyticsSDK;

//talkingData数据统计
- (void)talkingDataAppAdTrackingSDK;
- (void)talkingDataAppAnalyticsSDK;

// 获取广告页图片url
- (void)getAdvertisementRequest;

-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;

@end
