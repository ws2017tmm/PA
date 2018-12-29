//
//  UIColor+Extension.h
//  PAFinance
//
//  Created by 李响 on 2018/12/27.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

/**
 根据16进制颜色字符串转换颜色(比如 0xff0000 字符串 -> UIColor)
 
 @param hexString 颜色字符串
 @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
