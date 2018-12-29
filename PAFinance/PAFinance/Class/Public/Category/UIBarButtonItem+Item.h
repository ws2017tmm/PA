//
//  UIBarButtonItem+Item.h
//  BuDeJie2
//
//  Created by wusheng on 2018/10/23.
//  Copyright © 2018年 ws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

// 快速创建UIBarButtonItem

/**
 快速创建UIBarButtonItem

 @param image normal图片
 @param highImage high图片
 @param target 监听器
 @param action 方法
 @return UIBarButtonItem的实例对象
 */
+ (UIBarButtonItem *)itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;


/**
 快速创建(带文字和图片)UIBarButtonItem
 */
+ (UIBarButtonItem *)backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;

@end
