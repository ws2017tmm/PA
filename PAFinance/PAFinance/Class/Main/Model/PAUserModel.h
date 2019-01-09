//
//  PAUserModel.h
//  PAFinance
//
//  Created by StevenWu on 2018/12/28.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface PAUserModel : NSObject

WSSingletonH(UserModel)

// 一些属性

/// 用户的唯一标识
@property (copy, nonatomic) NSString *ID;

/// 电话号码
@property (copy, nonatomic) NSString *phoneNumber;

/// 是否认证过CA
@property (assign, nonatomic, getter=isCAVerified) BOOL CAVerified;

/// 公司名称
@property (copy, nonatomic) NSString *companyName;

/// 法人名字
@property (copy, nonatomic) NSString *legalPersonName;

/// 身份证号码
@property (copy, nonatomic) NSString *idCardNumber;

/// ...


/// 清除用户信息
+ (void)clearUserInfo;

@end

NS_ASSUME_NONNULL_END
