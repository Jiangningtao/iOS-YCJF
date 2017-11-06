//
//  AppDelegate+AppService.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/8.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "ViewController.h"
#import "TabBarViewController.h"

#import "ShareSDK/ShareSDK.h"
#import "ShareSDKConnector/ShareSDKConnector.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import "TencentOpenAPI/TencentOAuth.h"
#import "TencentOpenAPI/QQApiInterface.h"
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

@implementation AppDelegate (AppService)


+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//分享功能
-(void)setShareSdk{
    [ShareSDK registerApp:ShareSdk_id
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeSMS)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         case SSDKPlatformTypeSMS:
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:WB_Key
                                                appSecret:WB_Secret
                                              redirectUri:WB_redirectUri
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:WX_Key
                                            appSecret:WX_Secret];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:QQ_Key
                                           appKey:QQ_Secret                                         authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeSMS:
                      break;
                  default:
                      break;
              }
          }];
    
}

- (void)umengAppAnalyticsSDK
{
    UMConfigInstance.appKey = @"59571f3782b6356ae6000101";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)talkingDataAppAdTrackingSDK
{
    //channelId为渠道跟踪ID，如果在Appstore官方市场上架，channelID 必须设置为AppStore 避免系统误判为其他第三方市场数据，如果在国内第三方应用市场，或者越狱市场上架，请按照系统生成的ID为准!
    [TalkingDataAppCpa init:@"6D3805411FAD4541856357645862A4D5" withChannelId:@"AppStore"];
}

- (void)talkingDataAppAnalyticsSDK
{
    // App ID: 在 App Analytics 创建应用后，进入数据报表页中，在“系统设置”-“编辑应用”页面里查看App ID。
    // 渠道 ID: 是渠道标识符，可通过不同渠道单独追踪数据。
    [TalkingData sessionStarted:@"E2A05D254ABD418F96264982C46BDD06" withChannelId:@"AppStore"];
    // YES: 开启自动捕获 自动获取异常信息
    // NO: 关闭自动捕获
    [TalkingData setExceptionReportEnabled:YES];
}

- (void)getAdvertisementRequest
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(concurrentQueue, ^{
            //获得开机画面
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"at"]) {
                NSDictionary *parameters = @{ @"device":@"2",
                                              @"flag": @"4",
                                              @"has_flash":@"1",
                                              @"flash_policy": @"rand"
                                              };
                
                NSString * paramsStr = [[NSString alloc] init];
                for (int i = 0; i < parameters.allKeys.count; i++) {
                    paramsStr = [paramsStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", parameters.allKeys[i], parameters.allValues[i]]];
                }
                NSLog(@"%@?%@", adimages, paramsStr);
                [WWZShuju initlizedData:adimages paramsdata:parameters dicBlick:^(NSDictionary *info) {
                    
                    NSLog(@"%@", info);
                    if ([info[@"r"] integerValue] == 1) {
                        // 请求成功
                        id data = info[@"flash"];
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:data[@"img_url"] forKey:@"adImage"];
                            [UserDefaults setObject:data[@"url"] forKey:data[@"img_url"]];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            NSLog(@"adImage:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"adImage"]);
                        }
                    }else
                    {
                        NSLog(@"请求广告页图片失败");
                    }
                }];
                
            }
        });
    });
}

-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

@end
