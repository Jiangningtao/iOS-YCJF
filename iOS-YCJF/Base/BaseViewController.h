//
//  BaseViewController.h
//  YouLX
//
//  Created by king on 15/12/12.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef void(^SuspendPopViewBlock)();

@interface BaseViewController : UIViewController

@property (nonatomic, copy) SuspendPopViewBlock suspendPopBlock;

@property (nonatomic,strong)UIView *navView;
@property (nonatomic,strong)UIView *sepView;
@property (nonatomic,strong)UIImageView *backImageView;
//按钮
@property (nonatomic,strong)MyPicButton *backButton;
@property (nonatomic,strong)MyPicButton *rightButton;
@property (nonatomic,strong)MyPicButton *otherButton;
//标题
@property (nonatomic,strong)UIImageView *titleView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)MBProgressHUD *hud;
// 数据
@property (nonatomic, strong) NSDictionary * paramsBase;

//显示加载提示
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;
//显示加载完成提示
- (void)showHUDComplete:(NSString *)title;
//隐藏加载提示
- (void)hideHUD;

//自定义提示框
- (void)showTipView:(NSString *)tipStr;
//------默认的右边按钮-------
- (void)showRightBtn;
//------自定义的右边按钮(图片)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth;
//------自定义的右边按钮(文字)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor;
//------默认的返回按钮-------
- (void)showBackBtn;
-(void)NavBack;
- (void)showImgBackBtn; // 显示有图片的返回按钮
//------自定义的返回按钮(图片)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth;
//------自定义的返回按钮(文字)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor;
//------默认的其他按钮-------
- (void)showOtherBtn;

//按钮事件
- (void)navRightBtnClick:(UIButton *)button;
- (void)backClick:(UIButton *)button;
- (void)navOtherBtnClick:(UIButton *)button;

//分享
- (void)shareQQAndWechat:(NSString *)urlStr;
- (void)shareController:(NSString *)shareText withImage:(NSString *)shareImage;
- (void)shareSheetView:(NSString *)shareText withImage:(NSString *)shareImage;

// 活动
/**
 *  双十一活动悬浮窗
 */
- (void)showSuspendView;

@end
