//
//  UIButton+Button.m
//  PAFinance
//
//  Created by StevenWu on 2019/1/8.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import "UIButton+Button.h"

@implementation UIButton (Button)

+ (instancetype)buttonWithTitle:(NSString *)title font:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)color target:(id)target selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
