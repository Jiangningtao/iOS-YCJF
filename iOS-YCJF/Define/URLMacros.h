//
//  URLMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//



#ifndef URLMacros_h
#define URLMacros_h


/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#if 1  // 测试时使用
#define preUrl   @"http://120.27.211.129/index_wx.php/"
#define guangUrl @"http://120.27.211.129/"
#endif

#if 0   // 实际上线时使用
#define preUrl   @"https://www.yinchenglicai.com/index_wx.php/"
#define guangUrl @"https://www.yinchenglicai.com/"
#endif

#define adimages [preUrl stringByAppendingString:@"App/images"]//首页
#define syurl [preUrl stringByAppendingString:@"App/tot"]//首页
#define syhdurl [preUrl stringByAppendingString:@"App/IndexAlertInfo"]//首页活动弹窗

#define tzurl [preUrl stringByAppendingString:@"App/blist"] //投资
#define xqurl [preUrl stringByAppendingString:@"App/binfo"] //投资详情
#define drurl [preUrl stringByAppendingString:@"App/login"] //登入注册
#define aturl [preUrl stringByAppendingString:@"Auth/accessToken"]
#define sidurl [preUrl stringByAppendingString:@"Auth/sid"]
#define versionurl [preUrl stringByAppendingString:@"App/version"] // 版本检测

//#define sidurl [preUrl stringByAppendingString:@"app/Auth/sid"]
#define tjmurl [preUrl stringByAppendingString:@"App/tuijian_rz"]//推荐码

#define zcmdurl [preUrl stringByAppendingString:@"App/register"]//注册
#define yzsjsfzcurl [preUrl stringByAppendingString:@"App/checkuser"]//验证手机是否注册
#define sjzcurl [preUrl stringByAppendingString:@"App/mrcode"]//手机注册验证码
#define sjzhyzmurl [preUrl stringByAppendingString:@"App/mrscode"]//手机找回交易密码验证码
#define scyhdzurl [preUrl stringByAppendingString:@"App/location"] //上传用户地址
#define jmurl [preUrl stringByAppendingString:@"App/getcd"] //用户登录密码的加密字
#define zhyzmurl [preUrl stringByAppendingString:@"App/mrcode_rect"]//发送手机验证码
#define yzsjyzmurl [preUrl stringByAppendingString:@"App/chkmrcode_rect"]//验证手机验证码
#define zhczmmurl [preUrl stringByAppendingString:@"App/mresetpwd"]//找回密码重置密码

#define Myurl [preUrl stringByAppendingString:@"App/myinfo"]//我的界面
#define tjhyurl [preUrl stringByAppendingString:@"App/sharetjr"] //推荐好友
#define yqjlurl [preUrl stringByAppendingString:@"App/myshareList"]//好友邀请记录
#define wdjlurl [preUrl stringByAppendingString:@"App/yqhy_jiangli"]//我的奖励

#define blburl [preUrl stringByAppendingString:@"App/tzlist"]//标列表

#define czjlurl [preUrl stringByAppendingString:@"App/payczlist"]//充值记录
#define txjlurl [preUrl stringByAppendingString:@"App/txapylist"]//提现记录


#define wdzdurl [preUrl stringByAppendingString:@"App/flowlist"]//我的账单

#define dszdurl [preUrl stringByAppendingString:@"App/GetRecoverGoing"]//代收账单
#define yszdurl [preUrl stringByAppendingString:@"App/GetRecoverHave"]//已收账单
#define myjjurl [preUrl stringByAppendingString:@"App/myTenderHongBao"]//我的奖劵
#define getTouziurl [preUrl stringByAppendingString:@"App/getTouziHongbao"]//购买标的页面-选择优惠券
#define ycjfgmxy [preUrl stringByAppendingString:@"App/jiekuanxieyi"]//购买协议

#define wdjfurl [preUrl stringByAppendingString:@"App/scorelist"]//我的积分
#define tzlburl [preUrl stringByAppendingString:@"App/chjf_tenderinfo"]//个人中心-投资记录-投资详情
#define yjfkurl [preUrl stringByAppendingString:@"App/feedback"]//个人中心-意见反馈
#define zdxqurl [preUrl stringByAppendingString:@"App/repaylistbiduid"]//代收账单详情

#define xgdrurl [preUrl stringByAppendingString:@"App/editpwd"]//修改登录密码
#define pdzfmmurl [preUrl stringByAppendingString:@"App/checkPayPw"]//判断交易密码接口
#define xgjymmrl [preUrl stringByAppendingString:@"App/cppasswd"]//修改交易密码接口
#define mmmsrl [preUrl stringByAppendingString:@"App/passsed"]//获取交易密码密钥


