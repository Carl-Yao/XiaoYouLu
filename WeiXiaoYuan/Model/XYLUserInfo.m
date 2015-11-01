//
//  XYLUserInfo.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/10/28.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "XYLUserInfo.h"

@implementation XYLUserInfo
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"userid"
                                                       }];
}
@end
