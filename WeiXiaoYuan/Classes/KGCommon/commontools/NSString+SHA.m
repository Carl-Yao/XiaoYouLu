//
//  NSString+SHA.m
//  YZX
//
//  Created by xiaogaochao on 14-5-30.
//  Copyright (c) 2014年 YZX. All rights reserved.
//

#import "NSString+SHA.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (SHA)

+ (NSString *)SHA256WithString:(NSString *)srcString;
{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    CC_SHA256_CTX sha256;
    CC_SHA256_Init(&sha256);
    
    CC_SHA256_Update(&sha256, [data bytes], [data length]);
    
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(digest, &sha256);
    
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for ( int i = 0 ; i < CC_SHA256_DIGEST_LENGTH ; i++)
    {
        [result appendFormat : @"%02x" , digest[i]];
    }
    return result;
}

+ (NSString *)SHA256WithData:(NSData *)data
{
    CC_SHA256_CTX sha256;
    CC_SHA256_Init(&sha256);
    
    CC_SHA256_Update(&sha256, [data bytes], [data length]);
    
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(digest, &sha256);
    
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for ( int i = 0 ; i < CC_SHA256_DIGEST_LENGTH ; i++)
    {
        [result appendFormat : @"%02x" , digest[i]];
    }
    return result;
}

@end
