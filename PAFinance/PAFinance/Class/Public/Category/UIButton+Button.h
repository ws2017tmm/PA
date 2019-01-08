//
//  UIButton+Button.h
//  PAFinance
//
//  Created by 李响 on 2019/1/8.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Button)

+ (instancetype)buttonWithTitle:(NSString *)title font:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)color target:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
