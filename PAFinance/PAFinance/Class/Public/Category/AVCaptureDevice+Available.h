//
//  AVCaptureDevice+Available.h
//  PAFinance
//
//  Created by 李响 on 2019/1/15.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVCaptureDevice (Available)


/**
 前置摄像头是否可用
 */
+ (BOOL)isFrontCameraAvailable;

/**
 后置摄像头是否可用
 */
+ (BOOL)isRearCameraAvailable;


/**
 摄像头的授权状态
 */
+ (AVAuthorizationStatus)videoAuthStatus;

@end

NS_ASSUME_NONNULL_END
