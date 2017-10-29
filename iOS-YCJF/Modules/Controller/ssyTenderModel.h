//
//  ssyTenderModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/25.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ssyTenderModel : JSONModel

@property (nonatomic ,copy)NSString<Optional> *uid;
@property (nonatomic ,strong)NSString<Optional> *tender_sum; // 排行榜-年化投资额
@property (nonatomic ,copy)NSString<Optional> *mobile; // 排行榜-手机号
@property (nonatomic ,strong)NSString<Optional> *last_successtime; // 排行榜-投资时间
@property (nonatomic ,copy)NSString<Optional> *name; // 排行榜-奖品名称
@property (nonatomic ,strong)NSString<Optional> *nmb; // 排名

@end
