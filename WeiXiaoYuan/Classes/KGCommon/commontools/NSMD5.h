//
//  NSMD5.h
//  YZX
//
//  Created by Yunsong on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSMD5)
- (NSString *) md5;
+ (NSString *)fileMD5:(NSString *)filePath;//获取文件数据的md5
+ (NSString *)md5WithData:(NSData *)fileData;//获取NSData的md5

// md5,以整形格式返回
- (NSString *) md5Decimal;
- (NSString *)kgsquareBrackets;
- (NSString *)removeBracket;
@end

@interface NSData (NSMD5)
- (NSString*)md5;
@end

