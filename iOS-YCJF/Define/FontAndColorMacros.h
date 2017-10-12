//
//  FontAndColorMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

/*
 UIKeyboardTypeDefault,       默认键盘，支持所有字符
 UIKeyboardTypeASCIICapable,  支持ASCII的默认键盘
 UIKeyboardTypeNumbersAndPunctuation,  标准电话键盘，支持＋＊＃字符
 UIKeyboardTypeURL,            URL键盘，支持.com按钮 只支持URL字符
 UIKeyboardTypeNumberPad,              数字键盘
 UIKeyboardTypePhonePad,     电话键盘
 UIKeyboardTypeNamePhonePad,   电话键盘，也支持输入人名
 UIKeyboardTypeEmailAddress,   用于输入电子 邮件地址的键盘
 UIKeyboardTypeDecimalPad,     数字键盘 有数字和小数点
 UIKeyboardTypeTwitter,        优化的键盘，方便输入@、#字符
 */


//字体大小和颜色配置

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h

#pragma mark -  颜色区
//主题色 导航栏颜色
//白色主题
//#define CNavBgColor  [UIColor colorWithHexString:@"ffffff"]
//#define CNavBgFontColor  [UIColor colorWithHexString:@"000000"]

//绿色主题
#define CNavBgColor  [UIColor colorWithHexString:@"00AE68"]
#define CNavBgFontColor  [UIColor colorWithHexString:@"ffffff"]

//默认页面背景色x
#define CViewBgColor [UIColor colorWithHexString:@"f2f2f2"]

//分割线颜色
#define CLineColor [UIColor colorWithHexString:@"ededed"]

//次级字色
#define CFontColor1 [UIColor colorWithHexString:@"1f1f1f"]

//再次级字色
#define CFontColor2 [UIColor colorWithHexString:@"5c5c5c"]


#pragma mark -  字体区


#define FFont1 [UIFont systemFontOfSize:12.0f]

#endif /* FontAndColorMacros_h */

