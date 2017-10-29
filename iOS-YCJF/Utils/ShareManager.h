//
//  ShareManager.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/10/27.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

+ (void)shareWithTitle:(NSString *)title Content:(NSString *)content ImageName:(NSString *)imgName Url:(NSString *)url;

@end
