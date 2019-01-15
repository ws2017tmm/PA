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
+ (AVAuthorizationStatus)videoAuthStatus {
    // 读取媒体类型
    NSString *mediaType = AVMediaTypeVideo;
    
    //读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    return authStatus;
}

@end
