//
//  Constants.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//基本操作
#define boldSystemFont(size)  [UIFont boldSystemFontOfSize:size]
#define systemFont(size)      [UIFont systemFontOfSize:size]
#define isIOS7                [[UIDevice currentDevice].systemVersion doubleValue]>=7.0?YES:NO
#define SYSTEM_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue]
#define STATUSBAR_HEIGHT      [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVBAR_HEIGHT         (44.f + ((SYSTEM_VERSION >= 7) ? STATUSBAR_HEIGHT : 0))

//
#define baseTableViewIdentifier @"BaseTableView"

// common
#define UserDefaults          [NSUserDefaults standardUserDefaults]
#define AppDelegateInstance ((AppDelegate*)([UIApplication sharedApplication].delegate))

#define IsStringEmpty(string) (!string || [@"" isEqualToString:string])
#define IsStringNotEmpty(string) (string && ![@"" isEqualToString:string])
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

// 系统的版本判断
#define kSysVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define iOS8Later (kSysVersion >= 8.0f)
#define iOS7Later (kSysVersion >= 7.0f)
#define iOS6Later (kSysVersion >= 6.0f)

#define iOS7 (kSysVersion >= 7.0f && kSysVersion < 8.0f)

#define color(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
//图片宽度
#define pic_width (screen_width-5*4-10*2)/5
//背景颜色
#define background_color color(244, 244, 244, 1)
//app默认橙色
#define pink_color color(238, 109, 140, 1)
#define blue_color color(70, 150, 252, 1)
#define red_color color(247, 43, 43, 1)
#define  gracolor   color(217, 217, 217, 1)
#define  grcolor   color(244, 244, 244, 1)
#define   lancolor   color(57, 150, 223, 1)
//文本颜色
#define default_text_color color(57, 57, 70, 1)
//navBar颜色
#define navBar_color color(67, 89, 224, 1)
//tabBar颜色
#define tabBar_color color(255, 255, 255, 1)
#define   tabBar_SelectedColor color(57, 149, 223, 1)
//边框颜色
#define pic_borderColor color(229, 229, 229, 1)
//分割线颜色
#define sepline_color color(242, 242, 242, 1)
//广告视图高度
#define adver_picHeight 150

#define imageView_width 50

#define CHTopSpace (WTScreenHeight == 812.0 ? 44 : 16)
#define CHTitileViewH 44
#define CHPasswordViewH (WTScreenHeight == 812.0 ? 500 : 450)
#define CHTitileViewY (WTScreenHeight == 812.0 ? 88 : 66)

#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define AppDelegateInstance ((AppDelegate*)([UIApplication sharedApplication].delegate))

// 判断输入是否为数字和字母的 密码正则表达式
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define Kshuzi @"0123456789"

// 是否通知
#define NOTIFICATION @"notification"   //
#define GetNotificationStatus [UserDefaults objectForKey:NOTIFICATION]

#endif /* Constants_h */
