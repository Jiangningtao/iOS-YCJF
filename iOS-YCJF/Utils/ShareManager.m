//
//  ShareManager.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/27.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager

+ (void)shareWithTitle:(NSString *)title Content:(NSString *)content ImageName:(NSString *)imgName Url:(NSString *)url
{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:imgName]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSString * _shareContent = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        _shareContent = [_shareContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_shareContent
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               //[self showHUD:@"分享成功" de:1.0];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               //[self showHUD:@"分享失败" de:1.0];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}

@end
