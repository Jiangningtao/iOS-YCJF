//
//  AppDelegate.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/8.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "AppDelegate.h"

#import "PushHandler.h"
#import "PUserDefault.h"
#import "ViewController.h"
#import "TabBarViewController.h"
#import "JumpViewController.h"
#import "TouchViewController.h"
#import "GestureViewController.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface AppDelegate ()<btnClickDelegate, UIAlertViewDelegate>

@property (nonatomic, strong, nullable) UIBlurEffect *blur;
@property (nonatomic, strong, nullable) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic) int timeCount;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UserDefaults setObject:@"0" forKey:KIs_push];
    [UserDefaults synchronize];
    [self setShareSdk];
    [self talkingDataAppAnalyticsSDK];
    [self talkingDataAppAdTrackingSDK];
    [self umengAppAnalyticsSDK];
    [self getAdvertisementRequest]; // 获取广告页图片地址
    [[XGSetting getInstance] enableDebug:YES];
    [XGPush startApp:2200265945 appKey:@"I26XQ37KTJ7J"];
    [XGPush isPushOn:^(BOOL isPushOn) {
        NSLog(@"[XGDemo] Push Is %@", isPushOn ? @"ON" : @"OFF");
    }];
    [self registerAPNS];
    [XGPush handleLaunching:launchOptions successCallback:^{
        NSLog(@"[XGDemo] Handle launching success");
    } errorCallback:^{
        NSLog(@"[XGDemo] Handle launching error");
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"===========pushInfo is %@==========", dictionary);
        [[PushHandler shareInstance] handlePush:dictionary];
    });
    
    //启动app---检查是否是首次启动此app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id haveOpen = [defaults objectForKey:@"firstOpen"];
    if (![haveOpen boolValue]) {
        ViewController *vc = [[ViewController alloc] init];
        vc.clickDelegate = self;
        self.window.rootViewController = vc;
        [defaults setValue:@"YES" forKey:@"firstOpen"];
    }else {
        NSLog(@"%@", [UserDefaults objectForKey:@"adImage"]);
        if ([[UserDefaults objectForKey:@"adImage"] length] > 0) {
            WS(weakSelf);
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.backgroundColor = [UIColor whiteColor];
            JumpViewController *jumpVC = [[JumpViewController alloc] init];
            jumpVC.blockMainViewController = ^{
                if ([[UserDefaults objectForKey:KTouchLock] isEqualToString:@"1"]&&[UserDefaults objectForKey:@"uid"]) {
                    TouchViewController * vc = [[TouchViewController alloc] init];
                    weakSelf.window.rootViewController = vc;
                }else if (![[UserDefaults objectForKey:KGestureLock] isEqualToString:@"2"]&&[UserDefaults objectForKey:@"uid"] && [UserDefaults objectForKey:KGestureLock]){
                    GestureViewController * vc = [[GestureViewController alloc] init];
                    weakSelf.window.rootViewController = vc;
                }else
                {
                    NSLog(@"KTouchLock:%@, KGestureLock:%@", [UserDefaults objectForKey:KTouchLock], [UserDefaults objectForKey:KGestureLock]);
                    TabBarViewController *GHTabBar = [[TabBarViewController alloc] init];
                    self.window.backgroundColor = [UIColor whiteColor];
                    weakSelf.window.rootViewController = GHTabBar;
                }
            };
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:jumpVC];
            self.window.rootViewController = nav;
            [self.window makeKeyAndVisible];
        }else
        {
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.backgroundColor = [UIColor whiteColor];
            if ([[UserDefaults objectForKey:KTouchLock] isEqualToString:@"1"]&&[UserDefaults objectForKey:@"uid"]) {
                TouchViewController * vc = [[TouchViewController alloc] init];
                self.window.rootViewController = vc;
            }else if (![[UserDefaults objectForKey:KGestureLock] isEqualToString:@"2"]&&[UserDefaults objectForKey:@"uid"] && [UserDefaults objectForKey:KGestureLock]){
                GestureViewController * vc = [[GestureViewController alloc] init];
                self.window.rootViewController = vc;
            }else
            {
                NSLog(@"KTouchLock:%@, KGestureLock:%@", [UserDefaults objectForKey:KTouchLock], [UserDefaults objectForKey:KGestureLock]);
                TabBarViewController *GHTabBar = [[TabBarViewController alloc] init];
                self.window.rootViewController = GHTabBar;
            }
            [self.window makeKeyAndVisible];
        }
        
    }
    
    return YES;
}

- (void)btnhaveClicked
{
    self.window.rootViewController = nil;
    for (UIView *view in self.window.subviews) {
        [view removeFromSuperview];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    TabBarViewController *GHTabBar = [[TabBarViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = GHTabBar;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    //添加毛玻璃效果
    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:self.blur];
    self.visualEffectView.frame = [UIScreen mainScreen].bounds;
    [self.window addSubview:self.visualEffectView];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
    int times = [PUserDefault getBackgroundEnterTimes];
    times ++;
    [PUserDefault saveBackgroundEnterTimes:times];
    
    if (([[UserDefaults objectForKey:KTouchLock] isEqualToString:@"1"]&&[UserDefaults objectForKey:@"uid"]) ||  (![[UserDefaults objectForKey:KGestureLock] isEqualToString:@"2"]&&[UserDefaults objectForKey:@"uid"] && [UserDefaults objectForKey:KGestureLock])) {
        self.timeCount = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:true];
        
        UIApplication*   app = [UIApplication sharedApplication];
        __block    UIBackgroundTaskIdentifier bgTask;
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid)
                {
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid)
                {
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        });
    }
    
}

- (void)timeRun{
    self.timeCount ++;
    NSLog(@"timeCount = %d",self.timeCount);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    int times = [PUserDefault getBackgroundEnterTimes];
//    if (times >= 5) {
//        // 提示用户开启push
//        [self showAlertPush];
//    }
    if (self.timeCount >= 120 && self.timer) {
        NSLog(@"时间到");
        if ([[UserDefaults objectForKey:KTouchLock] isEqualToString:@"1"]&&[UserDefaults objectForKey:@"uid"]) {
            TouchViewController * vc = [[TouchViewController alloc] init];
            self.window.rootViewController = vc;
        }else if (![[UserDefaults objectForKey:KGestureLock] isEqualToString:@"2"]&&[UserDefaults objectForKey:@"uid"] && [UserDefaults objectForKey:KGestureLock]){
            GestureViewController * vc = [[GestureViewController alloc] init];
            self.window.rootViewController = vc;
        }
        if (self.timer) {
            self.timeCount = 0;
            [self.timer invalidate];
            self.timer = nil;
        }
    }else
    {
        if (self.timer) {
            self.timeCount = 0;
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)showAlertPush
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请打开push权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开push", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UIView animateWithDuration:0.1 animations:^{
    } completion:^(BOOL finished) {
        [self.visualEffectView removeFromSuperview];
    }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"iOS_YCJF"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
