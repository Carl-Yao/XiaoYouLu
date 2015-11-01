//
//  KTVDateFormatter.h
//  kugou
//
//  Created by fairzy on 14-7-17.
//  Copyright (c) 2014年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTVDateFormatter : NSObject

/**
 *  把unix的时间戳转换为距离现在的时间间隔(几分钟前，几小时前，几天前)的形式
 *
 *  @param second unix时间戳
 *
 *  @return NSString
 */
+ (NSString *)formatSecondToTimeIntervalString:(NSTimeInterval)second;

/// 14-01-01 12:12
+ (NSString *) formatSecondToDataString:(NSTimeInterval)second;

/**
 *  xx 天 xx 小时 xx 分钟
 */
+ (NSString *) formatSecondToDownRecordTimeString:(NSTimeInterval)second;

/**
 *  xx 小时 ／ xx 分钟
 */
+ (NSString *)formatSecondToDaysOrHoursOrMunites:(NSTimeInterval)second;

@end
