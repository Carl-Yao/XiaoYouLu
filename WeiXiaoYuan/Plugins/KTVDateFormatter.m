//
//  KTVDateFormatter.m
//  kugou
//
//  Created by fairzy on 14-7-17.
//  Copyright (c) 2014年 kugou. All rights reserved.
//

#import "KTVDateFormatter.h"

@implementation KTVDateFormatter

+ (NSString *)formatSecondToTimeIntervalString:(NSTimeInterval)second{
    second = second/1000;
    NSString * formattedTime = nil;
    NSDate * nowDate = [NSDate date];
    double nowsecond = [nowDate timeIntervalSince1970];
    double timenum = nowsecond - second;
    
    // 前天和昨天的分界线放入cursor
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * component = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:nowDate];
    NSTimeInterval secondGap = component.hour * 3600 + component.minute * 60 + component.second;
    NSTimeInterval cursor = nowsecond - secondGap - 24 * 3600;
    

    if (timenum < 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSDateComponents * component = [calendar components:NSYearCalendarUnit fromDate:date];
        NSDateComponents * nowComponent = [calendar components:NSYearCalendarUnit fromDate:nowDate];
        NSDateFormatter * outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        if ( component.year == nowComponent.year  ) {
            [outputFormatter setDateFormat:@"M月d日 HH:mm"];
            formattedTime = [outputFormatter stringFromDate:date];
        }else{
            [outputFormatter setDateFormat:@"yyyy年 M月d日 HH:mm"];
            formattedTime = [outputFormatter stringFromDate:date];
            
        }
    }
    else if ( timenum < 60 ) {
        formattedTime = @"刚刚";
    }else if( timenum < 3600) {
        int num = timenum/60;
        if (num <= 0) {
            num = 1;
        }
        formattedTime = [NSString stringWithFormat:@"%d分钟前",num];
    }
    else if ( timenum < secondGap ) {
        int num = timenum/3600;
        if (num <= 0) {
            num = 1;
        }
        formattedTime = [NSString stringWithFormat:@"%d小时前",num];
    }else if ( second >= cursor ){
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
        NSDateFormatter * outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"HH:mm"];
        formattedTime = [NSString stringWithFormat:@"昨天 %@", [outputFormatter stringFromDate:date]];
    }else{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSDateComponents * component = [calendar components:NSYearCalendarUnit fromDate:date];
        NSDateComponents * nowComponent = [calendar components:NSYearCalendarUnit fromDate:nowDate];
        NSDateFormatter * outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        if ( component.year == nowComponent.year  ) {
            [outputFormatter setDateFormat:@"M月d日 HH:mm"];
            formattedTime = [outputFormatter stringFromDate:date];
        }else{
            [outputFormatter setDateFormat:@"yyyy年 M月d日 HH:mm"];
            formattedTime = [outputFormatter stringFromDate:date];
            
        }
    }
    return formattedTime;
}

+ (NSString *)formatSecondToDataString:(NSTimeInterval)second
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    return formattedDateString;
}

+ (NSString *)formatSecondToDownRecordTimeString:(NSTimeInterval)second
{
    NSString * result = nil;

    /**
     * 计算天数
     */
    NSInteger day = second / (24 * 60 * 60);
    NSInteger dayRemaind = ((NSInteger)second) % (24 * 60 * 60);

    /**
     *  计算小时数
     */
    NSInteger hours = dayRemaind / (60 * 60);
    NSInteger hourRemaind = dayRemaind % (60 * 60);

    /**
     *  计算分钟数
     */
    NSInteger minutes = hourRemaind / 60;
    NSInteger minuteRemaind = hourRemaind % 60;

    if (day > 0) {
        result = [NSString stringWithFormat:@"%@天%@小时%@分钟", [@(day) stringValue], [@(hours) stringValue], [@(minutes) stringValue]];
    }else if (hours > 0)
    {
        result = [NSString stringWithFormat:@"%@小时%@分钟", [@(hours) stringValue], [@(minutes) stringValue]];
    }
    else
    {
        if (minutes > 0) {
            result = [NSString stringWithFormat:@"%@分钟",[@(minutes) stringValue]];
        }
        else
        {
            result = [NSString stringWithFormat:@"%@秒",[@(minuteRemaind) stringValue]];
        }
    }


    return result;
}

+ (NSString *)formatSecondToDaysOrHoursOrMunites:(NSTimeInterval)second
{
    NSString * result = nil;

    /**
     *  计算天数
     */
    NSInteger day = second / (24 * 60 * 60);

    if (second > 0) {
        if (day > 1) {
            result = [NSString stringWithFormat:@"%@小时",[@(day) stringValue]];
        }
        else
        {
            /**
             *  计算小时数
             */
            NSInteger hours = second / (60 * 60);
            if (hours > 0) {
                result = [NSString stringWithFormat:@"%@小时",[@(hours) stringValue]];

            }else
            {
                NSInteger munites = second / 60;
                if (munites > 0 ) {
                    result = [NSString stringWithFormat:@"%@分钟",[@(munites) stringValue]];
                } else {
                    result = [NSString stringWithFormat:@"%@分钟",[@(munites+1) stringValue]];
                }
            }
        }
    }
    else
    {
        result = @"0";
    }

    return result;
}

@end
