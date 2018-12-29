//
//  NSString+Extension.h
//  PAFinance
//
//  Created by 李响 on 2018/12/29.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

/**
 给身份证加密

 @return 加密后的身份证号
 */
- (NSString *)securyIdCardNumber;

@end

NS_ASSUME_NONNULL_END
