//
//  PAVideoController.h
//  GHMetroSupervision
//
//  Created by StevenWu on 2018/1/9.
//  Copyright © 2018年 StevenWu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TakeOperationSureBlock)(id item);

@interface PAVideoController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;
@property (nonatomic,assign) BOOL photographFlag; // 拍照标识 不可录像

@end
