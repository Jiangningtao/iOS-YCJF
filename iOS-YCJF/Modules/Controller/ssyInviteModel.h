//
//  ssyInviteModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/2.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ssyInviteModel : JSONModel


@property (nonatomic ,copy)NSString<Optional> *tjrurl; // 推荐人二维码链接
@property (nonatomic ,copy)NSString<Optional> *tjrnumber; // 推荐码
@property (nonatomic ,copy)NSString<Optional> *tjrcount; // 已邀请人数
@property (nonatomic ,copy)NSString<Optional> *tjrmoney; // 已获得奖励金额
@property (nonatomic ,copy)NSString<Optional> *adopt; // 符合条件的人数
@property (nonatomic ,copy)NSString<Optional> *rule; // 活动规则
@property (nonatomic, copy) NSString<Optional> * txt; // 进度描述

// 活动分享
@property (nonatomic ,copy)NSString<Optional> *share_content; // 分享内容
@property (nonatomic ,copy)NSString<Optional> *share_title; // 分享标题
@property (nonatomic ,copy)NSString<Optional> *share_url; // 分享网址

// 邀请好友注册分享
@property (nonatomic ,copy)NSString<Optional> *share_content_ext; // 分享内容
@property (nonatomic ,copy)NSString<Optional> *share_title_ext; // 分享标题
@property (nonatomic ,copy)NSString<Optional> *share_url_ext; // 分享网址

@end
