//
//  NSDate+Compare.h
//  PAFinance
//
//  Created by 李响 on 2019/1/10.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Compare)

//- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/// 两个时间相差多少秒
+ (long long)dateTimeDifferenceWithStartTime:(NSDate *)startDate endTime:(NSDate *)endDate;

@end

NS_ASSUME_NONNULL_END
