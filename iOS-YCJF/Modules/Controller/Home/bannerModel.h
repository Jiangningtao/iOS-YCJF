//
//  bannerModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/9.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface bannerModel : JSONModel

// 轮播图
/***flag ***/
@property (nonatomic ,copy)NSString<Optional> *flag;
/***图片id ***/
@property (nonatomic ,copy)NSString<Optional> *ImgID;
/*** 图片链接 ***/
@property (nonatomic ,copy)NSString<Optional> * img_url;
/***标题 ***/
@property (nonatomic ,copy)NSString<Optional> *title;
/** 链接 ***/
@property (nonatomic ,copy)NSString<Optional> *url;


// 分享事件
/** 内容 ***/
@property (nonatomic ,copy)NSString<Optional> *shareContent;
/** 图片 ***/
@property (nonatomic ,copy)NSString<Optional> *shareImg;
/** 标题 ***/
@property (nonatomic ,copy)NSString<Optional> *shareTitle;
/** URL ***/
@property (nonatomic ,copy)NSString<Optional> *shareAddressUrl;
/** 显示 ***/
@property (nonatomic ,copy)NSString<Optional> *isShow;




@end
