//
//  yaoqingjiluData.m
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "yaoqingjiluData.h"

@implementation yaoqingjiluData
+(id)transformFromDic:(id)data{
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:0];
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *tempArr = data;
        for (NSDictionary *temp in tempArr) {
            yaoqingjiluData *yaoqin =[[yaoqingjiluData alloc] init];
            yaoqin.lastTenderAccount = [self justNull:temp[@"lastTenderAccount"]];
            yaoqin.lastTenderBid = [self justNull:temp[@"lastTenderBid"]];
            yaoqin.lastTenderBname = [self justNull:temp[@"lastTenderBname"]];
            yaoqin.relation = [self justNull:temp[@"relation"]];
            yaoqin.sc = [self justNull:temp[@"sc"]];
            yaoqin.time_h = [self justNull:temp[@"time_h"]];
            yaoqin.time_z = [self justNull:temp[@"time_z"]];
            yaoqin.time_zc = [self justNull:temp[@"time_zc"]];
            yaoqin.toubiao = [self justNull:temp[@"toubiao"]];
            yaoqin.tuid = [self justNull:temp[@"tuid"]];
            yaoqin.uid = [self justNull:temp[@"uid"]];
            yaoqin.un = [self justNull:temp[@"un"]];
            yaoqin.uname = [self justNull:temp[@"uname"]];
            yaoqin.money = [self justNull:temp[@"money"]];
            [resultArr addObject:yaoqin];
        }
    }
    return resultArr;
}
+(NSString*)justNull:(id)send{
    NSString *string;
    if ([send isKindOfClass:[NSNull class]]) {
        
        string = [NSString stringWithFormat:@""];
    }else{
        string = [NSString stringWithFormat:@"%@",send];
    }
    return string;
}
@end

