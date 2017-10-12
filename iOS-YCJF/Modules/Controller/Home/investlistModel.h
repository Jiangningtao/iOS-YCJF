//
//  investlistModel.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/9.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface investlistModel : JSONModel

/**
 *  headpture = 0;
 "headpture_str" = "https://www.yinchenglicai.com/do.php?c=0199&id=";
 mobile = "139****8370";
 tze = "20000.00";
 uid = 249;
 */

@property (nonatomic ,copy)NSString<Optional> *headpture;
@property (nonatomic ,copy)NSString<Optional> *headpture_str;
@property (nonatomic, copy) NSString<Optional> *mobile;
@property (nonatomic, copy) NSString<Optional> *tze;
@property (nonatomic, copy) NSString<Optional> *uid;

@end
