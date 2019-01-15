//
//  AVCaptureDevice+Available.m
//  PAFinance
//
//  Created by 李响 on 2019/1/15.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import "AVCaptureDevice+Available.h"

@implementation AVCaptureDevice (Available)


/// 前面的摄像头是否可用
+ (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

/// 后面的摄像头是否可用
+ (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

///  摄像头的授权状态
+(BOOL)isCaptureVideoPermission {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]){
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            return NO;
        } else if (authStatus == AVAuthorizationStatusNotDetermined){
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            __block BOOL isGranted=YES;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                isGranted = granted;
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            return isGranted;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

@end
