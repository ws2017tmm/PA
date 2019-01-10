//
//  NSDate+Compare.m
//  PAFinance
//
//  Created by 李响 on 2019/1/10.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)



//- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
//    NSDateFormatter *date = [[NSDateFormatter alloc]init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *startDate =[date dateFromString:startTime];
//    NSDate *endDdate = [date dateFromString:endTime];
//    
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:startDate toDate:endDdate options:0];
//    
//    // 天
//    NSInteger day = [dateComponents day];
//    // 小时
//    NSInteger house = [dateComponents hour];
//    // 分
//    NSInteger minute = [dateComponents minute];
//    // 秒
//    NSInteger second = [dateComponents second];
//    
//    NSString *timeStr;
//    
//    if (day != 0) {
//        timeStr = [NSString stringWithFormat:@"%zd天%zd小时%zd分%zd秒",day,house,minute,second];
//    }
//    else if (day==0 && house !=0) {
//        timeStr = [NSString stringWithFormat:@"%zd小时%zd分%zd秒",house,minute,second];
//    }
//    else if (day==0 && house==0 && minute!=0) {
//        timeStr = [NSString stringWithFormat:@"%zd分%zd秒",minute,second];
//    }
//    else{
//        timeStr = [NSString stringWithFormat:@"%zd秒",second];
//    }
//    
//    return timeStr;
//}

+ (long long)dateTimeDifferenceWithStartTime:(NSDate *)startDate endTime:(NSDate *)endDate {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    // 天
    NSInteger day = [dateComponents day];
    // 小时
    NSInteger house = [dateComponents hour];
    // 分
    NSInteger minute = [dateComponents minute];
    // 秒
    NSInteger second = [dateComponents second];
    
    NSInteger daySeconds = day*24*60*60;
    NSInteger houseSeconds = house*60*60;
    NSInteger minuteSeconds = minute*60;
    
    long long totalSeconds = daySeconds+houseSeconds+minuteSeconds+second;
    
    return totalSeconds;
}



@end
