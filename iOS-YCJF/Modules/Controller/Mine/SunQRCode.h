//
//  SunQRCode.h
//  OC_生成与读取二维码
//
//  Created by garday on 16/7/4.
//  Copyright © 2016年 garday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SunQRCode : NSObject
+(UIImage *)GenerateQRCode:(NSString *)string;
@end
