//
//  PushHandler.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/9/25.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "PushHandler.h"
#import "WebViewController.h"
#import "myjiangzhuangViewController.h"
#import "touziViewController.h"

@implementation PushHandler

+ (instancetype) shareInstance
{
    static PushHandler * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [PushHandler new];
    });
    
    return instance;
}

- (void)handlePush:(NSDictionary *)info
{
    /**
     *  type = 1    url
     *  type = 2    收到优惠券，打开优惠券列表
     *  type = 3    标的复审回款，打开投资列表
     *  data = https://........
     */
    NSLog(@"%@, push = %@", info, [UserDefaults objectForKey:KIs_push]);
    NSString * type = info[@"type"];
    NSString * data = info[@"data"];
    if ([type isEqualToString:@"1"]) {
        WebViewController * vc = [WebViewController new];
        vc.url = data;
        vc.tabBarController.tabBar.hidden = YES;
        [self.baseController.navigationController pushViewController:vc animated:YES];
    }else if([type isEqualToString:@"2"])
    {
        myjiangzhuangViewController * vc = [myjiangzhuangViewController new];
        vc.tabBarController.tabBar.hidden = YES;
        [self.baseController.navigationController pushViewController:vc animated:YES];
    }else if([type isEqualToString:@"3"])
    {
        touziViewController * vc = [touziViewController new];
        vc.tabBarController.tabBar.hidden = YES;
        [self.baseController.navigationController pushViewController:vc animated:YES];
    }
}

@end
