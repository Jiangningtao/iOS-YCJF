//
//  yaoqingjiluData.h
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yaoqingjiluData : NSObject
@property (nonatomic,copy)NSString *lastTenderAccount;
@property (nonatomic,copy)NSString *lastTenderBid;
@property (nonatomic,copy)NSString *lastTenderBname;
@property (nonatomic,copy)NSString *relation;
@property (nonatomic,copy)NSString *sc;
@property (nonatomic,copy)NSString *time_h;
@property (nonatomic,copy)NSString *time_z;
@property (nonatomic,copy)NSString *time_zc;
@property (nonatomic,copy)NSString *toubiao;
@property (nonatomic,copy)NSString *tuid;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *un;
@property (nonatomic,copy)NSString *uname;

+(id)transformFromDic:(id)data;
@end
