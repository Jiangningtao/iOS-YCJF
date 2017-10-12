//
//  yesandnoViewController.h
//  iOS-CHJF
//
//  Created by garday on 2017/3/17.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xqModel.h"

@interface yesandnoViewController : UIViewController
/**是否成功*/
@property (nonatomic,assign)BOOL IsSuccess;
@property (nonatomic, copy) NSString * money;  //  交易金额
@property (nonatomic, copy) NSString * getMoney;    // 代收收益
@property (nonatomic, strong) xqModel * model; // 模型
@property (nonatomic, copy) NSString * shareAddress;    // 分享给好友的URL地址

@property (nonatomic, assign) BOOL isShowRedPacket;
@property (nonatomic, copy) NSString * moneyOfRedPacket;

@end
