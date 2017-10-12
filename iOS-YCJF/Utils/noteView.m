//
//  noteView.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/27.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "noteView.h"
@interface noteView()<UITextFieldDelegate>

@end
@implementation noteView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self) {
        
    self = [super initWithFrame:frame];
        
        [self addSubview:self.textfiled];
        [self.textfiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(45*widthScale);
            make.right.offset(-5);
            make.height.offset(38);
        }];
        
        [self addSubview:self.imgV];
        [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.centerX.offset(0);
            make.left.offset(30*widthScale);
            make.right.offset(-30*widthScale);
            make.height.offset(38);
        }];
    }
    return self;
}

-(UIImageView *)imgV
{
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"xuxiankuang")];
    }
    return _imgV;
}

-(UITextField *)textfiled{
    if (!_textfiled) {
        _textfiled = [[UITextField alloc]init];
        _textfiled.backgroundColor = [UIColor clearColor];
        _textfiled.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
        _textfiled.adjustsFontSizeToFitWidth = YES;
        //输入的文字颜色为白色
        _textfiled.textColor = [UIColor orangeColor];
      //  _textfiled.background =[UIImage imageNamed:@"xuxiankuang"];
        //输入框光标的颜色为白色
        _textfiled.tintColor = [UIColor clearColor];
        _textfiled.borderStyle =UITextBorderStyleNone;
        _textfiled.delegate = self;
      //  _textfiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textfiled.keyboardType = UIKeyboardTypeNumberPad;
      //  _textfiled.keyboardAppearance=UIKeyboardAppearanceAlert;
       // _textfiled.layer.borderColor = [[UIColor whiteColor] CGColor];
      //  _textfiled.layer.borderWidth = 1;
        _textfiled.leftViewMode = UITextFieldViewModeNever;
        _textfiled.clearButtonMode = UITextFieldViewModeNever;
        [_textfiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _textfiled;
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    //    NSLog(@"%@", textField.text);
   
    NSDictionary *attrsDictionary =@{
                                     NSFontAttributeName: textField.font,
                                     NSKernAttributeName:[NSNumber numberWithFloat:self.width/9*widthScale]//这里修改字符间距
                                     };
    textField.attributedText=[[NSAttributedString alloc]initWithString:textField.text attributes:attrsDictionary];
    
    
    if (textField.text.length == 6) {
        NSLog(@"输入完毕");
        if (self.blockEndEnter) {
            self.blockEndEnter(textField.text);
        }
        
        [textField endEditing:YES];
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= 6) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
