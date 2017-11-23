//
//  AutoTenderTableView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/21.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "AutoTenderTableView.h"
#import "AutoTenderTFTableViewCell.h"
#import "AutoTenderModel.h"


@implementation AutoTenderTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AutoTenderTableView"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AutoTenderTableView"];
        }
        cell.textLabel.text = self.titleArray[indexPath.row];
        if (self.tabViewDataSource.count >= 2) {
            cell.detailTextLabel.text = self.tabViewDataSource[indexPath.row];
        }
        if (self.isEditing) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else{
        AutoTenderTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoTenderTFTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AutoTenderTFTableViewCell" owner:nil options:nil]lastObject];
        }
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
        lab.text = @"元";
        cell.inputTF.rightView = lab;
        cell.inputTF.delegate = self;
        cell.inputTF.rightViewMode = UITextFieldViewModeAlways;
        NSString * _moneyStr = self.tabViewDataSource[indexPath.row];
        if (self.isEditing) {
            cell.inputTF.enabled = YES;
            lab.textColor = [UIColor darkTextColor];
            cell.inputTF.text = [NSString stringWithFormat:@"%ld", [_moneyStr integerValue]];
        }else
        {
            cell.inputTF.enabled = NO;
            lab.textColor = [UIColor grayColor];
            cell.inputTF.placeholder = [NSString stringWithFormat:@"%ld", [_moneyStr integerValue]];
        }
        return cell;
    }
    
    return nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textChangeBlock) {
        self.textChangeBlock(textField.text);
    }
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"投资期限", @"预期收益率"];
    }
    return _titleArray;
}


@end
