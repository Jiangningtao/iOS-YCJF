//
//  TopicModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/9.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TopicModel : JSONModel

@property (nonatomic ,copy)NSMutableString<Optional> *name;
@property (nonatomic ,copy)NSMutableString<Optional> *tender_account_min;
@property (nonatomic ,copy)NSMutableString<Optional> *days;
@property (nonatomic ,copy)NSString<Optional> *borrow_apr;
@property (nonatomic ,copy)NSMutableString<Optional> *bimg;
@property (nonatomic ,copy)NSMutableString<Optional> *borrow_period;
@property (nonatomic ,copy)NSMutableString<Optional> *classify;
@property (nonatomic, copy) NSString<Optional> * bid;

/**
 *  当利率大于：15%， apr_B 等于0时不拼，不等于0时拼上去
 */
@property (nonatomic ,copy)NSString<Optional> *apr_B;
@property (nonatomic ,strong)NSString <Optional>*apr_A;

@end
