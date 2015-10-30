//
//  XYLUserInfoBLL.h
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/10/29.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYLUserInfo.h"

@interface XYLUserInfoBLL : NSObject
@property (nonatomic,strong)XYLUserInfo *userInfo;
@property (nonatomic,strong)NSMutableString *token;
+(XYLUserInfoBLL*) shareUserInfoBLL;
@end
