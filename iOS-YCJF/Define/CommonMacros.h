//
//  CommonMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/31.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//全局标记字符串，用于 通知 存储

#ifndef CommonMacros_h
#define CommonMacros_h

#pragma mark - ——————— 用户相关 ————————
/**
 *  uid   用户ID
 *  sid     SessionID
 *  at      AccessToken
 *  接口统一返回状态码r=-100010001，表示用户未登录或超时
 *  app_id  每个APP都分发唯一的app_id,值
 *  secret   密码
 *  salt   用户的密码加密字
 */
// 指纹解锁是否开启 开启为1，不开启为2
#define KTouchLock @"isTouchOpen"
#define KGestureLock @"isGestureLockOpen"   // 开启为手势密码， 不开启为2
// 用户帐号  手机号
#define KAccount @"telNumber"
#define KLoginPwd @"loginPassword"
#define KNewRegister @"newRegister"
#define KXshbmoney @"xshbmoney"   // 新手红包金额
// 是否为默认交易密码  是为1， 不是为0
#define KIs_defaultpaypass @"is_defaultpaypass"
#define KReal_status @"real_status"
#define KCurseq @"cur_seq"
#define KGetReal_status [UserDefaults objectForKey:KReal_status]
#define bfh @"%"
#define KIs_xs @"is_xs"
#define KIs_push  @"is_push"
// 用户基本信息模型
//#define KAccinfoModel @"accinfoModel"
// 是否余额可见   显示为1，不显示为0
#define KSecurytyshow @"securytyshow"

/**
 *  通知
 *
 *  @return 宏定义
 */
// 刷新我的信息
#define KNotificationRefreshMineDatas @"RefreshMineDatas"
// tabBar选择投资
#define KNotificationTabSelectInvest @"InvestTabBarClick"
// 刷新双十一界面
#define KNotificationTabSelectInvest @"InvestTabBarClick"

#if 0
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"


//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户model缓存
#define KUserModelCache @"KUserModelCache"
#endif


#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"

#endif /* CommonMacros_h */
