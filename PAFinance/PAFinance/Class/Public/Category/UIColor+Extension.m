//
//  UIColor+Extension.m
//  PAFinance
//
//  Created by 李响 on 2018/12/27.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

/**
 根据16进制颜色字符串转换颜色(比如 0xff0000 字符串 -> UIColor)
 
 @param hexString 颜色字符串
 @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor blackColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    } else if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    } else if ([cString hasPrefix:@"0#"]) {
        cString = [cString substringFromIndex:2];
    } else if ([cString length] != 6) {
        return [UIColor blackColor];
    }
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
