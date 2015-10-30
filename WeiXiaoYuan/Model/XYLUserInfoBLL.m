//
//  XYLUserInfoBLL.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/10/29.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "XYLUserInfoBLL.h"
static XYLUserInfoBLL*userInfo = nil;

@implementation XYLUserInfoBLL
+(XYLUserInfoBLL*) shareUserInfoBLL{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (userInfo==nil) {
            userInfo = [[XYLUserInfoBLL alloc] init];
        }
    });
    
    return userInfo;
}
@end
