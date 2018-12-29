//
//  WSLoginTextField.m
//  BuDeJie2
//
//  Created by 李响 on 2018/11/1.
//  Copyright © 2018 ws. All rights reserved.
//

#import "WSLoginTextField.h"
#import "UITextField+placeholder.h"

@implementation WSLoginTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置光标的颜色
    self.tintColor = UIColor.whiteColor;
    
    // 占位文字的颜色
    self.placeholderColor = UIColor.lightGrayColor;
//    UILabel *label = [self valueForKeyPath:@"placeholderLabel"];
//    label.textColor = UIColor.lightGrayColor;
    
}

// 开始编辑
- (BOOL)becomeFirstResponder {
    
//    UILabel *label = [self valueForKeyPath:@"placeholderLabel"];
//    label.textColor = UIColor.whiteColor;
    self.placeholderColor = UIColor.whiteColor;
    
    if (self.textFieldStateChanged) {
        self.textFieldStateChanged(YES);
    }
    
    return [super becomeFirstResponder];
    
}

// 结束编辑
- (BOOL)resignFirstResponder {
    
//    UILabel *label = [self valueForKeyPath:@"placeholderLabel"];
//    label.textColor = UIColor.lightGrayColor;
    self.placeholderColor = UIColor.lightGrayColor;
    
    if (self.textFieldStateChanged) {
        self.textFieldStateChanged(NO);
    }
    return [super resignFirstResponder];
}


@end