#define tbxxrl [preUrl stringByAppendingString:@"App/autocfg"]//自动投标查询
#define tbszrl [preUrl stringByAppendingString:@"App/autocfgsave"]//自动投标设置
#define gmburl [preUrl stringByAppendingString:@"App/tender"]//标列表
#define gmbxxxxurl [preUrl stringByAppendingString:@"App/getSimpleBinfo"]//购买标的页面
#define zfbdburl [preUrl stringByAppendingString:@"App/Bind_zfb"]//支付宝绑定
#define zcmxurl [preUrl stringByAppendingString:@"App/zhijin_Info"]//资产明细
#define zhczurl [preUrl stringByAppendingString:@"App/resetPaypwd_ch"]//找回密码重置密码接口

#define sctxurl [preUrl stringByAppendingString:@"App/UpHeadpic"]//上传头像
#define txsj [preUrl stringByAppendingString:@"App/getMyChannelBankList"]//提现页面加载数据
#define txyhksj [preUrl stringByAppendingString:@"App/txapy"]//提交银行卡提现申请操作
#define bktzkt [preUrl stringByAppendingString:@"App/zhuanketi"]// 不可提现转可提现操作
#define hqyhkxx [preUrl stringByAppendingString:@"App/getMyChannelBankList"]//获取银行卡信息操作
#define yhkcz [preUrl stringByAppendingString:@"App/txapy"]//银行卡快捷充值申请操作 提现到支付宝
#define zfbcz [preUrl stringByAppendingString:@"App/addZhifubaoApply"]//支付宝充值申请操作
#define smrzurl [preUrl stringByAppendingString:@"App/getChannelBankList"] // 实名认证银行卡和省份信息
#define rateurl [preUrl stringByAppendingString:@"App/rate"] // 获取转可提的rate

#define scsmrzurl [preUrl stringByAppendingString:@"App/doApiPayReq"] // 上传实名认证信息
#define qxscsmrzurl [preUrl stringByAppendingString:@"App/reReal"] // 取消认证
#define rzsjyzmurl [preUrl stringByAppendingString:@"App/phoneCode"]// 认证手机号验证码
#define mymessage [preUrl stringByAppendingString:@"App/MessageCenter"]// 我的消息
#define ycmessage [preUrl stringByAppendingString:@"App/getNewsList"]// 银程消息
#define markmessage [preUrl stringByAppendingString:@"App/MessageCenter_tag"]// 标记已读
#define ycmessageDetail [preUrl stringByAppendingString:@"App/getNewsInfo"]// 银程 动态详情

/**
 *  活动
 * 双十一（排行榜活动）index.php/ActivityApi/Doubule11Index
 */
#define ssyactivityurl [guangUrl stringByAppendingString:@"index.php/ActivityApi/Doubule11Index"]

/*
 应用内H5页面接口
 */
#define zxhdh5  @"https://www.yinchenglicai.com/ind/h5/rate_activite.html"    // 最新活动
#define ggzxh5  @"https://www.yinchenglicai.com/ind/h5/app/ggzx.html"    // 公告中心
#define xsflh5  @"https://www.yinchenglicai.com/ind/h5/app/act.html"    // 新手福利
#define ptjsh5  @"https://www.yinchenglicai.com/ind/aboutwe_2.html"     // 平台介绍
#define aqbzh5 @"https://www.yinchenglicai.com/ind/h5/app/safeguard.html"   // 安全保障
#define yybgh5  @"https://www.yinchenglicai.com/ind/h5/app/yyzx.html"    // 运营报告
#define hdzxh5  @"https://www.yinchenglicai.com/ind/h5/app/hdzx.html"    // 活动中心
#define gyych5  @"https://www.yinchenglicai.com/ind/h5/app/gych_1.html"    // 关于银程
#define bzzxh5  @"https://www.yinchenglicai.com/ind/h5/app/bzzx.html"    // 帮助中心
#define zfsmh5  @"https://www.yinchenglicai.com/ind/h5/app/zfsm.html"    // 资费说明
#define czsmh5  @"https://www.yinchenglicai.com/ind/h5/app/czsm.html"    // 充值限额
#define txsmh5  @"https://www.yinchenglicai.com/ind/h5/app/txsm.html"    // 提现说明
#define gzsmh5  @"https://www.yinchenglicai.com/ind/h5/app/zdtbsm.html"    // 规则说明
#define hdxqh5  @"https://www.yinchenglicai.com/ind/h5/app/act.html"    // 邀请活动详情
#define zcxyh5  @"https://www.yinchenglicai.com/ind/h5/app/zcxy.html"    // 注册协议
#define gmxyh5  @"https://www.yinchenglicai.com/ind/h5/app/gmxy.html"    // 购买协议
#define zczhh5  @"https://www.yinchenglicai.com/ind/h5/register.html"    // 注册帐号




#endif /* URLMacros_h */
