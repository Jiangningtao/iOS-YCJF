//
//  GestureLockViewController.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/18.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "GestureLockViewController.h"
#import "YLSwipeLockView.h"

@interface GestureLockViewController ()<YLSwipeLockViewDelegate>
@property (nonatomic, weak) YLSwipeLockView *lockView;
@property (nonatomic, strong) NSString *passwordString;
@property (nonatomic, weak) UIButton *resetButton;

@end

@implementation GestureLockViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"设置你的手势密码";
    [MobClick beginLogPageView:self.title];
    [TalkingData trackPageBegin:self.title];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    [TalkingData trackPageEnd:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self NavBack];
    self.backImageView.backgroundColor = grcolor;
    
    [self configUI];
}

- (void)configUI
{
    YLSwipeLockView *lockView = [[YLSwipeLockView alloc] init];
    [self.view addSubview:lockView];
    [lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.centerX.offset(0);
        make.left.offset(40);
        make.right.offset(-40);
        make.height.offset(self.view.width -80);
        
    }];
    self.lockView = lockView;
    self.lockView.delegate = self;
}

-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    //    AppDelegate *myDelegate = GetAppDelegate;
    
    if (password.length < 4) {
        
        self.navigationItem.title = @"请至少连接4个点";
        self.passwordString = nil;
        [self performSelector:@selector(reset) withObject:nil afterDelay:2];
        return YLSwipeLockViewStateWarning;
        
        
    }
    
    if (self.passwordString == nil) {
        self.passwordString = password;
        self.navigationItem.title = @"请确认你的手势密码";
        return YLSwipeLockViewStateNormal;
    }else if ([self.passwordString isEqualToString:password]){
        self.navigationItem.title = @"设置成功";
        
        
        NSString *user = self.passwordString;
        NSLog(@"%@", user);
        NSUserDefaults *dUser = [NSUserDefaults standardUserDefaults];
        NSLog(@"旧手势:%@",  [dUser objectForKey:KGestureLock]);
        [dUser removeObjectForKey:KGestureLock];
        [dUser setObject:user forKey:KGestureLock];
        [dUser synchronize];
        //开启手势密码
        NSLog(@"手势密码设置成功, fuck:%@",  [dUser objectForKey:KGestureLock]);
        
        if ([self.lockDelegate respondsToSelector:@selector(resultOfSetLock:)]) {
            [self.lockDelegate resultOfSetLock:@"1"];   // 设置手势成功
        }
        
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
        return YLSwipeLockViewStateSelected;
    }else{
        self.navigationItem.title = @"两次输入不一致";
        self.resetButton.hidden = NO;
        return YLSwipeLockViewStateWarning;
    }
    
}

-(void)dismiss{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)reset
{
    self.passwordString = nil;
    self.navigationItem.title = @"设置你的手势密码";
    self.resetButton.hidden = YES;
}

- (void)cancelAction {
    if ([self.lockDelegate respondsToSelector:@selector(resultOfSetLock:)]) {
        [self.lockDelegate resultOfSetLock:@"2"];   // 设置手势失败
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
