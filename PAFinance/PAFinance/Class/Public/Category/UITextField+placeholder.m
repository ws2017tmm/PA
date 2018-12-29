//
//  UITextField+placeholder.m
//  BuDeJie2
//
//  Created by 李响 on 2018/11/1.
//  Copyright © 2018 ws. All rights reserved.
//

#import "UITextField+placeholder.h"
#import <objc/message.h>

@implementation UITextField (placeholder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
        Method setWs_PlaceholderMethod = class_getInstanceMethod(self, @selector(setWs_Placeholder:));
        
        method_exchangeImplementations(setPlaceholderMethod, setWs_PlaceholderMethod);
        
    });
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    // 给成员属性赋值 runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *label = [self valueForKeyPath:@"placeholderLabel"];
    // 设置占位文字的颜色
    label.textColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, @"placeholderColor");
}

// 设置占位文字
// 设置占位文字颜色
- (void)setWs_Placeholder:(NSString *)placeholder {
    [self setWs_Placeholder:placeholder];
    self.placeholderColor = self.placeholderColor;
}


/**
 设置占位文字的大小

 @param placeholderFont 占位文字的字体大小
 */
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    // 给成员属性赋值 runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeholderFont", placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *label = [self valueForKeyPath:@"placeholderLabel"];
    // 设置占位文字的颜色
    label.font = placeholderFont;
}

- (UIFont *)placeholderFont {
    return objc_getAssociatedObject(self, @"placeholderFont");
}

@end
