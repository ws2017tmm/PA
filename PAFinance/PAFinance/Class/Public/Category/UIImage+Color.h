//
//  UIImage+Color.h
//  PAFinance
//
//  Created by StevenWu on 2018/12/28.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

/**
 根据颜色返回一张图片
 
 @param color 颜色
 @return 返回的图片
 */
+ (UIImage*)imageWithColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
