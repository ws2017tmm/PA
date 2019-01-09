//
//  UIImage+Color.m
//  PAFinance
//
//  Created by StevenWu on 2018/12/28.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

/**
 根据颜色返回一张图片
 
 @param color 颜色
 @return 返回的图片
 */
+ (UIImage*)imageWithColor:(UIColor*)color {
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
