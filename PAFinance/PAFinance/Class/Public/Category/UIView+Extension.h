//
//  UIView+Extension.h
//  sinaWeibo
//
//  Created by XSUNT45 on 16/3/30.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property  float ws_x;
@property  float ws_y;
@property  float ws_width;
@property  float ws_height;

@property  float ws_centerX;
@property  float ws_centerY;

@property  float ws_bottomY;

@property  CGSize ws_size;
@property  CGPoint ws_origin;

+ (instancetype)viewFromXib;

@end
