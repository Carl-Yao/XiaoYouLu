//
//  UserManager.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/12/10.
//  Copyright (c) 2014年 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    PARENT,
    YEYTEACHER,
    ZXXTEACHER,
    YEYPRESIDENT,
    ZXXPRESIDENT,
    MANAGEMENT
} UserTypeEnum;
@interface UserManager : NSObject
@property UserTypeEnum UserType;
@property (nonatomic,strong)NSMutableArray* modelArr;

+ (UserManager*)shareController;
@end
