//
//  WebViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/11.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "RegisterViewController.h"
#import "BiaoDetailViewController.h"
#import "TabBarViewController.h"
#import "TouchViewController.h"
#import "GestureViewController.h"
#import "yaoqinghyViewController.h"

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>
{
    WKUserContentController * userContentController;
    NSString * _shareAddressUrl;
    NSString * _shareTitle;
    NSString * _shareImg;
    NSString * _shareContent;
}
@property(nonatomic, strong) WKWebView *wkwebView;
@property (strong, nonatomic) UIProgressView *progressView;//这个是加载页面的进度条

@end

@implementation WebViewController

-(instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        self.url = url;
        _progressViewColor = [UIColor colorWithRed:119.0/255 green:228.0/255 blue:115.0/255 alpha:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWKWebView];
}
-(void)viewWillAppear:(BOOL)animated{
    [self initProgressView];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.title = self.WebTiltle;
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@+%@", self.title, self.url]];
    [TalkingData trackPageBegin:[NSString stringWithFormat:@"%@+%@", self.title, self.url]];
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(leftbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarbtn=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem=leftbarbtn;
    /*
    if ([self.url hasSuffix:[NSString stringWithFormat:@"h5/active/nataion.html?uid=%@", [UserDefaults objectForKey:@"uid"]]]) {
        self.title = @"活动";
        [self rightBarBtn:@"刷新" act:@selector(reloadWebView)];
    }else */if([self.bannerModel.isShow integerValue] == 1)
    {
        // 显示分享按钮
        [self rightBarBtn:@"分享" act:@selector(shareEvent)];
        //[self rightBarBtnImgN:@"share_black" act:@selector(shareEvent)];
    }
}

-(void)leftbtnclicked{
    if ([self.upVC isEqualToString:@"AdpageVC"]) {
        if ([[UserDefaults objectForKey:KTouchLock] isEqualToString:@"1"]&&[UserDefaults objectForKey:@"uid"]) {
            TouchViewController * vc = [[TouchViewController alloc] init];
            AppDelegateInstance.window.rootViewController = vc;
        }else if (![[UserDefaults objectForKey:KGestureLock] isEqualToString:@"2"]&&[UserDefaults objectForKey:@"uid"] && [UserDefaults objectForKey:KGestureLock]){
            GestureViewController * vc = [[GestureViewController alloc] init];
            AppDelegateInstance.window.rootViewController = vc;
        }else
        {
            NSLog(@"KTouchLock:%@, KGestureLock:%@", [UserDefaults objectForKey:KTouchLock], [UserDefaults objectForKey:KGestureLock]);
            TabBarViewController *GHTabBar = [[TabBarViewController alloc] init];
            AppDelegateInstance.window.rootViewController = GHTabBar;
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@+%@", self.title, self.url]];
    [TalkingData trackPageEnd:[NSString stringWithFormat:@"%@+%@", self.title, self.url]];
}
#pragma mark 初始化webview
-(void)initWKWebView
{
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];//先实例化配置类 以前UIWebView的属性有的放到了这里
    //注册供js调用的方法
    userContentController =[[WKUserContentController alloc]init];
    
    if (iOS8Later) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
    configuration.userContentController = userContentController;
    configuration.preferences.javaScriptEnabled = YES;//打开js交互
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) configuration:configuration];
    [self.view addSubview:_wkwebView];
    _wkwebView.backgroundColor = [UIColor clearColor];
    _wkwebView.allowsBackForwardNavigationGestures =YES;//打开网页间的 滑动返回
    _wkwebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    if (kiOS9Later) {
        _wkwebView.allowsLinkPreview = YES;//允许预览链接
    }
    _wkwebView.UIDelegate = self;
    _wkwebView.navigationDelegate = self;
    [_wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];//注册observer 拿到加载进度
    if ([_url hasSuffix:@"h5/active/nataion.html"]) {
        _url = [_url stringByAppendingString:[NSString stringWithFormat:@"?uid=%@", [UserDefaults objectForKey:@"uid"]]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_wkwebView loadRequest:request];
    
    
}

#pragma mark --这个就是设置的上面的那个加载的进度
-(void)initProgressView
{
    CGFloat progressBarHeight = 3.0f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    //        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight-0.5, navigaitonBarBounds.size.width, progressBarHeight);
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
    if (!_progressView || !_progressView.superview) {
        _progressView =[[UIProgressView alloc]initWithFrame:barFrame];
        _progressView.tintColor = [UIColor colorWithHexString:@"0485d1"];
        _progressView.trackTintColor = blue_color;
        
        [self.navigationController.navigationBar addSubview:self.progressView];
    }
}
//检测进度条，显示完成之后，进度条就隐藏了
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (object == self.wkwebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


#pragma mark - ——————— WKNavigationDelegate ————————
// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
// 当内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (self.WebTiltle.length == 0) {
        self.title = webView.title;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 //   [self updateNavigationItems];
}
// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:
(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"urlStr = %@", urlStr);
    if ([urlStr hasSuffix:@"h5/register.html"]) {
        
        RegisterViewController * registerVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if ([urlStr hasPrefix:[NSString stringWithFormat:@"%@ind/h5/product-detail.html", guangUrl]])
    {
        NSString * sepStr = @"?id=";
        NSArray * arr = [urlStr componentsSeparatedByString:sepStr];
        BiaoDetailViewController *ssc = [[BiaoDetailViewController alloc]init];
        ssc.idstr = arr[1];
        [self.navigationController pushViewController:ssc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if ([urlStr hasSuffix:@"h5/user/yqhy.html"])
    {
        yaoqinghyViewController *vc = [[yaoqinghyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSLog(@"00===%s", __FUNCTION__);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"Message: %@", message.body);
}


// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"100===%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:
                      UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          completionHandler();
                          
                      }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
}


// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView
runJavaScriptConfirmPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"101===%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"系统提示" message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                                  completionHandler(YES);
                                              }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                  completionHandler(NO);
                                              }]];
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}


// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView
runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
    defaultText:(nullable NSString *)defaultText
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"102===%s", __FUNCTION__);
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"textinput" message:@"JS调用输入框"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                  completionHandler([[alert.textFields lastObject] text]);
                                              }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


#pragma mark - update nav items

-(void)updateNavigationItems{
    if (self.wkwebView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        [self addNavigationItemWithTitles:@[@"返回",@"关闭"] isLeft:YES target:self action:@selector(leftBtnClick:) tags:@[@2000,@2001]];
        
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
        //iOS8系统下发现的问题：在导航栏侧滑过程中，执行添加导航栏按钮操作，会出现按钮重复，导致导航栏一系列错乱问题
        //解决方案待尝试：每个vc显示时，遍历 self.navigationController.navigationBar.subviews 根据tag去重
        //现在先把iOS 9以下的不使用动态添加按钮 其实微信也是这样做的，即便返回到webview的第一页也保留了关闭按钮
        
        if (kiOS9Later) {
            [self addNavigationItemWithTitles:@[@"返回"] isLeft:YES target:self action:@selector(leftBtnClick:) tags:@[@2001]];
        }
    }
}

-(void)leftBtnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 2000:
            [self.wkwebView goBack];
            break;
        case 2001:
            [self backBtnClicked];
            break;
        default:
            break;
    }
}

- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    //调整按钮位置
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width= -10;
    [items addObject:spaceItem];
    
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 0, 30, 20);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = SYSTEMFONT(16);
        [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)backBtnClicked
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)shareEvent
{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"share_ycjf"]];
    _shareContent = self.bannerModel.shareContent;
    _shareTitle = self.bannerModel.shareTitle;
    _shareAddressUrl = self.bannerModel.shareAddressUrl;
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        _shareContent = [_shareContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        _shareContent = [_shareContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_shareContent
                                         images:imageArray
                                            url:[NSURL URLWithString:_shareAddressUrl]
                                          title:_shareTitle
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [self showHUD:@"分享成功" de:1.0];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               [self showHUD:@"分享失败" de:1.0];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

-(void)reloadWebView{
    [self.wkwebView reload];
}
-(void)dealloc{
    [self clean];
}
#pragma mark ————— 清理 —————
-(void)clean{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.wkwebView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.wkwebView.UIDelegate = nil;
    self.wkwebView.navigationDelegate = nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
