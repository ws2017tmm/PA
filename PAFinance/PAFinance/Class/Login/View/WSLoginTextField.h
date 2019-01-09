//
//  WSTextField.h
//  BuDeJie2
//
//  Created by StevenWu on 2018/11/1.
//  Copyright © 2018 ws. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSLoginTextField : UITextField

// 当前的textField是否选中
@property (copy, nonatomic) void (^textFieldStateChanged)(BOOL isSelected);

@end

NS_ASSUME_NONNULL_END
