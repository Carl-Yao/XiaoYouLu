//
//  NSString+SHA.h
//  YZX
//
//  Created by xiaogaochao on 14-5-30.
//  Copyright (c) 2014年 YZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA)
//sha256加密
+ (NSString *)SHA256WithString:(NSString *)srcString;
+ (NSString *)SHA256WithData:(NSData *)data;

@end
