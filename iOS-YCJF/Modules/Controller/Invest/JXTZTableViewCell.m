//
//  JXTZTableViewCell.m
//  iOS-CHJF
//
//  Created by garday on 2017/3/8.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "JXTZTableViewCell.h"
#import "biaoModel.h"
@interface JXTZTableViewCell (){
   
}

/***<#注释#> ***/
@property (nonatomic ,copy)NSMutableArray *ImgVWArr;


@end

@implementation JXTZTableViewCell

-(NSMutableArray *)ImgVWArr{
    if (!_ImgVWArr) {
        _ImgVWArr = [[NSMutableArray alloc]init];
    }return _ImgVWArr;
}




-(void)setRst:(biaoModel *)rst{
    _rst = rst;
    _ptlab.text = [NSString stringWithFormat:@"%@",rst.name];
    _titlelab.text = @"";
    /*NSString *str =[NSString string];
    if ([rst.apr_B floatValue] == 0) {
        str = @"%";
         _BFBlab.text = [NSString stringWithFormat:@"%@ %@",rst.borrow_apr,str];
    }else
    {
        str = [NSString stringWithFormat:@"%@+%@%@", bfh, rst.apr_B, bfh];
         _BFBlab.text = [NSString stringWithFormat:@"%@ %@",rst.apr_A,str];
    }
    [self labStr:_BFBlab.text :_BFBlab];*/
    if ([rst.apr_B floatValue] == 0) {
        _BFBlab.text = [NSString stringWithFormat:@"%@%@",rst.borrow_apr, bfh];
        [self labStr:_BFBlab.text :_BFBlab];
    }else
    {
        _BFBlab.text = [NSString stringWithFormat:@"%ld%@+%ld%@",[rst.apr_A integerValue], bfh, [rst.apr_B integerValue], bfh];
        [self lab1Str:_BFBlab.text :_BFBlab];
    }
    
    if ([rst.days isEqualToString:@"0"]) {
        _monthLab.text = [NSString stringWithFormat:@"%@个月",rst.borrow_period];
    }else{
        _monthLab.text =[NSString stringWithFormat:@"%@ 天",rst.days];
    }
    [self labStr:_monthLab.text :_monthLab];
   _progress.progress  = [rst.borrow_account_scale floatValue] / 100.00;

    if (_progress.progress == 1.00){
        _zhuanchuLab.hidden = NO;
        _titlelab.textColor = [UIColor lightGrayColor];
        _ptlab.textColor = [UIColor lightGrayColor];
        _BFBlab.textColor = [UIColor lightGrayColor];
        _monthLab.textColor = [UIColor lightGrayColor];
        _progress.tintColor = [UIColor groupTableViewBackgroundColor];
        _progressLab.textColor = [UIColor lightGrayColor];
    }
    NSString *s = [NSString string];
    s = @"%";
    _progressLab.text = [NSString stringWithFormat:@"%@%@",rst.borrow_account_scale,s];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_progress setProgress:[rst.borrow_account_scale floatValue] / 100.00 animated:YES];
    });
    
    
   int isx = [rst.isxs intValue];
//    NSLog(@" ----qqq---%d",isx);
//     NSLog(@" ----www---%@",rst.flag);
    
    
    int mm = isx & 2;
    int new = isx & 16;
    int time = isx & 32;
    int way = isx & 128;
    
    
       
   
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    /*
        if (mm == 2 ) {
            [imgArr addObject:[UIImage imageNamed:@"lables_password"]];
        }else if (new  == 16){
            //新手
//            _dyimgV.image = [UIImage imageNamed:@"lables_new"];
            [imgArr addObject:[UIImage imageNamed:@"lables_new"]];
        }else if (time  == 32){
            //定时
//            _dyimgV.image = [UIImage imageNamed:@"icon_dingshi"];
            [imgArr addObject:[UIImage imageNamed:@"icon_dingshi"]];
        }else if (way  == 128){
            //定向
//            _dyimgV.image = [UIImage imageNamed:@"labels_directional"];
            [imgArr addObject:[UIImage imageNamed:@"labels_directional"]];
        }            if (rst.jiangli > 0) {//奖励标
            //空的 你大爷
//                _dyimgV.image = [UIImage imageNamed:@"lables_jiangli"];
            [imgArr addObject:[UIImage imageNamed:@"lables_new"]];
            }
        else{
        
        if (rst.days>0) {
                //天标
//                _dyimgV.image = [UIImage imageNamed:@"lables_day"];
             [imgArr addObject:[UIImage imageNamed:@"lables_day"]];
            }
            if ([rst.diyaType isEqualToString:@"1"]) {
                //质押
                
//                _dyimgV.image = [UIImage imageNamed:@"icon_zhiya"];
                 [imgArr addObject:[UIImage imageNamed:@"icon_zhiya"]];
            }
        else{
        /*   0 默认 信用标 ， 1 推荐标 ，2 快借标 ， 3 抵押标[ 有抵押物]， 4 秒标 5.体验标
                 8 流转标
                 */
    
    /*
                if ([rst.flag isEqualToString:@"0"]) {
//                    _dyimgV.image = [UIImage imageNamed:@"lables_credit"];
                     [imgArr addObject:[UIImage imageNamed:@"lables_credit"]];
                }else if ([rst.flag isEqualToString:@"1"]){
                    
                }else if ([rst.flag isEqualToString:@"2"]){
//                    _dyimgV.image = [UIImage imageNamed:@"labels_fast"];
                     [imgArr addObject:[UIImage imageNamed:@"labels_fast"]];
                }else if ([rst.flag isEqualToString:@"3"]){
//                    _dyimgV.image = [UIImage imageNamed:@"icon_diya"];
                     [imgArr addObject:[UIImage imageNamed:@"icon_diya"]];
                }else if ([rst.flag isEqualToString:@"4"]){
//                    _dyimgV.image = [UIImage imageNamed:@"lables_rcommended"];
                     [imgArr addObject:[UIImage imageNamed:@"lables_rcommended"]];
                }else if ([rst.flag isEqualToString:@"5"]){
//                    _dyimgV.image = [UIImage imageNamed:@"icon_tiyan"];
                     [imgArr addObject:[UIImage imageNamed:@"icon_tiyan"]];
                }else if ([rst.flag isEqualToString:@"8"]){
                    
                }
            }
            
        }
*/
   
    for (int i=0; i<imgArr.count; i++) {
        UIImageView *imgVW = [[UIImageView alloc]init];
        
        imgVW.image = (UIImage *)imgArr[i];
        
        [self addSubview:imgVW];
        [imgVW mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titlelab.mas_centerY);
            make.left.equalTo(_titlelab.mas_right).offset(5 + i *40 +i *10);
            make.width.offset(40);make.height.offset(17);
        }];
        [self.ImgVWArr addObject:imgVW];
    }
    
}



-(void)setUI{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.zhuanchuLab.layer.masksToBounds = YES;
    self.zhuanchuLab.layer.cornerRadius = self.zhuanchuLab.frame.size.width/2;
    
    
}
-(NSMutableAttributedString *)labStr :(NSString *)str :(UILabel *)lab{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSLog(@"%ld", str.length);
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:14.0]
                          range:NSMakeRange(str.length-1, 1)];
    lab.attributedText = AttributedStr;
    
    return AttributedStr;
}

-(NSMutableAttributedString *)lab1Str :(NSString *)str :(UILabel *)lab{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSLog(@"%ld", str.length);
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:17.0]
                          range:NSMakeRange(2, 2)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:17.0]
                          range:NSMakeRange(str.length-1, 1)];
    lab.attributedText = AttributedStr;
    
    return AttributedStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
