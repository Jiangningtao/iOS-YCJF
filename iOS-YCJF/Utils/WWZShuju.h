//
//  WWZShuju.h
//  KuaiDiZiXun
//
//  Created by 王文志 on 16/9/30.
//  Copyright © 2016年 XJB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWZShuju : NSObject
+(void)initlizedData:(NSString *)urlStr  paramsdata:(NSDictionary*)params  dicBlick:(void (^)(NSDictionary * info))dic;

@end
