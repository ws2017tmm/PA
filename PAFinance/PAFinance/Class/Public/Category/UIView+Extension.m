//
//  UIView+Extension.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/3/30.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

//x
- (void)setWs_x:(float)ws_x {
    
    CGRect frame = self.frame;
    frame.origin.x = ws_x;
    self.frame = frame;
}

-(float)ws_x{
    return self.frame.origin.x;
}

//y
- (void)setWs_y:(float)ws_y {
    CGRect frame = self.frame;
    frame.origin.y = ws_y;
    self.frame = frame;
}

-(float)ws_y{
    return self.frame.origin.y;
}

// bottomY
- (float)ws_bottomY {
    return self.ws_y + self.ws_height;
}

- (void)setWs_bottomY:(float)ws_bottomY {}

//width
- (void)setWs_width:(float)ws_width {
    CGRect frame = self.frame;
    frame.size.width = ws_width;
    self.frame = frame;
}

-(float)ws_width {
    return self.frame.size.width;
}

//height
- (void)setWs_height:(float)ws_height {
    CGRect frame = self.frame;
    frame.size.height = ws_height;
    self.frame = frame;
}

-(float)ws_height {
    return self.frame.size.height;
}

//centerX
-(void)setWs_centerX:(float)ws_centerX {
    CGPoint center = self.center;
    center.x = ws_centerX;
    self.center = center;
    
}

-(float)ws_centerX {
    return self.center.x;
}

//centerY
-(void)setWs_centerY:(float)ws_centerY {
    CGPoint center = self.center;
    center.y = ws_centerY;
    self.center = center;
    
}

-(float)ws_centerY {
    return self.center.y;
}

//size
- (void)setWs_size:(CGSize)ws_size {
    CGRect frame = self.frame;
    frame.size = ws_size;
    self.frame = frame;
}

- (CGSize)ws_size {
    return self.frame.size;
}

//origin
- (void)setWs_origin:(CGPoint)ws_origin {
    CGRect frame = self.frame;
    frame.origin = ws_origin;
    self.frame = frame;
}

- (CGPoint)ws_origin {
    return self.frame.origin;
}


+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}






@end
