//
//  BidChooseDataPopview.h
//  TableHeadView
//
//  Created by 汤文洪 on 2017/3/30.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BidChooseDatePopview;

typedef void(^DismissBlock)();

@protocol ChooseDatePickDelegate <NSObject>
@optional
-(void)chooseDatewithDateStr:(NSString *)dateStr andView:(BidChooseDatePopview *)view;

@end



@interface BidChooseDatePopview : UIView

/** 关闭视图 */
@property (nonatomic, copy)DismissBlock block;
-(void)setBlock:(DismissBlock)block;

/**代理 */
@property (nonatomic,weak)id<ChooseDatePickDelegate>delegate;

/** 选择 */
@property (nonatomic, copy)NSArray *ChooseData;

@end
