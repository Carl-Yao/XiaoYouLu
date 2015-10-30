//
//  UserManager.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/12/10.
//  Copyright (c) 2014年 Dukeland. All rights reserved.
//

#import "UserManager.h"
static UserManager* _instance = nil;
@implementation UserManager
@synthesize UserType,modelArr;
+ (UserManager*)shareController
{
    @synchronized(self)
    {
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self){
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _instance;
}


@end
