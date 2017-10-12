//
//  JumpWebViewController.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "BaseViewController.h"

@interface JumpWebViewController : BaseViewController

/**
 *  origin url
 */
@property (nonatomic)NSString* url;

@property (nonatomic, copy) NSString * WebTiltle;
/**
 *  tint color of progress view
 */
@property (nonatomic)UIColor* progressViewColor;
/**
 *  get instance with url
 *
 *  @param url url
 *
 *  @return instance
 */
-(instancetype)initWithUrl:(NSString *)url;


-(void)reloadWebView;

@end
