//
//  NSString+Extension.m
//  PAFinance
//
//  Created by 李响 on 2018/12/29.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 给身份证加密
 
 @return 加密后的身份证号
 */
- (NSString *)securyIdCardNumber {
    NSUInteger length = self.length - 7;
    NSRange range = NSMakeRange(3, length);
    
    NSMutableString *replaceStr;
    for (int i = 0; i < length; i++) {
        [replaceStr appendString:@"*"];
    }
    NSString *securyIDStr = [self stringByReplacingCharactersInRange:range withString:@"*******"];
    return securyIDStr;
}

@end
