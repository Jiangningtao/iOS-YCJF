//
//  MineItemModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/17.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MineItemModel : JSONModel
/**
 *"avatar_url" = "https://www.yinchenglicai.com/do.php?c=0199&id=4708708c-79b2-11e7-8ce4-00163e13911e";
 *"email_status" = 0;
* headpture = 72;
* "is_defaultpaypass" = 0;
* "is_new" = 1;
* mobile = 18365208214;
* "mobile_hidden" = "183******14";
 "mobile_status" = 2;
* "msg_unread_num" = 3;
* personid = 431126199405198416;
* "personid_hidden" = "4311**********8416";
* "real_status" = 2;
* score = 0;
* "score_s" = 0;
* "score_seq" = 5;
* "score_use" = 0;
* scoreall = 4;
* tguid = 0;
* "uc_id" = 48864;
* un = 18365208214;
* uname = "\U59dc\U5b81\U6843";
* "uname_hidden" = "\U59dc********";
* "uname_kefu" = "";
* "vip_end_date" = "2018-01-26";
 * "vip_status" = 1;
 * zfb = 18365208214;
 */

@property (nonatomic ,copy)NSString<Optional> *avatar_url;  // 用户头像地址
@property (nonatomic ,copy)NSString<Optional> *email_status;
@property (nonatomic ,copy)NSString<Optional> *headpture; // 等于0，使用默认头像，否则使用自己的头像
@property (nonatomic ,copy)NSString<Optional> *is_defaultpaypass;   // 是否是默认交易密码 0不是 1是
@property (nonatomic ,copy)NSString<Optional> *mobile;  // 手机号

@property (nonatomic ,copy)NSString<Optional> *is_new;
@property (nonatomic ,copy)NSString<Optional> *mobile_hidden;   // 手机号  部分信息隐藏的
@property (nonatomic ,copy)NSString<Optional> *msg_unread_num;
@property (nonatomic ,copy)NSString<Optional> *personid;    // 身份证号
@property (nonatomic ,copy)NSString<Optional> *personid_hidden;     //身份证号  部分信息隐藏

@property (nonatomic ,copy)NSString<Optional> *real_status;     // 判断是否认证   0未认证    1认证中    2已认证
@property (nonatomic ,copy)NSString<Optional> *score;
@property (nonatomic ,copy)NSString<Optional> *score_s;
@property (nonatomic ,copy)NSString<Optional> *score_seq;
@property (nonatomic ,copy)NSString<Optional> *score_use;

@property (nonatomic ,copy)NSString<Optional> *scoreall;
@property (nonatomic ,copy)NSString<Optional> *tguid;
@property (nonatomic ,copy)NSString<Optional> *uc_id;
@property (nonatomic ,copy)NSString<Optional> *un;
@property (nonatomic ,copy)NSString<Optional> *uname;   // 用户名

@property (nonatomic ,copy)NSString<Optional> *uname_hidden;    // 用户名  部分信息隐藏
@property (nonatomic ,copy)NSString<Optional> *uname_kefu;
@property (nonatomic ,copy)NSString<Optional> *vip_end_date;
@property (nonatomic ,copy)NSString<Optional> *vip_status;
@property (nonatomic ,copy)NSString<Optional> *zfb;     // 支付宝帐号

@property (nonatomic ,copy)NSString<Optional> *mobile_status;
@property (nonatomic, copy) NSString<Optional> * ifxs;  // 是否新手  1 是， 0 不是

@end
