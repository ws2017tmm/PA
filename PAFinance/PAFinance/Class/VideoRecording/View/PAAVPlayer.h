//
//  PAAVPlayer.h
//  GHMetroSupervision
//
//  Created by StevenWu on 2018/1/9.
//  Copyright © 2018年 StevenWu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PAAVPlayer : UIView

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url;

@property (copy, nonatomic) NSURL *videoUrl;

- (void)stopPlayer;

@end
