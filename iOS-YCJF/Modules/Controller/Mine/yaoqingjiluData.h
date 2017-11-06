//
//  yaoqingjiluData.h
//  iOS-CHJF
//
//  Created by garday on 2017/4/11.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yaoqingjiluData : NSObject
@property (nonatomic,copy)NSString <Optional>*lastTenderAccount;
@property (nonatomic,copy)NSString <Optional>*lastTenderBid;
@property (nonatomic,copy)NSString <Optional>*lastTenderBname;
@property (nonatomic,copy)NSString <Optional>*relation;
@property (nonatomic,copy)NSString <Optional>*sc;
@property (nonatomic,copy)NSString <Optional>*time_h;
@property (nonatomic,copy)NSString <Optional>*time_z;
@property (nonatomic,copy)NSString <Optional>*time_zc;
@property (nonatomic,copy)NSString <Optional>*toubiao;
@property (nonatomic,copy)NSString <Optional>*tuid;
@property (nonatomic,copy)NSString <Optional>*uid;
@property (nonatomic,copy)NSString <Optional>*un;
@property (nonatomic,copy)NSString <Optional>*uname;
@property (nonatomic,copy)NSString <Optional>*money;

+(id)transformFromDic:(id)data;
@end
