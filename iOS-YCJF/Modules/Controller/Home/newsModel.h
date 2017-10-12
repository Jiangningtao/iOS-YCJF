//
//  newsModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/9.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface newsModel : JSONModel

// 新闻
@property (nonatomic ,copy)NSMutableString<Optional> *preview_pic;
@property (nonatomic ,copy)NSString<Optional> *title;
@property (nonatomic ,copy)NSString<Optional> *summary;
@property (nonatomic, copy) NSString<Optional> *news_id;
@property (nonatomic, copy) NSString<Optional> *publish_time;
@property (nonatomic, copy) NSNumber<Optional> *comment_num;
@property (nonatomic, copy) NSNumber<Optional> *view_num;

@end
