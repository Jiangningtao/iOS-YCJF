//
//  WWZShuju.m
//  KuaiDiZiXun
//
//  Created by 王文志 on 16/9/30.
//  Copyright © 2016年 XJB. All rights reserved.
//

#import "WWZShuju.h"
@interface WWZShuju(){
    
}
@end
@implementation WWZShuju


+(void)initlizedData:(NSString *)urlStr  paramsdata:(NSDictionary*)params  dicBlick:(void (^)(NSDictionary * info))dicBlick
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString   *string=[NSString    new];
    string=urlStr;
   
      [manager POST:string parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        manager.timeoutInterval=5.0;//设置请求超时为5秒
        
        
        //接受网络数据
          NSDictionary * info = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
          
          if (dicBlick) {
              dicBlick(info);
          }

           
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        NSLog(@"-------数据请求失败-------, %@", error);
        [MBProgressHUD hideHUD];
//        [MBProgressHUD showErrorMessage:@"数据请求失败！"];
        [self checkInternetMethod];
    }];


}

+ (void)checkInternetMethod
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 提示：要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您当前未连接网络或网络状态较差，请稍候重试！" delegate:self cancelButtonTitle:NSLocalizedString(@"好", @"Ok") otherButtonTitles:nil];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == -1) {
            
            [alertView show];
            NSLog(@"未识别网络");
        }
        if (status == 0) {
            
            NSLog(@"未连接网络");
            [alertView show];
        }
        if (status == 1) {
            
            NSLog(@"3G/4G网络");
//            [self showTipView:@"3G/4G网络"];
        }
        if (status == 2) {
            
            NSLog(@"Wifi网络");
//            [self showTipView:@"Wifi网络"];
        }
    }];
}



@end
