//
//  WebViewController.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/11.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "BaseViewController.h"
#import "bannerModel.h"

@interface WebViewController : BaseViewController

@property (nonatomic, strong) bannerModel * bannerModel;

/**
 *  origin url
 */
@property (nonatomic, copy) NSString * upVC;
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
