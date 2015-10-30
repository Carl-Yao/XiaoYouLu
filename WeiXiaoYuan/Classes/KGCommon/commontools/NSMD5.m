//
//  NSMD5.m
//  YZX
//
//  Created by Yunsong on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSMD5.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access


@implementation NSString (NSMD5)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
    
}

+ (NSString *)fileMD5:(NSString *)filePath
{
    NSFileHandle *handle=[NSFileHandle fileHandleForReadingAtPath:filePath];
    if( handle==nil ) return nil;
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData *fileData = [handle readDataOfLength:1024*1024];//一次读取1M数据
        int len = [fileData length];
        if (len>0) {
            CC_MD5_Update(&md5, [fileData bytes], len);
        } else {
            done=YES;
            [handle closeFile];
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *filemd5 = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         digest[0], digest[1],
                         digest[2], digest[3],
                         digest[4], digest[5],
                         digest[6], digest[7],
                         digest[8], digest[9],
                         digest[10], digest[11],
                         digest[12], digest[13],
                         digest[14], digest[15]];
    return filemd5;
}

+ (NSString *)md5WithData:(NSData *)fileData
{
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    int len = [fileData length];
    CC_MD5_Update(&md5, [fileData bytes], len);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *dataMD5 = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         digest[0], digest[1],
                         digest[2], digest[3],
                         digest[4], digest[5],
                         digest[6], digest[7],
                         digest[8], digest[9],
                         digest[10], digest[11],
                         digest[12], digest[13],
                         digest[14], digest[15]];
    return dataMD5;
}

- (NSString *) md5Decimal
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    
    // 只取中间64位二进制，保证整形能容纳
    NSString *tempImei = [NSString stringWithFormat:
            @"%d%d%d%d%d%d%d%d",
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11]
            ];  
    NSString *ret = [NSString stringWithFormat: @"%qu", [tempImei longLongValue]];
    return ret;
}

- (NSString *)kgsquareBrackets
{
    return self;
}

- (NSString *)removeBracket
{
    if (self!= nil)
    {
        if ([self hasSuffix:@"】"])
        {
            NSRange range = [self rangeOfString: @"【" options:NSBackwardsSearch];
            if (range.location != NSNotFound)
            {
                NSString *restr = [self substringWithRange: NSMakeRange(0, range.location)];
                if (restr.length > 0)
                {
                    return restr;
                }
                return self;
            }
        }
        return  self;
    }
    return nil;

}



@end


@implementation NSData (NSMD5)
- (NSString*)md5
{
    unsigned char result[16];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}
@end
