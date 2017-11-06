//
//  ssyNewUserModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/2.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ssyNewUserModel : JSONModel

@property (nonatomic ,copy)NSString<Optional> *msg; // 提示信息
@property (nonatomic ,copy)NSString<Optional> *ifshow; // 是否显示
@property (nonatomic ,copy)NSString<Optional> *ico; // 小图标
@property (nonatomic ,copy)NSString<Optional> *title; // 文案标题
@property (nonatomic ,copy)NSString<Optional> *banner; // 文案banner
@property (nonatomic ,copy)NSString<Optional> *content; // 文案内容
@property (nonatomic, copy) NSString<Optional> * btn; // 按钮内容
@property (nonatomic, copy) NSString<Optional> * bid; // 投资跳转标的id

/**
 @property (nonatomic ,copy)NSString<Optional> *share_content; // 分享内容
 @property (nonatomic ,copy)NSString<Optional> *share_title; // 分享标题
 @property (nonatomic ,copy)NSString<Optional> *share_url; // 分享网址
 */

@end
