//
//  PAProgressView.h
//  GHMetroSupervision
//
//  Created by StevenWu on 2018/1/9.
//  Copyright © 2018年 StevenWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAProgressView : UIView

@property (assign, nonatomic) NSInteger timeMax;

- (void)clearProgress;

@end
