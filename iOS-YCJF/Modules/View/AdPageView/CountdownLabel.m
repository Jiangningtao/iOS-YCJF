//
//  CountdownLabel.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/8/24.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "CountdownLabel.h"

@interface CountdownLabel ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CountdownLabel

- (void)dealloc {
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isStop = NO;
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 16;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.userInteractionEnabled = YES;
        self.backgroundColor = color(0, 0, 0, 0.5);
        self.textAlignment = NSTextAlignmentCenter;
        self.text = @"跳过 3";
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:15];
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.layer.borderWidth = 1;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        
        
        _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(jumpNewViewController) userInfo:nil repeats:YES];
    }
    return self;
}

#pragma mark --- 响应倒计时的方法
- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    
    
    if (_isStop == YES) {
        
    } else {
        [_timer invalidate];
        _timer = nil;
        if (self.blockNewViewController) {
            self.blockNewViewController();
        }
    }
}

- (void)jumpNewViewController {
    static int z = 0;
    z ++;
    self.text = [NSString stringWithFormat:@"跳过 %d",3-z];
    
    if (_isStop) {
        
    } else {
        
        if (z == 3) {
            if (self.blockNewViewController) {
                [_timer invalidate];
                _timer = nil;
                self.blockNewViewController();
            }
        }
    }
}

@end
