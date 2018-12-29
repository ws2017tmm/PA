//
//  PAUserModel.m
//  PAFinance
//
//  Created by 李响 on 2018/12/28.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "PAUserModel.h"

@implementation PAUserModel

WSSingletonM(UserModel)

/// 清除用户信息
+ (void)clearUserInfo {
    _instace = nil;
    onceToken = 0l;
}



@end
