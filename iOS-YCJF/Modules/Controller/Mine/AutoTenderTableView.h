//
//  AutoTenderTableView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "BaseTableView.h"

@interface AutoTenderTableView : BaseTableView<UITextFieldDelegate>

@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, assign) BOOL isEditing;

@end
