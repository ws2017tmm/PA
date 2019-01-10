//
//  PAVideoRecordController.h
//  GHMetroSupervision
//
//  Created by StevenWu on 2018/1/9.
//  Copyright © 2018年 StevenWu. All rights reserved.
//  视频录制界面

#import <UIKit/UIKit.h>

typedef void(^TakeOperationSureBlock)(id item);

@interface PAVideoRecordController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;
@property (nonatomic,assign) BOOL photographFlag; // 拍照标识 不可录像

@end
