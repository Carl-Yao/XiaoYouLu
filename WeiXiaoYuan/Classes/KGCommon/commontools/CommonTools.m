//
//  CommonTools.m
//  kugou
//
//  Created by Yunsong on 11-7-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Heads.h"
#import "CommonTools.h"
#import <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <UIKit/UIKit.h>
#include <sys/xattr.h>
#import "KGUrlDefine.h"
#import "netdb.h"
#import "sys/socket.h"
#import "UserActions.h"
//#import "CellInfo.h"
#import "Reachability.h"
#import <UIKit/UIDevice.h>
#import "UIDevice-Hardware.h"
#import "ASIHTTPRequest.h"
#import "KGASIHttp.h"
#import "StatisticInfo.h"
#import "settingConfig.h"
#import "OfflineMgr.h"
//#import "DownloadMgr.h"
#import "KGDownloadAPI.h"
#import "CacheBLL.h"
#import "TipsString.h"
//#import "SVProgressHUD.h"
#import "KGPlayQueueManager.h"
#import "KGNormalPlayList.h"
#import "NSMD5.h"
#import "KGProgressView.h"
#import "DataBaseManage.h"
#import "EZHttp.h"
#import "KGConfigEntity.h"
#import "KGUrlDefine.h"
#import "SFHFKeychainUtils.h"
#import "DoresoRecorderUtils.h"
#import "UnicomVipState.h"
#import "LocalMusicBLL.h"
#import "FM_Define.h"
#import <sys/param.h>
#import <sys/mount.h>
#import <sys/stat.h>
#import <sys/dirent.h>
#import "KGMusicUrlDefine.h"

#define DEFAULT_VOID_COLOR 0

NSString *const kChinaUnicomProductKey = @"ChinaUnicomProduct";


static NSString *_key = @"12345678";


static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@implementation KGCommonTools

+ (natural_t)getFreeMemory
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
        return 0;
    }
    
    /* Stats in bytes */
    natural_t mem_free = vm_stat.free_count * pagesize;
    NSLog(@"free memory: %u", mem_free);
    return mem_free;
}


//加密
+ (NSString *) encryptStr:(NSString *) str
{
    return[KGCommonTools doCipher:str key:_key context:kCCEncrypt];
}
//解密
+ (NSString *) decryptStr:(NSString *) str
{
    return[KGCommonTools doCipher:str key:_key context:kCCDecrypt];
}
+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt 
{
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData * dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) 
    {    
        dTextIn = [[KGCommonTools decodeBase64WithString:sTextIn] mutableCopy];    
    }    
    else
    {    
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];    
    }           
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    [dKey release];

    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;    
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
//    Byte *testByte = (Byte *)[dTextIn bytes];
//    for (int i = 0; i<[dTextIn length]; i++)
//    {
//        DLog(@"----------%d",testByte[i]);
//    }
    Byte des_key[] = {0x13, 0x25, 0x2e, 0x4f, 0x0d, 0x11, 0x1c, 0x27};
    Byte iv[] = {0x30, 0x0f, 0x3b, 0x14, 0x1a, 0x23, 0x39, 0x0a};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);    
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));    
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);    
    CCCrypt(encryptOrDecrypt, // CCOperation op    
            kCCAlgorithmDES, // CCAlgorithm alg    
            kCCOptionPKCS7Padding, // CCOptions options    
            des_key, // const void *key    
            kCCKeySizeDES, // size_t keyLength    
            iv, // const void *iv    
            [dTextIn bytes], // const void *dataIn
            [dTextIn length],  // size_t dataInLength    
            (void*)bufferPtr1, // void *dataOut    
            bufferPtrSize1,     // size_t dataOutAvailable 
            &movedBytes1);      // size_t *dataOutMoved    
    
    [dTextIn release];
    
    NSString * sResult;    
    if (encryptOrDecrypt == kCCDecrypt)
    {    
        sResult = [[[ NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1     
                                                                  length:movedBytes1] encoding:EnC] autorelease];    
    }    
    else
    {    
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1]; 
        sResult = [KGCommonTools encodeBase64WithData:dResult];    
    }  
    DLog(@"url is___:%@",sResult);
    return sResult;
}

+ (NSString *)fullImageURLEncrypt:(NSString *)srcURL
{
    char outBuf[2056] = {0};
    size_t encryptByteCount = 0;
    
    NSString *retURL = nil;
    
    Byte des_key[] = {0x13, 0x25, 0x2e, 0x4f, 0x0d, 0x11, 0x1c, 0x27};
    Byte iv[] = {0x30, 0x0f, 0x3b, 0x14, 0x1a, 0x23, 0x39, 0x0a};
    
    int srcLen = [srcURL length];
    char srcBytes[srcLen];
    memset(srcBytes, 0, srcLen);
    memcpy(srcBytes, [srcURL cStringUsingEncoding:NSUTF8StringEncoding], srcLen);
    
    CCCryptorStatus decryptStatus = CCCrypt(kCCEncrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding,
                                            des_key,
                                            sizeof(des_key),
                                            iv,
                                            srcBytes,
                                            srcLen,
                                            outBuf,
                                            sizeof(outBuf),
                                            &encryptByteCount
                                            );
    if (decryptStatus == kCCSuccess)
    {
        retURL = [NSString stringWithUTF8String:outBuf];
    }
    else
    {
        DLog(@"full_image_url_decrypt error: %d", decryptStatus);
    }
    
    return retURL;
}

+ (int)numberValueForHex:(char)hexC
{
    if (hexC >= '0' && hexC <= '9')
    {
        return hexC - '0';
    }
    
    if (hexC >= 'A' && hexC <= 'F')
    {
        return hexC - 'A' + 10;
    }
    
    if (hexC >= 'a' && hexC <= 'f')
    {
        return hexC - 'a' + 10;
    }
    
    return 0;
}

+ (NSData *)userInfoDecrypt:(NSData *)srcData
{
    char outBuf[2056] = {0};
    size_t decryptByteCount = 0;
    
    NSString *retURL = nil;
    
    Byte des_key[] = {79,46,13,17,28,39,7,3};
    Byte iv[] = {26,59,48,68,35,24,11,99};
    
    int srcLen = [srcData length];
    char srcBytes[srcLen];
    memset(srcBytes, 0, srcLen);
    [srcData getBytes:srcBytes length:srcLen];
    
    // 服务器返回的是十六进制字符串，把其转化成byte数值（以十进制表示即可）
    int srcContentLen = srcLen / 2;
    char srcContent[srcContentLen];
    memset(srcContent, 0, srcContentLen);
    for (int pos = 0; pos < srcContentLen; pos ++)
    {
        char f = srcBytes[pos * 2];
        char s = srcBytes[pos * 2 + 1];
        
        // 同strtol(str, 0, 16)
        int c = [self numberValueForHex:f] * 16 + [self numberValueForHex:s];
        srcContent[pos] = c;
    }
    
    CCCryptorStatus decryptStatus = CCCrypt(kCCDecrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding,
                                            des_key,
                                            sizeof(des_key),
                                            iv,
                                            srcContent,
                                            srcContentLen,
                                            outBuf,
                                            sizeof(outBuf),
                                            &decryptByteCount
                                            );
    if (decryptStatus == kCCSuccess)
    {
        memset(outBuf + decryptByteCount, 0, decryptByteCount);
        retURL = [NSString stringWithCString:outBuf encoding:NSUTF8StringEncoding];
    }
    else
    {
        DLog(@"full_image_url_decrypt error: %d", decryptStatus);
    }
    
    return nil;
}
+ (NSData *)userInfoEncrypt2:(NSString *)srcInfo
{
    size_t encryptByteCount = 0;
    
    //NSString *retURL = nil;
    
    /*
     'key' => array(79,46,13,17,28,39,7,3),
     'iv'  => array(26,59,48,68,35,24,11,99),
     */
    Byte des_key[] = {55,46,13,17,28,39,7,3};
    Byte iv[] = {26,59,48,68,35,24,11,77};
    
    /*
     int srcLen = [srcInfo length];
     char srcBytes[srcLen];
     memset(srcBytes, 0, srcLen);
     memcpy(srcBytes, [srcInfo cStringUsingEncoding:NSUTF8StringEncoding], srcLen);
     */
    
    int keyLen = sizeof(des_key);
    NSData *srcData = [srcInfo dataUsingEncoding:NSUTF8StringEncoding];
    int outBufLen = ([srcData length] + keyLen) & ~(keyLen - 1);
    char outBuf[outBufLen];
    memset(outBuf, 0, sizeof(outBuf));
    
    CCCryptorStatus decryptStatus = CCCrypt(kCCEncrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding,
                                            des_key,
                                            sizeof(des_key),
                                            iv,
                                            [srcData bytes],
                                            [srcData length],
                                            outBuf,
                                            sizeof(outBuf),
                                            &encryptByteCount
                                            );
    if (decryptStatus == kCCSuccess)
    {
        int bufSize = encryptByteCount * 2 + 1024;
        char hexBuf[bufSize];
        memset(hexBuf, 0, sizeof(hexBuf));
        char *p = hexBuf;
        for (int pos = 0; pos < encryptByteCount; pos ++)
        {
            Byte value = outBuf[pos];
            char buf[5] = {0};
            sprintf(buf, "%02X", value);
            int bufLen = strlen(buf);
            memcpy(p, buf, bufLen);
            p += bufLen;
        }
        
        int hexBufLen = strlen(hexBuf);
        NSData *encryptData = [NSData dataWithBytes:hexBuf length:hexBufLen];
        
        //[self userInfoDecrypt:encryptData];
        
        // 加参数
        char buf[bufSize];
        memset(buf, 0, sizeof(buf));
        //        char *param = "crypt=";
        //        int paramLen = strlen(param);
        //        memcpy(buf, param, paramLen);
        [encryptData getBytes:buf  length:bufSize ];
        int totalLen = [encryptData length] ;
        NSData *retData = [NSData dataWithBytes:buf length:totalLen];
        
        return retData;
    }
    else
    {
        DLog(@"userInfoEncrypt error: %d", decryptStatus);
    }
    
    return nil;
}
+ (NSData *)userInfoEncryptNew:(NSString *)srcInfo
{
    size_t encryptByteCount = 0;
    
    //NSString *retURL = nil;
    
    /*
     'key' => array(79,46,13,17,28,39,7,3),
     'iv'  => array(26,59,48,68,35,24,11,99),
     */
    Byte des_key[] = {79,46,13,17,28,39,7,3};
    Byte iv[] = {26,59,48,68,35,24,11,99};
    
    /*
     int srcLen = [srcInfo length];
     char srcBytes[srcLen];
     memset(srcBytes, 0, srcLen);
     memcpy(srcBytes, [srcInfo cStringUsingEncoding:NSUTF8StringEncoding], srcLen);
     */
    
    int keyLen = sizeof(des_key);
    NSData *srcData = [srcInfo dataUsingEncoding:NSUTF8StringEncoding];
    int outBufLen = ([srcData length] + keyLen) & ~(keyLen - 1);
    char outBuf[outBufLen];
    memset(outBuf, 0, sizeof(outBuf));
    
    CCCryptorStatus decryptStatus = CCCrypt(kCCEncrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding,
                                            des_key,
                                            sizeof(des_key),
                                            iv,
                                            [srcData bytes],
                                            [srcData length],
                                            outBuf,
                                            sizeof(outBuf),
                                            &encryptByteCount
                                            );
    if (decryptStatus == kCCSuccess)
    {
        int bufSize = encryptByteCount * 2 + 1024;
        char hexBuf[bufSize];
        memset(hexBuf, 0, sizeof(hexBuf));
        char *p = hexBuf;
        for (int pos = 0; pos < encryptByteCount; pos ++)
        {
            Byte value = outBuf[pos];
            char buf[5] = {0};
            sprintf(buf, "%02X", value);
            int bufLen = strlen(buf);
            memcpy(p, buf, bufLen);
            p += bufLen;
        }
        
        int hexBufLen = strlen(hexBuf);
        NSData *encryptData = [NSData dataWithBytes:hexBuf length:hexBufLen];
        
        //[self userInfoDecrypt:encryptData];
        
        // 加参数
        char buf[bufSize];
        memset(buf, 0, sizeof(buf));
//        char *param = "crypt=";
//        int paramLen = strlen(param);
//        memcpy(buf, param, paramLen);
        [encryptData getBytes:buf  length:bufSize ];
        int totalLen = [encryptData length] ;
        NSData *retData = [NSData dataWithBytes:buf length:totalLen];
        
        return retData;
    }
    else
    {
        DLog(@"userInfoEncrypt error: %d", decryptStatus);
    }
    
    return nil;
}
+ (NSData *)userInfoEncrypt:(NSString *)srcInfo
{
    size_t encryptByteCount = 0;
    
    //NSString *retURL = nil;
    
    /*
     'key' => array(79,46,13,17,28,39,7,3),
     'iv'  => array(26,59,48,68,35,24,11,99),
     */
    Byte des_key[] = {79,46,13,17,28,39,7,3};
    Byte iv[] = {26,59,48,68,35,24,11,99};
    
    /*
     int srcLen = [srcInfo length];
     char srcBytes[srcLen];
     memset(srcBytes, 0, srcLen);
     memcpy(srcBytes, [srcInfo cStringUsingEncoding:NSUTF8StringEncoding], srcLen);
     */
    
    int keyLen = sizeof(des_key);
    NSData *srcData = [srcInfo dataUsingEncoding:NSUTF8StringEncoding];
    int outBufLen = ([srcData length] + keyLen) & ~(keyLen - 1);
    char outBuf[outBufLen];
    memset(outBuf, 0, sizeof(outBuf));
    
    CCCryptorStatus decryptStatus = CCCrypt(kCCEncrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding,
                                            des_key,
                                            sizeof(des_key),
                                            iv,
                                            [srcData bytes],
                                            [srcData length],
                                            outBuf,
                                            sizeof(outBuf),
                                            &encryptByteCount
                                            );
    if (decryptStatus == kCCSuccess)
    {
        int bufSize = encryptByteCount * 2 + 1024;
        char hexBuf[bufSize];
        memset(hexBuf, 0, sizeof(hexBuf));
        char *p = hexBuf;
        for (int pos = 0; pos < encryptByteCount; pos ++)
        {
            Byte value = outBuf[pos];
            char buf[5] = {0};
            sprintf(buf, "%02X", value);
            int bufLen = strlen(buf);
            memcpy(p, buf, bufLen);
            p += bufLen;
        }
        
        int hexBufLen = strlen(hexBuf);
        NSData *encryptData = [NSData dataWithBytes:hexBuf length:hexBufLen];
        
        //[self userInfoDecrypt:encryptData];
        
        // 加参数
        char buf[bufSize];
        memset(buf, 0, sizeof(buf));
        char *param = "crypt=";
        int paramLen = strlen(param);
        memcpy(buf, param, paramLen);
        [encryptData getBytes:buf + paramLen length:bufSize - paramLen];
        int totalLen = [encryptData length] + paramLen;
        NSData *retData = [NSData dataWithBytes:buf length:totalLen];
        
        return retData;
    }
    else
    {
        DLog(@"userInfoEncrypt error: %d", decryptStatus);
    }
    
    return nil;
}

+ (NSString *)desEncrypt:(NSString *)srcContent key:(Byte *)des_key keySize:(int)keySize vector:(Byte *)iv
{
    size_t encryptByteCount = 0;
    
    NSString *retContent = nil;
    
    int keyLen = keySize;
    NSData *srcData = [srcContent dataUsingEncoding:NSUTF8StringEncoding];
    int outBufLen = ([srcData length] + keyLen) & ~(keyLen - 1);
    char outBuf[outBufLen];
    memset(outBuf, 0, sizeof(outBuf));
    
    CCCryptorStatus decryptStatus = CCCrypt(kCCEncrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding,
                                            des_key,
                                            keyLen,
                                            iv,
                                            [srcData bytes],
                                            [srcData length],
                                            outBuf,
                                            sizeof(outBuf),
                                            &encryptByteCount
                                            );
    if (decryptStatus == kCCSuccess)
    {
        int bufSize = encryptByteCount * 2 + 1024;
        char hexBuf[bufSize];
        memset(hexBuf, 0, sizeof(hexBuf));
        char *p = hexBuf;
        for (int pos = 0; pos < encryptByteCount; pos ++)
        {
            Byte value = outBuf[pos];
            char buf[5] = {0};
            sprintf(buf, "%02X", value);
            int bufLen = strlen(buf);
            memcpy(p, buf, bufLen);
            p += bufLen;
        }
        
        retContent = [NSString stringWithUTF8String:hexBuf];
        
        return retContent;
        
        //[self userInfoDecrypt:encryptData];
        
    }
    else
    {
        DLog(@"desEncrypt error: %d", decryptStatus);
    }
    
    return nil;
}

+ (NSString *)desDecrypt:(NSData *)inSrcContent key:(Byte *)key keySize:(int)keySize vector:(Byte *)iv
{
    char outBuf[2056] = {0};
    size_t decryptByteCount = 0;
    
    NSString *retURL = nil;
    
    int srcLen = [inSrcContent length];
    char srcBytes[srcLen];
    memset(srcBytes, 0, srcLen);
    [inSrcContent getBytes:srcBytes length:srcLen];
    
    // 服务器返回的是十六进制字符串，把其转化成byte数值（以十进制表示即可）
    int srcContentLen = srcLen / 2;
    char srcContent[srcContentLen];
    memset(srcContent, 0, srcContentLen);
    for (int pos = 0; pos < srcContentLen; pos ++)
    {
        char f = srcBytes[pos * 2];
        char s = srcBytes[pos * 2 + 1];
        
        // 同strtol(str, 0, 16)
        int c = [self numberValueForHex:f] * 16 + [self numberValueForHex:s];
        srcContent[pos] = c;
    }
    
    CCCryptorStatus decryptStatus = CCCrypt(kCCDecrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding,
                                            key,
                                            keySize,
                                            iv,
                                            srcContent,
                                            srcContentLen,
                                            outBuf,
                                            sizeof(outBuf),
                                            &decryptByteCount
                                            );
    if (decryptStatus == kCCSuccess)
    {
        memset(outBuf + decryptByteCount, 0, decryptByteCount);
        retURL = [NSString stringWithCString:outBuf encoding:NSUTF8StringEncoding];
    }
    else
    {
        DLog(@"desDecrypt error: %d", decryptStatus);
    }
    
    return retURL;
}

+ (NSString *)fullImageURLDecrypt:(NSString *)srcURL
{
    const int bufLen = [srcURL length];
    char outBuf[bufLen];
    memset(outBuf, 0, bufLen);
    size_t decryptByteCount = 0;
    
    NSString *retURL = nil;
    
    Byte des_key[] = {0x13, 0x25, 0x2e, 0x4f, 0x0d, 0x11, 0x1c, 0x27};
    Byte iv[] = {0x30, 0x0f, 0x3b, 0x14, 0x1a, 0x23, 0x39, 0x0a};
    
    int srcLen = [srcURL length];
    char srcBytes[srcLen];
    memset(srcBytes, 0, srcLen);
    memcpy(srcBytes, [srcURL cStringUsingEncoding:NSUTF8StringEncoding], srcLen);
    
    // 服务器返回的是十六进制字符串，把其转化成byte数值（以十进制表示即可）
    int srcContentLen = srcLen / 2;
    char srcContent[srcContentLen];
    memset(srcContent, 0, srcContentLen);
    for (int pos = 0; pos < srcContentLen; pos ++)
    {
        char f = srcBytes[pos * 2];
        char s = srcBytes[pos * 2 + 1];
        
        // 同strtol(str, 0, 16)
        int c = [self numberValueForHex:f] * 16 + [self numberValueForHex:s];
        srcContent[pos] = c;
    }
    
    CCCryptorStatus decryptStatus = CCCrypt(kCCDecrypt,
                                            kCCAlgorithmDES,
                                            kCCOptionPKCS7Padding,
                                            des_key,
                                            sizeof(des_key),
                                            iv,
                                            srcContent,
                                            srcContentLen,
                                            outBuf,
                                            sizeof(outBuf),
                                            &decryptByteCount
                                            );
    if (decryptStatus == kCCSuccess)
    {
        memset(outBuf + decryptByteCount, 0, bufLen-decryptByteCount);
        retURL = [NSString stringWithUTF8String:outBuf];
    }
    else
    {
        DLog(@"full_image_url_decrypt error: %d", decryptStatus);
    }
    
    return retURL;
}

+ (NSString *)encodeBase64WithString:(NSString *)strData
{
    return[KGCommonTools encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}


+ (NSString *)encodeBase64WithData:(NSData *)objData 
{
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    int intLength = [objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while(intLength > 2) 
    { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3; 
    }
    
    // now deal with the tail end of things
    if (intLength != 0)
    {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1)
        {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Return the results as an NSString object
    NSString *ret = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    free(strResult);
    return ret;
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64
{
    const char* objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
    int intLength = strlen(objPointer);
    int intCurrent;
    int i = 0, j = 0, k;
    
    unsigned char * objResult;
    objResult = calloc(intLength, sizeof(char));
    
    // Run through the whole string, converting as we go
    while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) 
    {
        if (intCurrent == '=') {
            if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
                // the padding character is invalid at this point -- so this entire string is invalid
                free(objResult);
                return nil;
            }
            continue;
        }
        
        intCurrent = _base64DecodingTable[intCurrent];
        if (intCurrent == -1)
        {
            // we're at a whitespace -- simply skip over
            continue;
        } 
        else if (intCurrent == -2) 
        {
            // we're at an invalid character
            free(objResult);
            return nil;
        }
        
        switch (i % 4) 
        {
            case 0:
                objResult[j] = intCurrent << 2;
                break;
                
            case 1:
                objResult[j++] |= intCurrent >> 4;
                objResult[j] = (intCurrent & 0x0f) << 4;
                break;
                
            case 2:
                objResult[j++] |= intCurrent >>2;
                objResult[j] = (intCurrent & 0x03) << 6;
                break;
                
            case 3:
                objResult[j++] |= intCurrent;
                break;
        }
        i++;
    }
    
    // mop things up if we ended on a boundary
    k = j;
    if (intCurrent == '=')
    {
        switch (i % 4) 
        {
            case 1:
                // Invalid state
                free(objResult);
                return nil;
                
            case 2:
                k++;
                // flow through
            case 3:
                objResult[k] = 0;
        }
    }
    
    // Cleanup and setup the return NSData
    NSData * objData = [[[NSData alloc] initWithBytes:objResult length:j] autorelease];
    free(objResult);
    return objData;
}
+ (UIImage*)ImageFormat:(UIImage*)image
{
    if (image.size.height!=image.size.width) 
    {
        int leastpx;
        if (image.size.height>image.size.width) 
        {
            leastpx = image.size.width;
        }
        
        leastpx = image.size.height;
        if (leastpx == 39) 
        {
            return [KGCommonTools scale:image toSize:CGSizeMake(leastpx*2, leastpx*2)];
        }
        else
        {
            CGRect rect = CGRectMake(0, 0,leastpx, leastpx);
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
            UIImage *retImage = [UIImage imageWithCGImage: imageRef];
            CGImageRelease(imageRef);
            return retImage;
        }

    }
    return image;
}

+ (NSDate *)fileModifiedTime:(NSString *)filePathName
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager]attributesOfItemAtPath:filePathName error:nil];
    //DLog(@"%@", fileAttributes);
    NSDate *date = [fileAttributes objectForKey:NSFileModificationDate];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)strDate
{
    DLog(@"%@", strDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //[formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    [locale release];
    NSDate *date = [formatter dateFromString:strDate];
    [formatter release];
    
    return date;
}

+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //DLog(@"%f---%f",scaledImage.size.width,scaledImage.size.height);
    return scaledImage;
}

+ (NSString*) md5ToString: (NSData*)md5
{
    if (md5 == nil)
    {
        return nil;
    }
    
    int md5Lenght = [md5 length];
    if (md5Lenght != 16)
    {
        return nil;
    }
    
    const char HEX[16] = 
    {
        '0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', 'a', 'b',
        'c', 'd', 'e', 'f'
    };
    
    NSMutableString* retString = [NSMutableString stringWithCapacity: 30];
    Byte temp[md5Lenght];
    [md5 getBytes: temp length: md5Lenght];
    for (uint pos = 0; pos < md5Lenght; pos ++) 
    {
        int t = temp[pos];
        int a = t / 16;
        int b = t % 16;
        [retString appendFormat: @"%c", HEX[a]];
        [retString appendFormat: @"%c", HEX[b]];
    }
    
    return retString;
}
+(BOOL) isSuppertAppstorePay{
    //判断“正式版支付渠道的开关”
    NSInteger bPayWaySwitcherOpen = [[[KGConfigEntity instance] numberOfKey:KGMUSIC_PAYWAY_SWITCHER] asInteger];
    if (bPayWaySwitcherOpen) {
        //开关打开时，统一按越狱渠道处理
        return NO;
    }
    else
    {
        return [StatisticInfo isAppStoreChannel] && ![KGCommonTools isJailBroken];
    }
}
+ (char) AssciiToValue: (char)assci
{
    char value = assci;
    if( value >= '0' && value <= '9' )
        value -= 48;
    else if( value >= 'a' && value <= 'z' )
        value -= 87;
    else if( value >= 'A' && value <= 'Z' )
        value -= 55;
    return value;
}

+ (NSData*) stringToMd5: (NSString*)strMd5
{
    if (strMd5==nil) {
        return nil;
    }
    int nSize = [strMd5 length] / 2;
    if (nSize != 16)
    {
        return nil;
    }
    
    char buffer[16];
    for( int i = 0; i < nSize; ++i )
    {
        char m = [self AssciiToValue: [strMd5 characterAtIndex: (2 * i)]];
        char n = [self AssciiToValue: [strMd5 characterAtIndex: (2 * i + 1)]];
        buffer[i] = m * 16 + n;
    }
    
    return [NSData dataWithBytes: buffer length: 16];
}

+ (NSString*) stringToMd5String:(NSString*) value{
    const char *original_str = [value UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

+ (void) alignLabelWithTop: (UILabel*)label 
{
    ASSERT_RETURN(label);
    CGSize maxSize = CGSizeMake(label.frame.size.width, 9999);
    label.adjustsFontSizeToFitWidth = NO;
    // get actual height
    CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
    CGRect rect = label.frame;
    rect.size.height = actualSize.height;
    label.frame = rect;
}

+ (BOOL) connectedToNetwork  
{
//    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
    // Create zero addy
    struct sockaddr_in zeroAddress;  
    bzero(&zeroAddress, sizeof(zeroAddress));  
    zeroAddress.sin_len = sizeof(zeroAddress);  
    zeroAddress.sin_family = AF_INET;  
    
    // Recover reachability flags  
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);      
    SCNetworkReachabilityFlags flags;  
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);  
    CFRelease(defaultRouteReachability);  
    
    if (!didRetrieveFlags)   
    {  
        printf("Error. Could not recover network reachability flags/n");  
        return NO;  
    }  
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);  
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);  
    return (isReachable && !needsConnection) ? YES : NO;  
}

+(NSString*)getOperator
{
    NSString *retStr = @"simulator";
    
    CTTelephonyNetworkInfo *tInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *tCarrier = [tInfo subscriberCellularProvider];
    NSString *tStr = [tCarrier mobileNetworkCode];
    if (tStr != nil && ![@"" isEqualToString:tStr])
    {
        retStr = [[[NSString alloc] initWithString:tStr] autorelease];
    }
    [tInfo release];
    
    return retStr;
}

+ (BOOL) isUseWifi
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == kReachableViaWiFi);
//    struct sockaddr_in zeroAddr;
//    bzero(&zeroAddr, sizeof(zeroAddr));
//    zeroAddr.sin_len = sizeof(zeroAddr);
//    zeroAddr.sin_family = AF_INET;
//    
//    SCNetworkReachabilityRef target = 
//    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddr);
//    
//    SCNetworkReachabilityFlags flags;
//    SCNetworkReachabilityGetFlags(target, &flags);
//    CFRelease(target);
//    
//    BOOL bUseWifi = NO;
//    if (flags & kSCNetworkReachabilityFlagsIsWWAN)
//    {
//        // 3g
//        bUseWifi = NO;
//    }
//    else
//    {
//        // wifi--2
//        bUseWifi = YES;
//    }
//    
//    return bUseWifi;
}

+ (BOOL)isChinaFromMobile
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    DLog(@"carrier: %@", [carrier description]);
    BOOL ret = NO;
    if ([carrier.mobileCountryCode isEqualToString: @"460"]
        || [carrier.mobileCountryCode isEqualToString: @"461"])
    {
        ret = YES;
    }
    [info release];
    
    return ret;
}
+(int)isChinaUserHttpRequest
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSError*error ;
    int ret = 0;
    do{
        NSMutableString*retURL = [NSMutableString stringWithString:@"?&cmd=508"];
        
        
        CTCarrier *carrier = info.subscriberCellularProvider;
        DLog(@"%@", carrier);
        NSString *strCountryCode = @"";
        if (carrier.mobileCountryCode && ![carrier.mobileCountryCode isEqualToString:@"null"])
        {
            strCountryCode = carrier.mobileCountryCode;
        }
        if ([strCountryCode isEqualToString:@"65535"])
        {
            strCountryCode = @"";
        }
        
        NSString *requestURL = [NSString stringWithFormat:@"%@&plat=%@&version=%@&mcc=%@", retURL, [StatisticInfo urlplat],
                                [StatisticInfo appVersion], strCountryCode];
        EZHttp*http = [[EZHttp alloc]init];
        [http setUrlsKey:UTILMODULE_URL_CHECKIP AndFillUrl:requestURL];
        http.kGUserAgent =@"CheckChinaUser";
        http.isNeedCheckIP = NO;
        http.returnDataType = ReturnData_Json;
        [http startSynchronous];
        NSDictionary* billDict = [http repAccordingDataType];
        error = http.error;
        [http release];
        if (error!=nil) {
            break;
        }
        DLog(@"billDict:%@",billDict);
        NSString *retStr = nil;
        if ([billDict count] != 0)
        {
            int status = [[billDict kg_numberForKey:@"status"]intValue];
            if (status == 1)
            {
                retStr = [NSString stringWithFormat:@"%@",[billDict kg_stringForKey:@"flag"]];
            }
        }
        
        
        if ([retStr isEqualToString: @"1"])
        {
            ret = 1;
        }
        else if ([retStr isEqualToString: @"0"])
        {
            ret = 2;
        }
        else
        {
            ret = 3;  // 服务失效
        }
    }while (NO) ;
    if (error!=nil) {
        DLog(@"error:%@",error);
        ret = 3;
    }
    
    [info release];
    
    return ret;
    
}
+ (int) isChinaUser
{
//    return 3;
//    CdnProtocol *cdn = [CdnProtocol cndprotocol];
//    CdnInfo *chinaipCdnInfo = [[cdn.allUrlDict objectForKey:@"chinaip"]retain];
//    NSString *defUrlStr =@"http://ip2.kugou.com/check/isCn";
//    NSString *firstUrlStr = chinaipCdnInfo.var;
//    NSString *secondUrlStr = [chinaipCdnInfo.cdnDict objectForKey:@"backup"];
//    
//    if (firstUrlStr.length == 0) {
//        firstUrlStr = defUrlStr;
//    }
    
    NSInteger ret = [self isChinaUserHttpRequest];
//    ret = 0;
//    if (ret == 0 || ret == 3) {
//        ret = [self isChinaUserHttpRequest];
//    }
//    [chinaipCdnInfo release];
//    ret = 0;
//    if (ret == 0) {
//        ret = [self isChinaUserHttpRequest:defUrlStr];
//    }
    //缓存记录
    if (ret == 0 || ret == 3) {
        ret = [ConfigProtocol getChinaIp];
    }else{
        [ConfigProtocol saveChinaIp:ret];
    }
    
    return ret;
    

}

+ (UIButton*) frameButton: (int)width btnHeight: (int)height
{
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, width, height);
    [btn.layer setMasksToBounds: YES];
    [btn.layer setCornerRadius: 10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth: 3.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 }); 
    CGColorSpaceRelease(colorSpace);
    [btn.layer setBorderColor:colorref];//边框颜色
    CGColorRelease(colorref);
    
    return btn;
}

+ (NSString *)timeFormatString: (int) secCount 
{
	int value_m= secCount/60;
	int value_s= secCount%60;
    //DLog(@"-----%i",timeCount);
	NSString * str_s;
	NSString * str_m;
	if (value_m < 10) { //分
		str_m = [[NSString alloc] initWithFormat:@"0%d",value_m];
	}else {
		str_m = [[NSString alloc] initWithFormat:@"%d",value_m];
	}
	
	if (value_s < 10) {//秒
		str_s = [[NSString alloc] initWithFormat:@"0%d",value_s];
	}else {
		str_s = [[NSString alloc] initWithFormat:@"%d",value_s];
	}
	NSArray *pathArray = [NSArray arrayWithObjects:str_m, str_s, nil];  
	[str_m release];
	[str_s release];
	
	return [pathArray componentsJoinedByString:@":"];
}

+ (BOOL) isWideNetWorkd
{
    
//    + (BOOL) IsEnableWIFI {
        return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == kReachableViaWiFi);
//    }
//    struct sockaddr_in zeroAddr;
//    bzero(&zeroAddr, sizeof(zeroAddr));
//    zeroAddr.sin_len = sizeof(zeroAddr);
//    zeroAddr.sin_family = AF_INET;
//    
//    SCNetworkReachabilityRef target = 
//    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddr);
//    
//    SCNetworkReachabilityFlags flags;
//    SCNetworkReachabilityGetFlags(target, &flags);
//    CFRelease(target);
//    
//    BOOL bRet = NO;
//    if (flags & kSCNetworkReachabilityFlagsIsWWAN)
//    {
//        // 3g/gprs
//        bRet = NO;
//    }
//    else
//    {
//        // wifi--2
//        bRet = YES;
//    }
//    return bRet;
}

+ (NSString*) GBKtoUTF8:(NSString *)GBKString
{
	int maxLength = [GBKString length];
	char *nbytes = malloc(maxLength + 1);
	for(int i = 0; i < maxLength; i++)
	{
		unichar ch = [GBKString characterAtIndex:i];
		*nbytes = (char)ch;
		nbytes = nbytes + 1;
	}
	*nbytes = '\0';
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	NSString *Result = [NSString stringWithCString: nbytes - maxLength encoding: enc] ;
    free(nbytes - maxLength);
	return Result;
}

+ (NSMutableDictionary*) id3Info: (NSString*) fullPathName
{
    NSMutableDictionary *id3Dic = [NSMutableDictionary dictionary];
    NSURL *fileURL = [NSURL fileURLWithPath:fullPathName];
    AVURLAsset *musicAsset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    for (NSString *format in [musicAsset availableMetadataFormats]) {
        DLog(@"format type = %@",format);
        for (AVMetadataItem *metadataItem in [musicAsset metadataForFormat:format]) {
            DLog(@"commonKey = %@",metadataItem.commonKey);
            if (metadataItem.commonKey && metadataItem.commonKey.length > 0 && metadataItem.value) {
                [id3Dic setObject:metadataItem.value forKey:metadataItem.commonKey];
            }
        }
    }
    //时间
    CMTime duration = musicAsset.duration;
    double seconds = (double)CMTimeGetSeconds(duration);//总时间
    [id3Dic setObject:[NSString stringWithFormat:@"%.3f",seconds] forKey:@"duration"];
    return id3Dic;
}

+ (BOOL) isIpodMusicExist: (NSString*) musicFullPathName
{
    if (musicFullPathName == nil)
    {
        return NO;
    }
    
    // [MPMediaQuery songsQuery].items在第一次执行时，时间开销较大
    for (MPMediaItem* item in [MPMediaQuery songsQuery].items) 
    { 
        NSURL *assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
        NSString* strURL = [[NSString alloc] initWithFormat:@"%@",assetURL];
        if ([strURL isEqualToString: musicFullPathName])
        {
            [strURL release];
            return YES;
        }
        [strURL release];
    }
    return NO;
}

+(BOOL)boolMediaFile:(NSString *)file
{
	NSString *pathExtension=[file pathExtension];
	if([pathExtension compare:@"mp4"
					  options:NSCaseInsensitiveSearch|NSNumericSearch]
	   ==NSOrderedSame)
	{
		return YES;
	}
	else if([pathExtension compare:@"3gp"
						   options:NSCaseInsensitiveSearch|NSNumericSearch]
			==NSOrderedSame)
	{
		return YES;
	}
	else if([pathExtension compare:@"m4a"
						   options:NSCaseInsensitiveSearch|NSNumericSearch]
			==NSOrderedSame)
	{
		return YES;
	}
	else if([pathExtension compare:@"mp3"
						   options:NSCaseInsensitiveSearch|NSNumericSearch]
			==NSOrderedSame)
	{
		return YES;
	}
	else if([pathExtension compare:@"avi"
						   options:NSCaseInsensitiveSearch|NSNumericSearch]
			==NSOrderedSame)
	{
		return YES;
	}
	else if([pathExtension compare:@"wav"
						   options:NSCaseInsensitiveSearch|NSNumericSearch]
			==NSOrderedSame)
	{
		return YES;
	}
	return NO;
    
}

+ (BOOL) isOSVersion_3GS
{
    return [[UIDevice currentDevice].platformString hasPrefix:IPHONE_3G_NAMESTRING];
}
+ (BOOL) isOSVersion_5
{
    return [[UIDevice currentDevice].systemVersion hasPrefix: @"5."];
}

+(int) SystemVersin
{
    return  [[UIDevice currentDevice].systemVersion intValue];
}

+ (BOOL) isOSVersion_5_0
{
    return [[UIDevice currentDevice].systemVersion hasPrefix: @"5.0"];
}

+ (BOOL) isOSVersion_6
{
    return [[UIDevice currentDevice].systemVersion hasPrefix: @"6."];
}

+ (BOOL) isOSVersion_4_2
{
    return [[UIDevice currentDevice].systemVersion hasPrefix: @"4.2"];
}

+ (BOOL) isOSVersion_4_1
{
    return [[UIDevice currentDevice].systemVersion hasPrefix: @"4.1"];
}

+ (BOOL) isOSVersion_4
{
    return [[UIDevice currentDevice].systemVersion hasPrefix: @"4."];
}

+ (BOOL) isOSVersion_7
{
    return [[UIDevice currentDevice].systemVersion hasPrefix: @"7."];
}

+(BOOL) isOSVersionGreaterThan_7
{
    return [[UIDevice currentDevice].systemVersion floatValue] >= 7.0;
}

+(BOOL)isDeviceIphone
{
    NSString *deviceStr = [[UIDevice currentDevice] platform];
    if (deviceStr && [deviceStr hasPrefix:@"iPhone"]) {
        return YES;
    }
    
    return NO;
}

+(NSString *)createRandomNum:(int)count
{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    for (int i = 0; i < count; i++)
    {
        int num = arc4random()%10;
        [str appendFormat:@"%d", num];
    }
    
    return str;
}

+(NSString *)createUnicomUnikey
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    NSString *key = result;
    key = [key stringByReplacingOccurrencesOfString:@"-" withString:@""];
    key = [key lowercaseString];
    if (key && [key length] >= 32){
        NSRange range;
        range.location = 0;
        range.length = 32;
        key = [key substringWithRange:range];
    }else{
        key = [KGCommonTools createRandomNum:32];
    }

    return key;
}

+(BOOL)checkChinaPhone{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        [info release];
        return YES;
    }
    
    NSString *countrycode = [carrier mobileCountryCode];
    if (countrycode == nil || [countrycode isEqualToString:@""] || [countrycode isEqualToString:@"460"]) {
        [info release];
        return YES;
    }
    
    return NO;
}

+(BOOL)checkChinaMobile
{
    BOOL ret = NO;
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (carrier == nil)
    {
        [info release];
        return NO;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    
    if (code == nil || [code isEqualToString:@""])
    {
        [info release];
        return NO;
    }
    
    if ([code isEqualToString : @"00" ] || [code isEqualToString : @"02" ] || [code isEqualToString : @"07" ])
    {
        ret = YES;
    }
    
    [info release];
    
    return ret;
}

+(BOOL)checkSimCard{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        [info release];
        return NO;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil || [code isEqualToString:@""]) {
        [info release];
        return NO;
    }
    
    return YES;
}

+(BOOL)checkChinaUnicom
{
    BOOL ret = NO;
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        [info release];
        return NO;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil || [code isEqualToString:@""]) {
        [info release];
        return NO;
    }
    
    if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
        ret = YES;
    }
    [info release];
    
    return ret;
}

+(BOOL)isUnicomPorxy
{
    //    if ([[NetworkMgr networkMgrInstance]isNetConnected])
    //    {
    
    if (![[NetworkMgr networkMgrInstance]isWideNet] && ([ConfigProtocol getUnicomState] == 1 || [ConfigProtocol getUnicomState] == 2 || [ConfigProtocol getUnicomState] == 3) && [KGCommonTools checkChinaUnicom])
    {
        return YES;
    }
    //    }
    
    return NO;
}

+(BOOL)checkChinaTelecom
{
    BOOL ret = NO;
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        [info release];
        return NO;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil || [code isEqualToString:@""]) {
        [info release];
        return NO;
    }
    
    if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
        ret = YES;
    }
    [info release];
    
    return ret;
}

//剩余磁盘空间
+(NSString *) freeDiskSpaceInKBytes
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"%qi" ,freespace/1024];
}

//文件大小
+ (long long)fileSizeAtPath:(NSString* )filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

//文件夹大小
+ (long long)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

//获取文件夹大小（纯C方法，据说效率高很多）
+ (long long) _folderSizeAtPath: (const char*)folderPath
{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        int folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}


+(NSString*)unincomHeaderValue{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    NSString *key = result;
    key = [key stringByReplacingOccurrencesOfString:@"-" withString:@""];
    key = [key lowercaseString];
    if (key && [key length] >= 32){
        NSRange range;
        range.location = 0;
        range.length = 32;
        key = [key substringWithRange:range];
    }else{
        key = [KGCommonTools createRandomNum:32];
    }
    
    NSString *uuid = [StatisticInfo udid];
    NSString *phone = [ConfigProtocol getPhone];
    NSString *valueStr = [NSString stringWithFormat:@"union|0|%@|%@",phone, uuid];
    NSString *md5str = [NSString stringWithFormat:@"%@520kugou", valueStr];
    NSString *md5 = [md5str md5];
    NSString *str = [NSString stringWithFormat:@"%@|%@|%@", valueStr, md5, key];
    
    return str;
}

+(NSString*)unicomUserAgent{
    NSString *userAgent = [NSString stringWithFormat:@"iOS%@-Phone%@-%@-0-%@", [[UIDevice currentDevice] systemVersion],[StatisticInfo appVersion], [StatisticInfo channelFlag], [[NetworkMgr networkMgrInstance]isWideNet]?
                           @"WiFi":@"3gnet"];
    if ([KGCommonTools isUnicomPorxy]) {
        return [userAgent stringByAppendingString:@"-UNI(NORMAL)"];
    }
    return userAgent;
}

+(NSString*)telecomUserAgent{
    NSString *userAgent = [NSString stringWithFormat:@"iOS%@-Phone%@-kugoumusic", [[UIDevice currentDevice] systemVersion],[StatisticInfo appVersion]];
    return userAgent;
}

+(NSString *)proxyHost{
//#ifdef _DEBUG
//    proxystr = @"183.232.69.254";
//#else
//    proxystr =@"uninetagent.kugou.com";
//#endif
    
    if ([[[KGConfigEntity instance] numberOfKey:@"listen.switchparam.unicomproxyversion"] intValue] == 1) {
        return [[KGConfigEntity instance] stringOfKey:UNICOMMODULE_URL_NETAGENT]?:@"uninetagent.kugou.com";
    }
    
    return [[KGConfigEntity instance] stringOfKey:UNICOMMODULE_NETAGENT_HOST]?:@"kugou.gzproxy.10155.com";
}

+ (NSInteger)proxyPort
{
    if ([[[KGConfigEntity instance] numberOfKey:@"listen.switchparam.unicomproxyversion"] intValue] == 1) {
        return 8000;
    }
    return 8080;
}

+ (NSString *)proxyHeader
{
    if ([[[KGConfigEntity instance] numberOfKey:@"listen.switchparam.unicomproxyversion"] intValue] == 1) {
        if ([[UnicomVipState shareInstance]getVipState]) {
            return @"KG-Proxy-UNI-VIP";
        }else{
            return @"KG-Proxy-UNI";
        }
    }
    return @"Authorization";
}

+ (NSString *)proxyValue
{
    if ([[[KGConfigEntity instance] numberOfKey:@"listen.switchparam.unicomproxyversion"] intValue] == 1) {
        return [[self class] unincomHeaderValue];
    }
    NSString *auth = [SFHFKeychainUtils getPasswordForUsername:kChinaUnicomProductKey andServiceName:kChinaUnicomProductKey error:nil];
    return [@"Basic " stringByAppendingString:auth?:@"OTkwMDAxMDAwMDAwMjQwMDAwMDA6MjM0NXdlcnQ="];
}



+(int) headerOrignY
{
    if ([KGCommonTools isOSVersionGreaterThan_7])
    {
        return 64;
    }
    
    return 0;
}

+(int)barOrignY
{
    if ([KGCommonTools isOSVersionGreaterThan_7])
    {
        return 0;
    }
    
    return 20;
}

+ (BOOL) addSkipBackupAttributeToItemAtURL: (NSURL*)url  
{  
    return [KGCommonTools addSkipBackupAttributeToItemAtPath: [url path]];
} 

+ (BOOL) addSkipBackupAttributeToItemAtPath: (NSString*)path
{
    // 只有5.0及以上的版本才有iCloud的备份功能
    if ([KGCommonTools isOSVersion_5_0])
    {
        const char* filePath = [path fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else if ([KGCommonTools isOSVersion_5] || [KGCommonTools isOSVersion_6] || [KGCommonTools isOSVersionGreaterThan_7])
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_0
        NSString *pathTemp = [NSString stringWithString:path];
        NSURL *url = [NSURL fileURLWithPath:pathTemp]; // 本地路径
        NSError *error = nil;
        BOOL result = NO;
        result = [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return result;
#endif
    }
    
    return NO;
}

+(NSString *)changeNumberToString:(NSNumber *)str
{
    if (str != nil)
    {
        NSString* changeStr = nil;
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        changeStr = [numberFormatter stringFromNumber:str];
        [numberFormatter release];
        return changeStr;
    }
    else
    {
        return nil;
    }
}

+ (BOOL)isHDFromSongPathName:(NSString *)songPathName
{
    if (![songPathName isKindOfClass:[NSString class]])
    {
        return NO;
    }
    return [songPathName hasSuffix:@"_HQ.mp3"];
}

+ (BOOL) isUserQuiet
{
    CFStringRef state = nil; 
    UInt32 propertySize = sizeof(CFStringRef); 
    AudioSessionInitialize(NULL, NULL, NULL, NULL); 
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if (status == kAudioSessionNoError)
    {
        return (CFStringGetLength(state) == 0) || (state == nil);
    } 
    return NO; 
}

+ (SongInfo*) createSongInfoFromMusicInfo: (MusicInfo*)musicInfo
{
    if (musicInfo == nil)
    {
        return nil;
    }
     
    SongInfo* retSongInfo = [[SongInfo alloc] init];
    DLog(@"songname is :%@",musicInfo.songName);
    retSongInfo.fileName = musicInfo.songName;
    retSongInfo.strFileHash = musicInfo.strFileHash;
    retSongInfo.duration = musicInfo.duration;
    retSongInfo.fileSize = musicInfo.fileSize;
    retSongInfo.bitrate = musicInfo.bitrate;
    retSongInfo.superMp3Hash = musicInfo.superMp3Hash;
    retSongInfo.superMp3Size = musicInfo.superMp3Size;
    return  retSongInfo;
}

//+ (SongInfo*) createSongInfoFromManageAllMusic: (ManageAllMusic*)manageAllMusic
//{
//    if (manageAllMusic == nil)
//    {
//        return nil;
//    }
//    
//    SongInfo* retSongInfo = [[SongInfo alloc] init];
//    retSongInfo.fileName = manageAllMusic.MusicName;
//    retSongInfo.strFileHash = manageAllMusic.MusicHash;
//    retSongInfo.duration = manageAllMusic.MusicTime;
//    retSongInfo.fileSize = manageAllMusic.FileSize;
//    retSongInfo.bitrate = manageAllMusic.BitRate;
//    retSongInfo.songURL = manageAllMusic.MusicPath;
//    retSongInfo.superMp3Hash = manageAllMusic.superHash;
//    retSongInfo.superMp3Size = manageAllMusic.superSize;
//    if (manageAllMusic.Mp3FileSize > 0.0)
//    {
//        retSongInfo.mp3FileSize = manageAllMusic.Mp3FileSize;
//        retSongInfo.m4aFileSize = manageAllMusic.M4aFileSize;
//    }
//    else 
//    {   // 估算
//        retSongInfo.mp3FileSize = retSongInfo.fileSize;
//        if (retSongInfo.fileSize > 0 && retSongInfo.bitrate > 0)
//        {
//            retSongInfo.m4aFileSize = retSongInfo.bitrate * retSongInfo.fileSize / 1024;
//        }
//        else 
//        {
//            retSongInfo.m4aFileSize = 1 * 1024 * 1024;
//        }
//    }
//
//    NSString *artistName;
//    NSString *str_title;
//    if (![manageAllMusic.Singer isEqualToString:@""]) 
//    {
//        artistName = [[NSString alloc]initWithFormat:@"%@",manageAllMusic.Singer];
//    }
//    else
//    {
//        artistName = [[NSString alloc]initWithFormat:@"未知"];
//    }
//    
//    if ([artistName isEqualToString:@"(null)"]) 
//    {
//        [artistName release];
//        artistName = [[NSString alloc]initWithFormat:@"未知"];
//    }
//    
//    if (![artistName isEqualToString:@"未知"]) 
//    {
//        str_title = [[NSString alloc]initWithFormat:@"%@ - %@",manageAllMusic.Singer,manageAllMusic.MusicName];
//    }
//    else
//    {
//        str_title = [[NSString alloc]initWithFormat:@"%@",manageAllMusic.MusicName];
//    }
//    
//    [artistName release];
//    
//    if (manageAllMusic.MusicAttribution == 2)   
//    {
//        retSongInfo.musictitle = retSongInfo.fileName;
//        retSongInfo.storeType = STORE_TYPE_ONLINE;
//#ifdef _IPHONE_
//        // 此歌曲可能在边听边存时变为本地歌曲
//        kugouAppDelegate* app = [kugouAppDelegate App];
//        MusicInfo *targetMusic = nil;
//        [app.downloadListLock lock];
//        for (MusicInfo* si in [app.downloadMusicList allValues])
//        {
//            if ([si.strFileHash isKindOfClass:[NSString class]] && [si.strFileHash compare: retSongInfo.strFileHash options: NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
//            {
//                targetMusic = si;
//                break;
//            }
//        }
//        [app.downloadListLock unlock];
//        if (targetMusic)
//        {
//            retSongInfo.storeType = STORE_TYPE_LOCAL;
//            retSongInfo.songURL = targetMusic.songURL;
//        }
//#endif
//    }
//    else if (manageAllMusic.MusicAttribution == 1)
//    {   // 已下载的歌曲
//        retSongInfo.musictitle = retSongInfo.fileName;
//        retSongInfo.storeType = STORE_TYPE_LOCAL;
//    }
//    else 
//    {   // == 0 ipod的歌曲
//        retSongInfo.musictitle = str_title;
//        retSongInfo.storeType = STORE_TYPE_LOCAL;
//    }
//    [str_title release];
//    //DLog(@"%@  ===== %@   ==== %d   ===%@",retSongInfo.musictitle,retSongInfo.fileName ,manageAllMusic.MusicAttribution,manageAllMusic.Singer);
//    return  retSongInfo;
//}

+ (SongInfo*) createSongInfoFromFileHash: (NSString*)fileHash fileName: (NSString*)fileName
{
    if (![fileHash isKindOfClass:[NSString class]] || fileHash == nil)
    {
        return nil;
    }
    
    SongInfo* retSongInfo = [[SongInfo alloc] init];
    NSMutableDictionary* targetInfo = [DownLoadUrlProtocol downloadSongInfo: fileHash isMp3: YES];
    double songDuration = [[targetInfo kg_numberForKey: @"timeLength"] doubleValue];
    retSongInfo.duration = songDuration;
    retSongInfo.fileSize = [[targetInfo kg_numberForKey: @"fileSize"]intValue];
    retSongInfo.bitrate = [[targetInfo kg_numberForKey: @"bitRate"]intValue] / 1000;
    retSongInfo.fileName = fileName;
    retSongInfo.strFileHash = fileHash;
    return  retSongInfo;
}

//+(NSMutableArray *)musicis:(int)ower Inmusics:(NSArray*)allmusic
//{
//    NSMutableArray *owerArray = [[NSMutableArray alloc]init];
//    if (ower==0)
//    {
//        for (int i = 0; i< [allmusic count]; i++)
//        {
//            CellInfo *cinfo = [allmusic objectAtIndex:i];
//            SongInfo *info = cinfo.m_object;
//            if ( [info.songURL rangeOfString:@"ipod-library://"].length ==[@"ipod-library://" length])
//            {
//                [owerArray addObject:cinfo];
//            }
//        }
//    }
//    else
//    {
//        for (int i = 0; i< [allmusic count]; i++)
//        {
//            CellInfo *cinfo = [allmusic objectAtIndex:i];
//            SongInfo *info = cinfo.m_object;
//            if ([info.songURL rangeOfString:@"ipod-library://"].length !=[@"ipod-library://" length])
//            {
//                [owerArray addObject:cinfo];
//            }
//        }
//    }
//    return owerArray;
//}

+ (BOOL) playLocalSongWhenExist: (SongInfo*)targetSong
{
//    if (targetSong == nil)
//    {
//        return NO;
//    }
//    
//    MusicInfo* music = [ManageAllMusic createMusicInfoKey: @"musichash" andValue: targetSong.strFileHash];
//    if (music)
//    {
//        musicplayengine* musicEngine = [musicplayengine CreateSingleton];
//        
//        if ([music.fileURL isEqualToString: [musicEngine curPlayMusicURL]]) 
//        {
//            
//        }
//        else
//        {
//            [musicEngine stopAudio];
//            [musicEngine play: music bIsPlayOnline: FALSE];
//        }
//        
//        [music release];
//        
//        return YES;
//    }
//    
    return NO;
}

+ (SongInfo *)localSongInfoForHash:(NSString *)strHash
{
    if (strHash == nil || [strHash length] <= 0)
    {
        return nil;
    }
    
    SongInfo* retSong = (SongInfo *)[ManageAllMusic createLocalMusicByHash:strHash];
    // 对于覆盖安装，本地歌曲路径发生变化
    NSString *realPath = [KGCommonTools realLocalSongPath:retSong.songURL];
    if (realPath == nil || ![fileengine isFileExistByFullPath:realPath])
    {
        [retSong release];
        return nil;
    }
   
    retSong.songURL = realPath;
    
    return retSong;
}

+(NSString *)offlineMusicPathName:(NSString*)srcPathName
{
    if (srcPathName == nil)
    {
        return nil;
    }
    
    NSRange range = [srcPathName rangeOfString:DOWN_OFFLINE_TARGET_DIR];
    if (range.location != NSNotFound)
    {
        NSString* docTemp = [fileengine GetDocumentPath];
        NSString* fileName = [srcPathName substringFromIndex: (range.location + range.length + 1)];
        NSString* retPathName = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", DOWN_OFFLINE_TARGET_DIR, fileName]];
        return retPathName;
    }
    return nil;
}



+(NSString *)cacheMusicPathName:(NSString*)srcPathName
{
    if (srcPathName == nil)
    {
        return nil;
    }
    
    NSRange range = [srcPathName rangeOfString:CACHE_TARGET_DIR];
    if (range.location != NSNotFound)
    {
        NSString* docTemp = [fileengine GetDocumentPath];
        NSString* fileName = [srcPathName substringFromIndex: (range.location + range.length + 1)];
        NSString* retPathName = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", CACHE_TARGET_DIR, fileName]];
        return retPathName;
    }
    return nil;
    
}

+ (SongInfo *)localSongInfoForName:(NSString *)strName
{
    if (strName == nil || [strName length] <= 0)
    {
        return nil;
    }
    
    SongInfo* retSong = (SongInfo *)[ManageAllMusic createMusicInfoKey: @"musicname" andValue: strName];
    // 对于覆盖安装，本地歌曲路径发生变化
    NSString *realPath = [KGCommonTools realLocalSongPath:retSong.songURL];
    if (realPath == nil || ![fileengine isFileExistByFullPath:realPath])
    {
        [retSong release];
        return nil;
    }
    
    retSong.songURL = realPath;
    
    return retSong;
}

+ (NSString *)cacheKTVAccompanyDir
{
    NSString* docTemp = [fileengine libraryCachesPath];
    NSString* targetDir = [NSString stringWithFormat: @"%@/%@", docTemp, @"kgtemp"];
    return targetDir;
}

+ (NSString *)cacheFilePath:(NSString *)fileName
{
    NSString* dir = [KGCommonTools cacheFileDir];
    NSString* targetPath = [NSString stringWithFormat: @"%@/%@", dir, fileName];
    return targetPath;
}

+ (NSString *)cacheFileDir
{
    NSString* docTemp = [fileengine GetDocumentPath];
    NSString* targetDir = [docTemp stringByAppendingPathComponent:CACHE_TARGET_DIR];
    return targetDir;
}

+ (NSString*) offlineFilePath:(NSString *)fileName
{
    NSString* dir = [KGCommonTools offlineFileDir];
    NSString* targetPath = [NSString stringWithFormat: @"%@/%@", dir, fileName];
    return targetPath;
}
+ (NSString*) offlineFileDir
{
    NSString* docTemp = [fileengine GetDocumentPath];
    NSString* targetDir = [docTemp stringByAppendingPathComponent:OFFLINE_DOWN_TARGET_DIR];
    return targetDir;
}

+ (NSString*) offlineTempFilePath:(NSString *)fileName
{
    NSString* tempTemp = [fileengine libraryCachesPath];
    NSString* targetDir = [NSString stringWithFormat: @"%@/%@/%@.!kg", tempTemp, OFFLINE_DOWN_TEMP_DIR, fileName];
    return targetDir;
}

+ (NSString*) targetFilePath: (NSString*)fileName
{
    //NSString* docTemp = [fileengine libraryCachesPath];
    NSString* dir = [KGCommonTools targetFileDir];
    NSString* targetPath = [NSString stringWithFormat: @"%@/%@", dir, fileName];
    return targetPath;
}
+ (NSString*) targetFileDir
{
    NSString* docTemp = [fileengine GetDocumentPath];
    NSString* targetDir = [docTemp stringByAppendingPathComponent:DOWN_TARGET_DIR];
    return targetDir;
}

+ (NSString*) tempFilePath: (NSString*)fileName
{
    NSString* tempTemp = [fileengine libraryCachesPath];
    NSString* targetDir = [NSString stringWithFormat: @"%@/%@/%@.!kg", tempTemp, DOWN_TEMP_DIR, fileName];
    return targetDir;
}

+ (NSString*) MVFilePath:(NSString *)fileHash
{
    NSString* dir = [KGCommonTools MVFileDir];
    NSString* targetPath = [NSString stringWithFormat: @"%@/%@.mp4", dir, fileHash];
    return targetPath;
}

+ (NSString*) MVFileDir
{
    NSString* docTemp = [fileengine GetDocumentPath];
    NSString * targetDir  = [docTemp stringByAppendingPathComponent:DOWN_MV_DIR];
    return targetDir;
}

+ (NSString*) tempMVPath:(NSString *)fileHash
{
    NSString* tempTemp = [fileengine libraryCachesPath];
    NSString* targetDir = [NSString stringWithFormat: @"%@/%@/%@.mp4", tempTemp, DOWN_TEMP_DIR, fileHash];
    return targetDir;
}

+ (BOOL)isLRC:(NSString *)lyrics
{
    if (lyrics.length > 0)
    {
        NSString *expression = @"\\[\\d{1,2}:\\d{1,2}\\.\\d{1,2}\\].+";
        NSRegularExpression* regex = [[NSRegularExpression alloc]initWithPattern:expression options:0 error:nil];
        NSArray* chunks = [regex matchesInString:lyrics options:0 range:NSMakeRange(0, [lyrics length])];
        
        return chunks.count > 0;
    }
    return NO;
}

+ (NSString*) createFileNameFromSongInfo: (SongInfo*)songInfo
{
    //DLog(@"%@  %@", songInfo.fileName, [songInfo.songURL pathExtension]);
    /*
     * songURL很可能还为空
    NSString* fileName = [[NSString alloc]initWithFormat: @"%@.%@", songInfo.fileName,
                          [songInfo.songURL pathExtension]];
     */
    
    NSString *strExt = @".mp3";
//    if (songInfo.downloadFileType == SONG_INFO_M4A)
//    {
//        strExt = @".m4a";
//    }
//    else if (songInfo.downloadFileType == SONG_INFO_SUPER_MP3)
//    {
//        strExt = @"_HQ.mp3";
//    }
    NSString* fileName = [[NSString alloc]initWithFormat: @"%@%@", songInfo.fileName,
                          strExt];
    return fileName;
}

//编辑列表本地数组（根据名字）排序
+(NSArray *)sortEditLocalListArray:(NSArray *)arry and:(NSString *)keyString
{ 
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:keyString ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [arry sortedArrayUsingDescriptors:sortDescriptors];
    [sorter release];
    [sortDescriptors release];
    
    NSMutableArray *templetterName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *tempName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *tempNameArray = [[NSMutableArray alloc] initWithCapacity:27]; 
    for (int i = 0; i < 53; i++) 
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [tempNameArray addObject:array];
        [array release];
    }
    for (int i = 0;i<[sortedArray count];i++)
    {  
        MusicInfo *info = [sortedArray objectAtIndex:i];
        NSString *sectionName = nil;
        if ([keyString isEqualToString:@"fileName"]) 
        {
            if (info.fileName && [info.fileName length] > 0)
            {
                sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([info.fileName characterAtIndex:0])] uppercaseString];
            }
        }

        if (sectionName) 
        {
            if (sectionName>0)
            {
                NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
                if (firstLetter != NSNotFound)
                {
                    [[tempNameArray objectAtIndex:firstLetter] addObject:info];
                }else
                {
                    [[tempNameArray objectAtIndex:52] addObject:info];
                }
            }
            else
            {
                [[tempNameArray objectAtIndex:52] addObject:info];
            }
        }
        
    }
    for (int i=0; i<53;i++)
    {
        if ([[tempNameArray objectAtIndex:i] count]>0)
        {
            for (int j=0; j<[[tempNameArray objectAtIndex:i] count];j++)
            {
                MusicInfo *testInfo =[[tempNameArray objectAtIndex:i] objectAtIndex:j];
                NSString *sectionName = nil;
                sectionName = testInfo.fileName;
                
                if (sectionName>0)
                {
                    NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
                    if (firstLetter != NSNotFound)
                    {
                        // DLog(@"NSNotFound name is---------%@",sectionName);
                        [tempName addObject:testInfo];
                    }
                    else
                    {
                        [templetterName addObject:testInfo];
                    }
                }
                
                // DLog(@"name is---------%@",testInfo.musictitle);
            }
        }
    }
    [tempNameArray release];
    [tempName addObjectsFromArray:templetterName];
    [templetterName release];
    
    return tempName;
    
}

//编辑列表ipod数组（根据名字）排序
//+(NSArray *)sortEditListArray:(NSArray *)arry and:(NSString *)keyString
//{ 
//    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:keyString ascending:YES];
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
//    NSArray *sortedArray = [arry sortedArrayUsingDescriptors:sortDescriptors];
//    [sorter release];
//    [sortDescriptors release];
//    
//    NSMutableArray *templetterName = [[NSMutableArray alloc] initWithCapacity:50];
//    NSMutableArray *tempName = [[NSMutableArray alloc] initWithCapacity:50];
//        NSMutableArray *tempNameArray = [[NSMutableArray alloc] initWithCapacity:27]; 
//        for (int i = 0; i < 53; i++) 
//        {
//            NSMutableArray* array = [[NSMutableArray alloc] init];
//            [tempNameArray addObject:array];
//            [array release];
//        }
//        for (int i = 0;i<[sortedArray count];i++)
//        {  
//            ManageAllMusic *info = [sortedArray objectAtIndex:i];
//            NSString *sectionName = nil;
//            if ([keyString isEqualToString:@"MusicName"] || [keyString isEqualToString:@"fileName"]) 
//            {
//                if (info.MusicName && [info.MusicName length] > 0)
//                {
//                    sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([info.MusicName characterAtIndex:0])] uppercaseString];
//                }
//            }
//            
//            if (sectionName) 
//            {
//                if (sectionName>0)
//                {
//                    NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
//                    if (firstLetter != NSNotFound)
//                    {
//                        [[tempNameArray objectAtIndex:firstLetter] addObject:info];
//                    }else
//                    {
//                        [[tempNameArray objectAtIndex:52] addObject:info];
//                    }
//                }
//                else
//                {
//                    [[tempNameArray objectAtIndex:52] addObject:info];
//                }
//            }
//            
//        }
//        for (int i=0; i<53;i++)
//        {
//            if ([[tempNameArray objectAtIndex:i] count]>0)
//            {
//                for (int j=0; j<[[tempNameArray objectAtIndex:i] count];j++)
//                {
//                    ManageAllMusic *testInfo =[[tempNameArray objectAtIndex:i] objectAtIndex:j];
//                    NSString *sectionName = nil;
//                        
//                    sectionName = testInfo.MusicName;
//                    
//                    if (sectionName>0)
//                    {
//                        NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
//                        if (firstLetter != NSNotFound)
//                        {
//                            // DLog(@"NSNotFound name is---------%@",sectionName);
//                            [tempName addObject:testInfo];
//                        }
//                        else
//                        {
//                            [templetterName addObject:testInfo];
//                        }
//                    }
//                    
//                    // DLog(@"name is---------%@",testInfo.musictitle);
//                }
//            }
//        }
//        [tempNameArray release];
//        [tempName addObjectsFromArray:templetterName];
//        [templetterName release];
//        
//        return tempName;
//        
//}

//文件名数组排序
+(NSMutableArray *)sortStringArrayWithOnlyABC:(NSArray*)sortedArray
{
    sortedArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(NSString *str1,NSString *str2){
        NSComparisonResult result = [str1 compare:str2];
        return result;
    }];
    
//    NSMutableArray *templetterName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *tempName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *tempNameArray = [[NSMutableArray alloc] initWithCapacity:27];
    for (int i = 0; i < 53; i++)
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [tempNameArray addObject:array];
        [array release];
    }
    for (int i = 0;i<[sortedArray count];i++)
    {
        NSString *info = [sortedArray objectAtIndex:i];
        NSString *sectionName = nil;
        if (info && info.length > 0)
        {
            sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([info characterAtIndex:0])] uppercaseString];
        }
        
        if (sectionName)
        {
            if (sectionName.length > 0)
            {
                NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
                if (firstLetter != NSNotFound)
                {
                    [[tempNameArray objectAtIndex:firstLetter] addObject:info];
                }else
                {
                    [[tempNameArray objectAtIndex:52] addObject:info];
                }
            }
            else
            {
                [[tempNameArray objectAtIndex:52] addObject:info];
            }
        }
        
    }
    for (int i=0; i<tempNameArray.count; i++) {
        [tempName addObjectsFromArray:[tempNameArray objectAtIndex:i]];
    }
    [tempNameArray release];
    [tempName autorelease];
    return tempName;
    
}

+(NSMutableArray *)sortStringArray:(NSArray*)sortedArray
{
    
    NSMutableArray *templetterName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *tempName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *tempNameArray = [[NSMutableArray alloc] initWithCapacity:27]; 
    for (int i = 0; i < 53; i++) 
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [tempNameArray addObject:array];
        [array release];
    }
    for (int i = 0;i<[sortedArray count];i++)
    {  
        NSString *info = [sortedArray objectAtIndex:i];
        NSString *sectionName = nil;
        if (info && info.length > 0)
        {
            sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([info characterAtIndex:0])] uppercaseString];
        }
        
        if (sectionName) 
        {
            if (sectionName.length > 0)
            {
                NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
                if (firstLetter != NSNotFound)
                {
                    [[tempNameArray objectAtIndex:firstLetter] addObject:info];
                }else
                {
                    [[tempNameArray objectAtIndex:52] addObject:info];
                }
            }
            else
            {
                [[tempNameArray objectAtIndex:52] addObject:info];
            }
        }
        
    }
    for (int i=0; i<53;i++)
    {
        if ([[tempNameArray objectAtIndex:i] count]>0)
        {
            for (int j=0; j<[[tempNameArray objectAtIndex:i] count];j++)
            {
                NSString *testInfo =[[tempNameArray objectAtIndex:i] objectAtIndex:j];
                NSString *sectionName = nil;
                
                sectionName = testInfo;
                
                if (sectionName.length > 0)
                {
                    NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
                    if (firstLetter != NSNotFound)
                    {
                        // DLog(@"NSNotFound name is---------%@",sectionName);
                        [tempName addObject:testInfo];
                    }
                    else
                    {
                        [templetterName addObject:testInfo];
                    }
                }
                
                // DLog(@"name is---------%@",testInfo.musictitle);
            }
        }
    }
    [tempNameArray release];
    [tempName addObjectsFromArray:templetterName];
    [templetterName release];
    
    return tempName;
}

//ipod歌曲，下载歌曲数组（根据名字）排序
+(NSMutableArray *)sortArray:(NSArray *)arry and:(NSString *)keyString
{ 
//    for (int i = 0; i < [arry count]; i++)
//    {
//        MusicInfo *info = [arry objectAtIndex:i];
//        DLog(@"info name is-------%@",info.musicId);
//    }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:keyString ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [arry sortedArrayUsingDescriptors:sortDescriptors];
    [sorter release];
    [sortDescriptors release];
    
//    DLog(@"//////////////////////////////////////////////////");
//    
//    for (int j = 0; j < [sortedArray count]; j++)
//    {
//        MusicInfo *info = [sortedArray objectAtIndex:j];
//        DLog(@"info name is-------%@",info.musicId);
//    }
    
    NSMutableArray *templetterName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *tempName = [[NSMutableArray alloc] initWithCapacity:50];
    if (isFirstOrTime || [keyString isEqualToString:@"musictitle"])
    {

        NSMutableArray *tempNameArray = [[NSMutableArray alloc] initWithCapacity:27]; 
        for (int i = 0; i < 53; i++) 
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [tempNameArray addObject:array];
            [array release];
        }
        for (int i = 0;i<[sortedArray count];i++)
        {  
            MusicInfo *info = [sortedArray objectAtIndex:i];
            NSString *sectionName = nil;
            if ([keyString isEqualToString:@"musictitle"]) 
            {
                if (info.musictitle && [info.musictitle length] > 0)
                {
                    sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([info.musictitle characterAtIndex:0])] uppercaseString];
                }
            }
            else
            {
                if (info.songName && [info.songName length] > 0)
                {
                    sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([info.songName characterAtIndex:0])] uppercaseString];
                }
            }
            
            if (sectionName) 
            {
                if (sectionName.length > 0)
                {
                    NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
                    if (firstLetter != NSNotFound)
                    {
                        [[tempNameArray objectAtIndex:firstLetter] addObject:info];
                    }
                    else
                    {
                        [[tempNameArray objectAtIndex:52] addObject:info];
                    }
                }
                else
                {
                    [[tempNameArray objectAtIndex:52] addObject:info];
                }
            }
            
        }
        for (int i=0; i<53; i++)
        {
            if ([[tempNameArray objectAtIndex:i] count] > 0)
            {
                for (int j=0; j<[[tempNameArray objectAtIndex:i] count]; j++)
                {
                    MusicInfo *testInfo =[[tempNameArray objectAtIndex:i] objectAtIndex:j];
                    NSString *sectionName = nil;
                    if ([keyString isEqualToString:@"musictitle"]) 
                    {
                        sectionName = testInfo.musictitle;
                    }
                    else
                    {
                        sectionName = testInfo.songName;
                    }
                    
                    if (sectionName.length > 0)
                    {
                        NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
                        if (firstLetter != NSNotFound)
                        {
                            // DLog(@"NSNotFound name is---------%@",sectionName);
                            [tempName addObject:testInfo];
                        }
                        else
                        {
                            [templetterName addObject:testInfo];
                        }
                    }
                    
                    // DLog(@"name is---------%@",testInfo.musictitle);
                }
            }
        }
        [tempNameArray release];
        [tempName addObjectsFromArray:templetterName];
        [templetterName release];
        
        return tempName;
    
    }
    else
    {
        [tempName removeAllObjects];
        for (int i=0; i<[sortedArray count]; i++)
        {
            [tempName addObject:[sortedArray objectAtIndex:[sortedArray count]-1-i]];
        }
        return tempName;
    }
    
}

//数组（根据名字）排序,获取字母索引
+(NSMutableArray *)sortArrayAndForIndex:(NSArray *)arry and:(NSString *)keyString
{ 
    //    for (int i = 0; i < [arry count]; i++)
    //    {
    //        MusicInfo *info = [arry objectAtIndex:i];
    //        DLog(@"info name is-------%@",info.musicId);
    //    }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:keyString ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [arry sortedArrayUsingDescriptors:sortDescriptors];
    [sorter release];
    [sortDescriptors release];
    
    //        DLog(@"//////////////////////////////////////////////////");
    //        
    //        for (int j = 0; j < [sortedArray count]; j++)
    //        {
    //            MusicInfo *info = [sortedArray objectAtIndex:j];
    //            DLog(@"info name is-------%@",info.musictitle);
    //        }
    
    NSMutableArray *templetterName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *tempName = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableDictionary *indexDict = [[NSMutableDictionary alloc] initWithCapacity:27];
    if (isFirstOrTime || [keyString isEqualToString:@"musictitle"])
    {
        
        NSMutableArray *tempNameArray = [[NSMutableArray alloc] initWithCapacity:27]; 
        for (int i = 0; i < 27; i++) 
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [tempNameArray addObject:array];
            [array release];
        }
        for (int i = 0;i<[sortedArray count];i++)
        {  
            MusicInfo *info = [sortedArray objectAtIndex:i];
            NSString *sectionName = nil;
            if ([keyString isEqualToString:@"musictitle"]) 
            {
                if (info.musictitle && [info.musictitle length] > 0)
                {
                    // DLog(@"musictitle is////%@ ",info.musictitle);
                    sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([info.musictitle characterAtIndex:0])] uppercaseString];
                    //DLog(@"senctionName///%@ and title is %@",sectionName,info.musictitle);
                }
            }
            else
            {
                if (info.songName && [info.songName length] > 0)
                {
                    // DLog(@"musictitle is////%@ ",info.songName);
                    sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([info.songName characterAtIndex:0])] uppercaseString];
                }
            }
            
            if (sectionName) 
            {
                if (sectionName.length > 0)
                {
                    NSUInteger firstLetter = [ALPHAFORBIG rangeOfString:[[sectionName substringToIndex:1] uppercaseString]].location;
                    if (firstLetter != NSNotFound)
                    {
                        // DLog(@"sectionName is////%@ and firstLetter is %d",sectionName,firstLetter);
                        [[tempNameArray objectAtIndex:firstLetter] addObject:info];
                    }
                    else
                    {
                        [[tempNameArray objectAtIndex:26] addObject:info];
                    }
                }
                else
                {
                    [[tempNameArray objectAtIndex:26] addObject:info];
                }
            }
            
        }
        char character = 'A';
        int musicCount = 0;
        for (int i=0; i<27; i++)
        {
            NSString *_indexChar = [NSString stringWithFormat:@"%c",character ++];
            int musicCountForIndex = [[tempNameArray objectAtIndex:i] count];
            musicCount = musicCount +musicCountForIndex;
            
            if (musicCountForIndex > 0)
            {
                for (int j=0; j< musicCountForIndex; j++)
                {
                    MusicInfo *testInfo =[[tempNameArray objectAtIndex:i] objectAtIndex:j];
                    NSString *sectionName = nil;
                    if ([keyString isEqualToString:@"musictitle"]) 
                    {
                        sectionName = testInfo.musictitle;
                    }
                    else
                    {
                        sectionName = testInfo.songName;
                    }
                    
                    if (sectionName.length > 0)
                    {
                        sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([sectionName characterAtIndex:0])] uppercaseString];
                        //                        NSUInteger firstLetter = [ALPHAFORBIG rangeOfString:[[sectionName substringToIndex:1] uppercaseString]].location;
                        NSUInteger firstLetter = [ALPHAFORBIG rangeOfString:sectionName].location;
                        if (firstLetter != NSNotFound)
                        {
                            // DLog(@"NSNotFound name is---------%@",testInfo.musictitle);
//                            testInfo.PYFirstLetter = sectionName;
                            [tempName addObject:testInfo];
                        }
                        else
                        {
//                            testInfo.PYFirstLetter = @"#";
                            [templetterName addObject:testInfo];
                            // DLog(@"Found name is---------%@",testInfo.musictitle);
                        }
                    }
                    
                    // DLog(@"name is---------%@",testInfo.musictitle);
                }
            }
            if (i == 26)
            {
                [indexDict setObject:[NSString stringWithFormat:@"%d",musicCount - musicCountForIndex] forKey:@"#"];
            }
            else if (i == 0)
            {
                [indexDict setObject:[NSString stringWithFormat:@"%d",0] forKey:_indexChar];
            }
            else
            {
                [indexDict setObject:[NSString stringWithFormat:@"%d",musicCount - musicCountForIndex] forKey:_indexChar];
            }
        }
        
        [tempNameArray release];
        [tempName addObjectsFromArray:templetterName];
        [templetterName release];
        
        NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:2];
        [returnArray addObject:tempName];
        [returnArray addObject:indexDict];
        [indexDict release];
        [tempName release];
        return returnArray;
        
    }
    else
    {
        [tempName removeAllObjects];
        for (int i=0; i<[sortedArray count]; i++)
        {
            [tempName addObject:[sortedArray objectAtIndex:[sortedArray count]-1-i]];
        }
        return tempName;
    }
    
}

+(NSArray *)filterLocalSameSongNameInArray:(NSArray *)array{
    // 找出重复的歌曲，加序号
    NSMutableArray * sameIndexArray = [NSMutableArray array];
    int marked[array.count];
    for (int i = 0; i < array.count; i++) {
        marked[i] = 0;
    }
    for (int i = 0; i < array.count; i++) {
        SongInfo * obj1 = array[i];
        BOOL isLowMp3 = ([obj1 isKindOfClass:[LocalMusicSongInfo class]] && (((LocalMusicSongInfo *)obj1).qualityType<=2))
        || ( [obj1 isKindOfClass:[DownTaskInfo class]] && (((DownTaskInfo *)obj1).quality<=2) );
        if ( isLowMp3 && marked[i] != 1 ) {
            for (int j = 0; j < array.count; j++) {
                SongInfo * obj2 = array[j];
                BOOL isLowMp32 = ([obj2 isKindOfClass:[LocalMusicSongInfo class]] && (((LocalMusicSongInfo *)obj2).qualityType<=2))
                || ( [obj2 isKindOfClass:[DownTaskInfo class]] && (((DownTaskInfo *)obj2).quality<=2) );
                int markj = marked[j];
                if ( isLowMp32 &&  markj!= 1 ) {
                    if ( (obj1 != obj2) && [obj1.musicName isEqualToString:obj2.musicName] ) {
                        if ( [obj1 isKindOfClass:[LocalMusicSongInfo class]] ) {
                            LocalMusicSongInfo * local1 = (LocalMusicSongInfo*)obj1;
                            if ( local1.qualityType == MUSIC_QUALITY_TYPE_MP3 ) {
                                [sameIndexArray addObject:@(i)];
                            }else{
                                [sameIndexArray addObject:@(j)];
                            }
                        }else if ( [obj1 isKindOfClass:[DownTaskInfo class]] ) {
                            DownTaskInfo * local1 = (DownTaskInfo*)obj1;
                            if ( local1.quality == MUSIC_QUALITY_TYPE_MP3 ) {
                                [sameIndexArray addObject:@(i)];
                            }else{
                                [sameIndexArray addObject:@(j)];
                            }
                        }
                        marked[i] = 1;
                        marked[j] = 1;
                    }
                }
            }
        }
    }
    //
    int i = 0;
    for (NSNumber * indexNumber in sameIndexArray) {
        int realIndex = [indexNumber intValue];
        SongInfo * info = [array objectAtIndex:realIndex];
        info.musictitle = [NSString stringWithFormat:@"%@(1)", info.musicName];
        i++;
    }
    return array;
}

+ (void)cacheSongs:(NSArray *)songs
{
    NSMutableArray *newSongs = [NSMutableArray arrayWithCapacity:20];
    for (DownTaskInfo *si in songs)
    {
        //if ([si isOnline])
        {
            if (si.musicpath == nil)
            {   // 在线歌曲
                BOOL ishave = NO;
//                if (si.strFileHash != nil)
//                {
//                    //已经存在
//                    int  downLoadType = [[DownloadBLL shareInstance] getAlreadyDownloadItem:si];
//                    if (downLoadType == 3)
//                    {
//                        ishave = YES;
//                    }
//                    else
//                    {
//                        ishave = NO;
//                    }
//                }
                
                if (!ishave)
                {
                    [newSongs addObject:si];
                }
            }
            else if ([[LocalMusicBLL sharedSingleton] isExistLocalMusic:si])
            {
                
            }
            else
            {
                [newSongs addObject:si];
            }
        }
    }
    
    if (newSongs != nil && [newSongs count] > 0)
    {
        [[KGDownloadAPI shareInstance] notifyDownInfo:DOWNLOAD_INFO_BATCH_QUALITY_ADD_ITEM targetRequest:newSongs];
    }
    else
    {
        [[KGProgressView windowProgressView] showErrorWithStatus:Tips_Center_AlreadyCached duration:3];
    }
}


+ (BOOL)isHashEqual: (NSString*)leftHash toOther: (NSString*)rightHash
{
    if (![leftHash isKindOfClass:[NSString class]] || ![rightHash isKindOfClass:[NSString class]])
    {
        return NO;
    }
    
    if (leftHash == nil && nil == rightHash)
    {
        return YES;
    }
    if (leftHash == nil || rightHash == nil)
    {
        return NO;
    }
    
    if ([leftHash compare: rightHash options:NSCaseInsensitiveSearch | NSNumericSearch]
        == NSOrderedSame)
    {
        return YES;
    }
    return NO;
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert withAlpha:(float)alph
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (alph < 0.0)
    {
        alph = 0.0f;
    }
    else if(alph > 1.0)
    {
        alph = 1.0f;
    }
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alph];
}

+ (void) notifyShowCurrentSongTitle: (NSString *)songTitle
{
    //[[musicplayengine CreateSingleton]setCurSongTitle:songTitle];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [[NSNotificationCenter defaultCenter]postNotificationName: NOTIFY_SHOW_CURRENT_SONG_TITLE
                                                           object: songTitle];
    });
    
}

+ (void)boxOnMainThread:(NSString *)info
{
    UIAlertView* alerView = [[UIAlertView alloc] initWithTitle: @"..."
                                                       message: info
                                                      delegate: nil
                                             cancelButtonTitle: @"收到"
                                             otherButtonTitles: nil];
    [alerView show];
    [alerView release];
}

+ (void) msgBox: (NSString*) info
{
    [self performSelectorOnMainThread: @selector(boxOnMainThread:) withObject: info waitUntilDone: YES];
}

+ (void)tipMsgBox:(NSString*)info title:(NSString*)title
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView* alerView = [[UIAlertView alloc] initWithTitle: title
                                                           message: info
                                                          delegate: nil
                                                 cancelButtonTitle: @"确定"
                                                 otherButtonTitles: nil];
        [alerView show];
        [alerView release];
    });
}

+ (NSArray*) tokenDate: (NSDate*)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | 
    NSMonthCalendarUnit |
    NSDayCalendarUnit | 
    NSWeekdayCalendarUnit | 
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int year = [comps year]; 
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int min = [comps minute];
    int sec = [comps second];
    
    DLog(@"year%d",year);
    DLog(@"month%d",month);
    DLog(@"day%d",day);
    DLog(@"hour%d",hour);
    DLog(@"min%d",min);
    DLog(@"sec%d",sec);
    
    [formatter release];
    [calendar release];
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt: year],
            [NSNumber numberWithInt: month],
            [NSNumber numberWithInt: day],
            [NSNumber numberWithInt: hour],
            [NSNumber numberWithInt: min],
            [NSNumber numberWithInt: sec],
            nil];
}

+ (NSString *)realFileURL:(SongInfo *)songInfo
{
    NSString *ret = nil;
    if ([songInfo isKindOfClass:[MusicInfo class]])
    {
        ret = ((MusicInfo *)songInfo).fileURL;
    }
    else if ([songInfo isKindOfClass:[SongInfo class]])
    {
        ret = songInfo.songURL;
    }
    
    return ret;
}

+ (void)moveViewWithAnimations:(int)endX endY:(int)endY view:(UIView *)view
{   
    [UIView animateWithDuration:0.6
                     animations:^{
                         int x = endX;
                         int y = endY;
                         view.center = CGPointMake(x, y);
                     }];
}


+ (void)moveViewWithAnimationsOrigin:(int)endX endY:(int)endY view:(UIView *)view
{   
    [UIView animateWithDuration:0.0
                     animations:^{
                         int x = endX;
                         int y = endY;
                         CGRect rt = view.frame;
                         rt.origin.x = x;
                         rt.origin.y = y;
                         view.frame = rt;
                     }];
}

+ (void)moveViewWithAnimationsOrigin:(int)endX endY:(int)endY view:(UIView *)view time:(float)time
{   
    [UIView animateWithDuration:time
                     animations:^{
                         int x = endX;
                         int y = endY;
                         CGRect rt = view.frame;
                         rt.origin.x = x;
                         rt.origin.y = y;
                         view.frame = rt;
                     }];
}

+ (void)moveViewWithAnimationsOrigin:(CGRect)rect view:(UIView *)view time:(float)time
{   
    [UIView animateWithDuration:time
                     animations:^{
                         view.frame = rect;
                         view.alpha = 0.0;
                     }];
}

//1为3个 其他为超过三个
//+ (void)showChooseNothingAlert:(int )alertType
//{
//    alertinfo *infoObject = [[alertinfo alloc]init];
//    if (alertType == 1)
//    {
//        infoObject.isChangePoint = NO;
//    }
//    else
//    {
//        infoObject.isChangePoint = YES;
//    }
//    infoObject.message = @"你还没选择歌曲";
//    infoObject.sec = 2.0;
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc postNotificationName:ALERT_NOTIFICATION object:infoObject];
//    [infoObject release];
//    
//}

-(void)showIntroDuctionView
{
    //[self SwitchFrom:0 To:MYKUGOUVIEWID WithAnimationType:Animation_TYPE_NONE  Object:nil];
    //DLog(@"启动-----------------------------");
}

+ (void)playSongThreadProc:(SongInfo *)playSong
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    [[musicplayengine CreateSingleton]prePlay:playSong bIsPlayOnline:[playSong isOnline]];
//    [pool release];
}
+(void) sendAddSongInfosToPlayList:(NSArray*) songs{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray*array = [NSMutableArray array];
        if (songs==nil) {
            return;
        }else{
            [array addObjectsFromArray:songs];
        }
        for (SongInfo*info in array) {
            [[UserActionMgr shareInstance] sendSongInfoToPlayAction:info
                                                      AndFromSource:info.fromPagePath
                                                       AndErrorCode:1
                                                        AndErrorMsg:@"成功"];
        }
    });
    
}

//+ (void)playNetListSong:(int)row song:(SongInfo *)playSong allSongs:(NSArray *)songs
//{
//    //保存播放列表到缓存
//    g_isFirstPlayLocalMusic = NO;
//    g_isFirstClickPlaylMusic = YES;
////     [[RemmenbPlayListTool getRemmenbPlayListToolStance] remmenbPlayListSong:row song:playSong allSongs:songs];
//    
//    // 统计，设置在线歌曲来源
////    int fromPageID = [[StatisticMgr statisticMgr]curPageClass];
//    int fromPageID = 0;
//    //设置歌曲来源界面
//    
//    [KGCommonTools setSongPagePath:songs];
//    [KGCommonTools sendAddSongInfosToPlayList:songs];
//    // 播放队列
//    PlayQueueMgr *playQueueMgr = [PlayQueueMgr playQueueMgr];
//    [playQueueMgr setEditMode:EDIT_MODE_NORMAL];
//    PlayQueueBase *playQueue = (PlayQueueBase*)[playQueueMgr buildPlayQueue:QUEUE_TYPE_NORMAL];
//    for (SongInfo *info in songs)
//    {
//        [playQueue addSong:info];
//        
//        // 统计，设置在线歌曲来源
//        if ([info isOnline])
//        {
//            info.fromPageID = fromPageID;
//        }
//    }
//    [playQueue setCurPlayIndex:row];
//    [playQueueMgr notifyQueueContentChanged];
//
//    // 推迟随机队列的创建，提升首次播放的响应速度
//    static BOOL isFirst = YES;
//    if (!isFirst)
//    {
//        [[RandomPlayQueue randomPlayQueue]initRandomPlayQueue:[playQueue songs]];
//    }
//    isFirst = NO;
//    
//    // 播放模式可用
//    if ([playQueueMgr queueType] != QUEUE_TYPE_RADIO)
//    {
//        [[NSNotificationCenter defaultCenter]postNotificationName: NOTIFY_PLAY_MODE_ENABLE object: nil];
//    }
//    
//    //是否要连网
//    BOOL isNeedConfirm = NO;
////    kugouAppDelegate* app = [kugouAppDelegate App];
//    
//    if ([playSong isOnline] && [[OfflineMgr shareOfflineMgr]isOffline] ){
//        
////        if (app.playListType != LIST_TYPE_CLOUDMUSIC)
////        {
////            isNeedConfirm = YES;
////        }
////        else
////        {
////        }
//        
//        
//        isNeedConfirm = ![ManageAllMusic isLocalMusicExistByHash:playSong.strFileHash];
//        if (isNeedConfirm) {
//            isNeedConfirm = ![ManageAllMusic isOfflineMusicExistByHash:playSong.strFileHash];
//        }
//        if (isNeedConfirm) {
//            NSString * songName = [CacheDBManager cacheMusicPathLikeName:playSong.fileName];
//            NSString * checkedFilePath = [[musicplayengine CreateSingleton] cacheMusicPathName:songName];
//            BOOL isFileExist = [fileengine isFileExistByFullPath: checkedFilePath];
//            isNeedConfirm = !isFileExist;
//        }
//        
//        if (isNeedConfirm)
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IS_CONNECT_NET object:nil];
//            return;
//        }
//    }
//    
//    // 提前显示标题
////    [KGCommonTools notifyShowCurrentSongTitle: playSong.musictitle];
//
//    [[musicplayengine CreateSingleton]setIsPlayed:YES];
//    [[musicplayengine CreateSingleton]setSongNameToPlay:playSong.fileName];
//    //[[musicplayengine CreateSingleton]stopAudio];
//    [[musicplayengine CreateSingleton]stopLocalAudio];
//    [[musicplayengine CreateSingleton] prePlay:playSong bIsPlayOnline:playSong.isOnline];
////    [NSThread detachNewThreadSelector:@selector(playSongThreadProc:) toTarget:self withObject:playSong];
//    
//    // 用户行为统计2，立即播放
////    [[UserActionMgr shareInstance]addSongPlayAction];
//}

//填充记忆播放队列
+(void)addRemmenberPlayList:(int)row song:(SongInfo *)playSong allSongs:(NSArray *)songs
{
    if ([songs count] > 0)
    {
        // 播放队列
//        PlayQueueMgr *playQueueMgr = [PlayQueueMgr playQueueMgr];
//        [playQueueMgr setEditMode:EDIT_MODE_NORMAL];
//        PlayQueueBase *playQueue = (PlayQueueBase*)[playQueueMgr buildPlayQueue:QUEUE_TYPE_NORMAL];
//        for (SongInfo *info in songs)
//        {
//            [playQueue addSong:info];
//        }
//        [playQueue setCurPlayIndex:row];
        KGNormalPlayList *playList = [[KGNormalPlayList alloc] init];
        [playList setSongs:songs];
        playList.curIndex = row;
        [[KGPlayQueueManager shareKGPlayQueueManager] setPlayList:playList];
        
        // 提前显示标题
        [KGCommonTools notifyShowCurrentSongTitle: playSong.musictitle];
        
//        [[musicplayengine CreateSingleton]setIsPlayed:NO];
//        [[musicplayengine CreateSingleton]setSongNameToPlay:playSong.fileName];
//        [[musicplayengine CreateSingleton]setCurPlayMusciURL:playSong.songURL];
//        [[musicplayengine CreateSingleton]setCurPlaySongInfo:playSong];
//        [[musicplayengine CreateSingleton]openPlaySong];
    }
}

//+ (void)playCloudSong:(int)row song:(SongInfo *)playSong allSongs:(NSArray *)songs
//{
//    [KGCommonTools playNetListSong:row song:playSong allSongs:songs];
//}
//
//+ (void)playLocalSong:(int)row song:(SongInfo *)playSong allSongs:(NSArray *)songs
//{
//    [KGCommonTools playNetListSong:row song:playSong allSongs:songs];
//}
//+ (void) setSongPagePath:(NSArray*) songArray{
//    
//}

+ (void)playLater:(SongInfo *)songInfo
{
    [[KGPlayQueueManager shareKGPlayQueueManager] playLater:songInfo subPath:nil];
//    PlayQueueMgr *playQueueMgr = [PlayQueueMgr playQueueMgr];
//    PlayQueueBase *playQueue = [playQueueMgr curPlayQueue];
//    
//    if ([playQueue queueType] == QUEUE_TYPE_RADIO)
//    {   // 当前是电台播放，不能稍后播放
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CANNOT_PALY_LATER_FOR_RADIO_PLAYING object:nil];
//        return;
//    }
//    
//    if (playQueue == nil)
//    {   // 尚无播放队列
//        [playQueueMgr setEditMode:EDIT_MODE_ADVANCE];
//        [playQueueMgr buildPlayQueue:QUEUE_TYPE_NORMAL];
//    }
//    
//    SongInfo *cloneSongInfo = [KGCommonTools cloneSongInfo:songInfo];
//    //TODO 蔡谨潮
//    // 统计，设置在线歌曲来源
////    if ([cloneSongInfo isOnline])
////    {
////        int fromPageID = [[StatisticMgr statisticMgr]curPageClass];
////        cloneSongInfo.fromPageID = fromPageID;
////    }
//    
//    int songCount = [[playQueueMgr curPlayQueue]songCount];
//    if (songCount <= 0)
//    {   // 当前播放列表为空时，立即播放
//        // 标识为优先播放
//        cloneSongInfo.isPrioritySong = YES;
//        
//        NSArray *songs = [NSArray arrayWithObjects:cloneSongInfo, nil];
//        [KGCommonTools playQueueAtOnce:songs];
//        
//        // 用户行为统计2，稍后播放
//        [[UserActionMgr shareInstance]addPlayLaterAction];
//
//        [cloneSongInfo release];
//        
//        return;
//    }
//    
//    musicplayengine *musicEngine = [musicplayengine CreateSingleton];
//    SongInfo *curSong = [musicEngine curPlaySongInfo];
//    if (curSong == songInfo || [curSong.songURL isEqualToString:songInfo.songURL] ||
//        ([KGCommonTools isHashEqual:curSong.strFileHash toOther:songInfo.strFileHash] && 
//         [curSong.strFileHash length] > 0))
//    {   // 对当前播放项选择“稍后播放”
//        //return;
//    }
//    
//    // 确定优先播放的位置
//    NSMutableArray *srcSongs = [playQueue songs];
//    int count = [srcSongs count];
//    BOOL isFindPriority = NO;
//    int priorityIndex = -1;
//    for (int pos = count - 1; pos >= 0; pos --)
//    {
//        SongInfo *songTemp = [srcSongs objectAtIndex:pos];
//        if (songTemp.isPrioritySong)
//        {   // 倒查到第一个优先歌曲
//            isFindPriority = YES;
//            priorityIndex = pos + 1;
//            break;
//        }
//    }
//    
//    // 定位
//    playQueue = [playQueueMgr curPlayQueue];
//    int targetIndex = 0;
//    if (curSong == nil)
//    {   // 尚未播放
//        targetIndex = 0;
//    }
//    else 
//    {
//        if (isFindPriority)
//        {   // 已有优先歌曲
//            targetIndex = priorityIndex;
//        }
//        else
//        {
//            int curIndex = [playQueue songInfoIndexForSongInfo:curSong];
//            if (curIndex < 0 && curSong.strFileHash)
//            {   // try again
//                curIndex = [playQueue songInfoIndexForHash:curSong.strFileHash];
//            }
//            if (curIndex < 0 && curSong.fileName)
//            {   // try again
//                curIndex = [playQueue songInfoIndexForSongName:curSong.fileName];
//            }
//            
//            if (curIndex >= 0 && curIndex < [playQueue songCount])
//            {
//                targetIndex = curIndex + 1;
// 
//                // 重置当前播放索引
//                [playQueue setCurPlayIndex:curIndex];
//            }
//            else 
//            {
//                targetIndex = [playQueue songCount];
//            }
//        }
//    }
//    
//    // 标识为优先播放
//    cloneSongInfo.isPrioritySong = YES;
//    
//    NSArray *songs = [NSArray arrayWithObjects:cloneSongInfo, nil];
//    //设置歌曲来源路径
//    [self setSongPagePath:songs];
//    [KGCommonTools sendAddSongInfosToPlayList:songs];
//
//    [playQueue insertSongs:songs atIndex:targetIndex];
//    [playQueueMgr notifyQueueContentChanged];
//    
//    [cloneSongInfo release];
//    
//    [playQueueMgr setEditMode:EDIT_MODE_ADVANCE];
//    
//    // 用户行为统计2，稍后播放
//    [[UserActionMgr shareInstance]addPlayLaterAction];
}

+ (void)playQueueLater:(NSArray *)inSongs
{
    [[KGPlayQueueManager shareKGPlayQueueManager] playSongsLater:inSongs subPath:nil];
//    PlayQueueBase *curQueue = [[PlayQueueMgr playQueueMgr]curPlayQueue];
//    if ([curQueue queueType] == QUEUE_TYPE_RADIO)
//    {   // 当前是电台播放，不能稍后播放
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CANNOT_PALY_LATER_FOR_RADIO_PLAYING object:nil];
//        return;
//    }
//    //TODO 蔡谨潮
//    // 统计，设置在线歌曲来源
////    int fromPageID = [[StatisticMgr statisticMgr]curPageClass];
//    
//    if (curQueue == nil)
//    {   // 尚无播放队列
//        [[PlayQueueMgr playQueueMgr] setEditMode:EDIT_MODE_ADVANCE];
//        [[PlayQueueMgr playQueueMgr] buildPlayQueue:QUEUE_TYPE_NORMAL];
//    }
//    curQueue = [[PlayQueueMgr playQueueMgr]curPlayQueue];
//    
//    int songCount = [curQueue songCount];
//    if (songCount <= 0)
//    {   // 当前播放列表为空时，立即播放
//        NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:20];
//        for (SongInfo *info in inSongs)
//        {
//            SongInfo *cloneSongInfo = [KGCommonTools cloneSongInfo:info];
//            cloneSongInfo.isPrioritySong = YES;
//            
//            [arrayTemp addObject:cloneSongInfo];
//            
//            [cloneSongInfo release];
//
//        }
//        
//        [KGCommonTools playQueueAtOnce:arrayTemp];
//        
//        // 用户行为统计2，多选稍后播放
//        [[UserActionMgr shareInstance]addMorePlayLaterAction];
//        
//        return;
//    }
//    
//    NSMutableArray *songs = [NSMutableArray arrayWithCapacity:20];
//    for (SongInfo *info in inSongs)
//    {
//        SongInfo *cloneSongInfo = [KGCommonTools cloneSongInfo:info];
//        cloneSongInfo.isPrioritySong = YES;
//        [songs addObject:cloneSongInfo];
//        [cloneSongInfo release];
//    }
//    
//    // 确定优先播放的位置
//    NSMutableArray *srcSongs = [curQueue songs];
//    int count = [srcSongs count];
//    BOOL isFindPriority = NO;
//    int priorityIndex = -1;
//    for (int pos = count - 1; pos >= 0; pos --)
//    {
//        SongInfo *songTemp = [srcSongs objectAtIndex:pos];
//        if (songTemp.isPrioritySong)
//        {   // 倒查到第一个优先歌曲
//            isFindPriority = YES;
//            priorityIndex = pos + 1;
//            break;
//        }
//    }
//    
//    // 定位
//    musicplayengine *musicEngine = [musicplayengine CreateSingleton];
//    SongInfo *curSong = [musicEngine curPlaySongInfo];
//    int targetIndex = 0;
//    if (curSong == nil)
//    {   // 尚未播放
//        targetIndex = 0;
//    }
//    else
//    {
//        if (isFindPriority)
//        {   // 已有优先歌曲
//            targetIndex = priorityIndex;
//        }
//        else
//        {
//            int curIndex = [curQueue songInfoIndexForSongInfo:curSong];
//            if (curIndex < 0 && curSong.strFileHash)
//            {   // try again
//                curIndex = [curQueue songInfoIndexForHash:curSong.strFileHash];
//            }
//            if (curIndex < 0 && curSong.fileName)
//            {   // try again
//                curIndex = [curQueue songInfoIndexForSongName:curSong.fileName];
//            }
//            
//            if (curIndex >= 0 && curIndex < [curQueue songCount])
//            {
//                targetIndex = curIndex + 1;
//                
//                // 重置当前播放索引
//                [curQueue setCurPlayIndex:curIndex];
//            }
//            else
//            {
//                targetIndex = [curQueue songCount];
//            }
//        }
//    }
//    
//    // 统计，设置在线歌曲来源  todo
////    int fromPageID = 0;
////    for (SongInfo *si in songs)
////    {
////        if ([si isOnline])
////        {
////            si.fromPageID = fromPageID;
////        }
////    }
////    //设置歌曲来源路径
////#ifdef _IPHONE_
////    kugouAppDelegate *app = [kugouAppDelegate App];
////    [app setSongPagePath:songs];
////    [KGCommonTools sendAddSongInfosToPlayList:songs];
////#endif
//    
//    [curQueue insertSongs:songs atIndex:targetIndex];
//    
//    [[PlayQueueMgr playQueueMgr]notifyQueueContentChanged];
//    
//    [[PlayQueueMgr playQueueMgr] setEditMode:EDIT_MODE_ADVANCE];
//    
//    
//    // 用户行为统计2，多选稍后播放
//    [[UserActionMgr shareInstance]addMorePlayLaterAction];
}

//+ (void)playQueueAtOnce:(NSArray *)inSongs
//{
//    musicplayengine *music = [musicplayengine CreateSingleton];
//    
//    PlayQueueBase *curQueue = [[PlayQueueMgr playQueueMgr]curPlayQueue];
//    if (curQueue == nil || [curQueue queueType] == QUEUE_TYPE_RADIO)
//    {   // 尚无播放队列或为电台队列
//        [[PlayQueueMgr playQueueMgr] setEditMode:EDIT_MODE_ADVANCE];
//        [[PlayQueueMgr playQueueMgr] buildPlayQueue:QUEUE_TYPE_NORMAL];
//    }
//    curQueue = [[PlayQueueMgr playQueueMgr]curPlayQueue];
//    
//    NSMutableArray *delSongs = [NSMutableArray arrayWithCapacity:20];
//    for (SongInfo *info in inSongs)
//    {
//       [delSongs addObject:info];
//    }
//    [self setSongPagePath:delSongs];
//    [KGCommonTools sendAddSongInfosToPlayList:delSongs];
//    
//    // todo
////#ifdef _IPHONE_
////    kugouAppDelegate *app = [kugouAppDelegate App];
////    if ([app playListType] == LIST_TYPE_UNKNOW)
////    {
////        [curQueue deleteSongArrayBySongName:delSongs];
////    }
////    else if ([app playListType] != LSIT_TYPE_LOCAL)
////    {
////        [curQueue deleteSongArray:delSongs];
////    }
////    else 
////    {
////        [curQueue deleteSongArrayBySongURL:delSongs];
////    }
////    
////    if ([app playListType] == LIST_TYPE_CASUAL)
////    {
////        [app setPlayListType:LIST_TYPE_UNKNOW];
////    }
////    //设置歌曲来源路径
////    
////#endif
//    
//    if (![curQueue isKindOfClass:[PlayQueueBase class]])
//    {
//        return;
//    }
//    
//    [curQueue insertSongs:delSongs atIndex:0];
//    
//    [[RandomPlayQueue randomPlayQueue]initRandomPlayQueue:[curQueue songs]];
//    
//    SongInfo *playSong = [curQueue songInfoForIndex: 0];
//    [curQueue setCurPlayIndex:0];
//    [music setCurSongTitle:playSong.musictitle];
//    [music prePlay:playSong bIsPlayOnline:[playSong isOnline]];
//    
//    // 提前显示标题
//    [KGCommonTools notifyShowCurrentSongTitle: playSong.musictitle];
//    
//    [[PlayQueueMgr playQueueMgr]notifyQueueContentChanged];
//    
//    [[PlayQueueMgr playQueueMgr] setEditMode:EDIT_MODE_ADVANCE];
//}

+ (BOOL)isPlayingSong:(id)info
{
    //判断是不是在播放歌曲，如果是播放收音机就返回NO
    NSNumber *typeNumber = [[NSUserDefaults standardUserDefaults]objectForKey:kPrevouisPlayType];
    
    if ([typeNumber intValue] == PLAYMODETYPE_NETRADIO)
    {
        return NO;
    }
    SongInfo *playingSong =[[KGPlayQueueManager shareKGPlayQueueManager] currentSong] ;//[[musicplayengine CreateSingleton] curPlaySongInfo];
    SongInfo *inSong = (SongInfo *)info;
    //    DLog(@"inSong:%d",&inSong);
    //    DLog(@"playingSong:%d",&playingSong);
    if (inSong == playingSong)
    {
        return YES;
    }
    if (playingSong.strFileHash.length > 0 && inSong.strFileHash.length>0)
    {
        return [playingSong.strFileHash isEqualToString:inSong.strFileHash];
    }
    else if(inSong.musicpath.length>0 && playingSong.musicpath.length>0)
    {
        return [inSong.musicpath isEqualToString:playingSong.musicpath];
    }
    
    if ([inSong.musicName isEqualToString:playingSong.musicName])
    {
        
        return YES;
    }
    
    return NO;
}


+ (BOOL)deleteLocalSongInfoByPath:(NSString *)strPath
{
    NSString *realPath = nil;
    NSRange range = [strPath rangeOfString: DOWN_TARGET_DIR];
    if (range.location != NSNotFound)
    {   // 在下载目录
        NSString* docTemp = [fileengine GetDocumentPath];
        NSString* fileName = [strPath substringFromIndex: (range.location + range.length + 1)];
        realPath = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", DOWN_TARGET_DIR, fileName]];
    }
    else 
    {
        range = [strPath rangeOfString: SHARE_SONG_SAVE_DIR];
        if (range.location != NSNotFound)
        {   // 共享目录
            NSString* docTemp = [fileengine GetDocumentPath];
            NSString* fileName = [strPath substringFromIndex: (range.location + range.length + 1)];
            realPath = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", SHARE_SONG_SAVE_DIR, fileName]];
        }
    }
    
    return [fileengine DeleteFileAtPath:realPath];
}

+ (void)deleteLocalSongInfo:(SongInfo *)songInfo
{
    if (songInfo)
    {
        if (songInfo.songURL)
        {
            BOOL bSuccess = [KGCommonTools deleteLocalSongInfoByPath:songInfo.songURL];
            if (1 || bSuccess)
            {   
                /*
                // 通知文件删除
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setValue: songInfo forKey: NOTIFY_LOCAL_FILE_DEL_PARAM];
                [[NSNotificationCenter defaultCenter]postNotificationName: NOTIFY_LOCAL_FILE_DEL object: self userInfo: dict];
                [dict release];
                 */
            }
        }
    }
}

+ (void)deleteLocalSongInfoArray:(NSArray *)songs
{
    if ([songs count] > 0)
    {
        BOOL bNeedNotify = NO;
        for (SongInfo *song in songs)
        {
            NSString *realPath = nil;
            NSRange range = [song.songURL rangeOfString: DOWN_TARGET_DIR];
            if (range.location != NSNotFound)
            {   // 在下载目录
                NSString* docTemp = [fileengine GetDocumentPath];
                NSString* fileName = [song.songURL substringFromIndex: (range.location + range.length + 1)];
                realPath = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", DOWN_TARGET_DIR, fileName]];
            }
            else 
            {
                range = [song.songURL rangeOfString: SHARE_SONG_SAVE_DIR];
                if (range.location != NSNotFound)
                {   // 共享目录
                    NSString* docTemp = [fileengine GetDocumentPath];
                    NSString* fileName = [song.songURL substringFromIndex: (range.location + range.length + 1)];
                    realPath = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", SHARE_SONG_SAVE_DIR, fileName] ];
                }
            }
            
            BOOL bSuccess = [fileengine DeleteFileAtPath:realPath];
            if (1 || bSuccess)
            {
                bNeedNotify = YES;
            }
            
            if (!bSuccess)
            {
                DLog(@"delete file failed");
            }
        }
        
        /*
        if (bNeedNotify)
        {
            // 通知文件批量删除
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setValue: songs forKey: NOTIFY_LOCAL_FILE_DEL_PARAM];
            [[NSNotificationCenter defaultCenter]postNotificationName: NOTIFY_BATCH_LOCAL_FILE_DEL object: self userInfo: dict];
            [dict release];
        }
         */
    }
}

+ (NSArray *)rangesForKey:(NSString *)strSource key:(NSString *)strKey
{
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:10];
    NSString *strTempSource = [strSource uppercaseString];
    NSString *strTempKey = [strKey uppercaseString];
    int locationAdjust = 0;
    do 
    {
        NSRange rng = [strTempSource rangeOfString:strTempKey];
        if (rng.location != NSNotFound)
        {
            strTempSource = [strTempSource substringFromIndex:(rng.location + rng.length)];
            int locTemp = rng.location;
            rng.location += locationAdjust;
            locationAdjust += (locTemp + rng.length);
            [retArray addObject:[NSValue valueWithRange:rng]];
        }
        else 
        {
            strTempSource = @"";
        }
    }while ([strTempSource length] > [strTempKey length] && [strTempKey length] > 0);
    
    return retArray;
}


+(UIImage *) screenImage:(UIView *)view rect:(CGRect)rect 
{  
    CGPoint pt = rect.origin;  
    UIImage *screenImage;  
    UIGraphicsBeginImageContext(rect.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextConcatCTM(context,  
                       CGAffineTransformMakeTranslation(-(int)pt.x, -(int)pt.y));  
    [view.layer renderInContext:context];  
    screenImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    [screenImage retain];
    return screenImage;  
} 

+(UIImage *) windowImage:(UIWindow *)window rect:(CGRect)rect
{  
    CGPoint pt = rect.origin;  
    UIImage *screenImage;  
    UIGraphicsBeginImageContext(rect.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextConcatCTM(context,  
                       CGAffineTransformMakeTranslation(-(int)pt.x, -(int)pt.y));  
    [window.layer renderInContext:context];  
    screenImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    [screenImage retain];
    return screenImage;  
} 

int getIPbyDomain(const char* domain, char* ip)   
{   
    struct hostent *answer = gethostbyname(domain);   
    if (nil == answer)   
    {    
        return -1;     
    }   
    
    if (answer->h_addr_list[0]) 
    {
        //inet_ntop(AF_INET, (answer->h_addr_list)[0], ip, 16);
    }
    else  
    {
        return -1;    
    }
    
    return 0;   
}
+(int)getIpByDomainOC:(const char*)domain ip:(char*)ip
{
    struct hostent *answer = gethostbyname(domain);
    if (nil == answer)
    {
        return -1;
    }
    
    if (answer->h_addr_list[0])
    {
        //inet_ntop(AF_INET, (answer->h_addr_list)[0], ip, 16);
    }
    else
    {
        return -1;
    }
    
    return 0;
}

+ (NSString *)realLocalSongPath:(NSString *)srcPath
{
    if (srcPath == nil || [srcPath length] <= 0)
    {
        return nil;
    }
    
    NSRange range = [srcPath rangeOfString: DOWN_TARGET_DIR];
    if (range.location != NSNotFound)
    {
        NSString* docTemp = [fileengine GetDocumentPath];
        NSString* fileName = [srcPath substringFromIndex: (range.location + range.length + 1)];
        NSString* retPathName = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", DOWN_TARGET_DIR, fileName]];
        return retPathName;
    }

    return nil;
}

+ (NSString *)perVersionLocalSongPath:(NSString *)srcPath
{
    if (srcPath == nil || [srcPath length] <= 0)
    {
        return nil;
    }
    
    NSRange range = [srcPath rangeOfString: DOWN_TARGET_DIR];
    if (range.location != NSNotFound)
    {
        NSString* docTemp = [fileengine libraryCachesPath];
        NSString* fileName = [srcPath substringFromIndex: (range.location + range.length + 1)];
        NSString* retPathName = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", DOWN_TARGET_DIR, fileName]];
        return retPathName;
    }
    
    return nil;
}

+ (NSString*)shareMusicPathName:(NSString*)srcPathName
{
    if (srcPathName == nil)
    {
        return nil;
    }
    
    NSRange range = [srcPathName rangeOfString: SHARE_SONG_SAVE_DIR];
    if (range.location != NSNotFound)
    {
        NSString* docTemp = [fileengine GetDocumentPath];
        NSString* fileName = [srcPathName substringFromIndex: (range.location + range.length + 1)];
        NSString* retPathName = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", SHARE_SONG_SAVE_DIR, fileName]];
        return retPathName;
    }
    
    return nil;
}

+ (BOOL)isLocalFileExsit:(NSString *)songPath
{
    BOOL isFileExist = NO;
    NSString *realPath = [KGCommonTools realLocalSongPath:songPath];
    NSString *prePath = [KGCommonTools perVersionLocalSongPath:songPath];
    if ((realPath && [fileengine isFileExistByFullPath:realPath]))
    {
        isFileExist = YES;
    }
    else if (prePath && [fileengine isFileExistByFullPath:prePath])
    {
        isFileExist = YES;
    }
    
    if (!isFileExist)
    {   // 是否在共享目录
        NSString *sharePath = [KGCommonTools shareMusicPathName:songPath];
        if (sharePath && [fileengine isFileExistByFullPath:sharePath])
        {
            isFileExist = YES;
        }
    }
    
    if (isFileExist == NO)
    {
        DLog(@"file not exist");
    }
    
    return isFileExist;
}

+(BOOL)isPerfectJailBroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    //    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
    //        jailbroken = YES;
    //    }
    BOOL isPerfectJailBreak = NO;
    if (jailbroken) {
        NSString *appsyncPath = @"/Library/MobileSubstrate/DynamicLibraries";
        NSArray *allPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appsyncPath error:nil];
        for (NSString *path in allPaths){
            if ([[path lowercaseString] rangeOfString:@"sync"].location != NSNotFound ) {
                isPerfectJailBreak = YES;
                break;
            }
        }
    }
    return isPerfectJailBreak;
}

+ (BOOL)isJailBroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
//    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
//    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
//        jailbroken = YES;
//    }
    return jailbroken;
}

+ (BOOL)isShareSongExsitByName:(NSString *)fileName
{
    NSString* docTemp = [fileengine GetDocumentPath];
    NSString* pathName = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@", SHARE_SONG_SAVE_DIR, fileName]];
    if (pathName && [fileengine isFileExistByFullPath:pathName])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isShareSongExistBySong:(SongInfo *)song
{
    NSString *extName = [song.songURL pathExtension];
    NSString* docTemp = [fileengine GetDocumentPath];
    NSString* pathName = [docTemp stringByAppendingPathComponent:[NSString stringWithFormat: @"%@/%@.%@", SHARE_SONG_SAVE_DIR, song.fileName, extName]];
    if (pathName && [fileengine isFileExistByFullPath:pathName])
    {
        return YES;
    }
    return NO;
}

+ (vm_size_t)usedMemory
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

+ (vm_size_t)freeMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

+ (int)localIP:(char*)outIP
{
    return 0;
    return getIPbyDomain("127.0.0.0", outIP);
}

+ (int)userID
{
    NSString *strUserID = [ConfigProtocol getUserId];
    int userID = 0;
    if (strUserID && [strUserID length] > 0)
    {
        userID = [strUserID intValue];
    }
    
    return userID;
}

+ (NSString*)curDateTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDateTime = [formatter stringFromDate:date];
    [formatter release];
    
    return strDateTime;
}

+(NSString*)curDateTimeMSec
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *strDateTime = [formatter stringFromDate:date];
    [formatter release];
    
    return strDateTime;
}

+(NSString*)curDateByDay
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDateTime = [formatter stringFromDate:date];
    [formatter release];
    
    return strDateTime;
}

+ (BOOL)isLowDevice
{
    NSString *deviceFlag = [UIDevice currentDevice].platformString;
    if ([deviceFlag hasPrefix:IPHONE_3G_NAMESTRING]
        || [deviceFlag hasPrefix:IPHONE_3GS_NAMESTRING]
        || [deviceFlag hasPrefix:IPHONE_4G_NAMESTRING]
        || [deviceFlag hasPrefix:IPHONE_1G_NAMESTRING]
        || [deviceFlag hasPrefix:IPOD_3G_NAMESTRING]
        || [deviceFlag hasPrefix:IPOD_4G_NAMESTRING]
        || [deviceFlag hasPrefix:IPOD_1G_NAMESTRING]
        || [deviceFlag hasPrefix:IPOD_2G_NAMESTRING]
        )
    {
        return YES;
    }
    
    return NO;
}

+(CGSize) sizeForString:(NSString*)string font:(UIFont*)font
{
    CGSize retSize = CGSizeZero;
    if (string != nil && font != nil)
    {
        if ([string respondsToSelector:@selector(sizeWithAttributes:)])
        {
            NSDictionary *tAttr = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
            retSize = [string sizeWithAttributes:tAttr];
        }
        else
        {
            if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)) {//6.0－7.0之间
                NSAttributedString *attribStr =
                [[NSAttributedString alloc] initWithString:string
                                                attributes:[NSDictionary dictionaryWithObject:font
                                                                                       forKey:NSFontAttributeName]];
                retSize = [attribStr size];
                [attribStr release];
            }
            else if ([string respondsToSelector:@selector(sizeWithFont:)])// 字符尺寸.sizeWithFont不是线程安全
            {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                retSize = [string sizeWithFont:font];
#pragma GCC disgnostic pop
            }

        }

        
    }
    
    return retSize;
}

@end

////////////////////////////////////////
@implementation PlayThreadParam

@synthesize fileURL;
@synthesize bOnline;
@synthesize songInfo;

- (void) dealloc
{
    [fileURL release];
    [songInfo release];
    [super dealloc];
}

@end


////////////////////////////////////////
@implementation PlayOperators
+ (void) playNextThreadProc
{
    [NSThread sleepForTimeInterval: 1];
}

+ (void) playNextOnlineFileByThread
{
    [self performSelectorOnMainThread: @selector(playNextThreadProc) withObject: nil waitUntilDone: YES];
}

+ (void) playFileToMainThread: (SongInfo*)songInfo isOnline: (BOOL)bOnline
{
    if (songInfo)
    {
        PlayThreadParam* param = [[PlayThreadParam alloc] init];
        param.bOnline = bOnline;
        param.songInfo = songInfo;
        [self performSelectorOnMainThread: @selector(playFileToMainThreadProc:) withObject: param waitUntilDone: YES];
        [param release];
    }
}

+ (void) playFileToMainThreadProc: (id)param
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    PlayThreadParam* threadParam = (PlayThreadParam*)param;
    //[[musicplayengine CreateSingleton]prePlay: threadParam.songInfo  bIsPlayOnline: threadParam.bOnline];
    [pool release];
}

+(float)getFileValue:(int)Size{
    float fileValue = 0.0f;
    
    fileValue = Size*0.000000953674316;
    DLog(@"%f",fileValue);
    if (fileValue<0.0099999999f) {
        fileValue=0.01f;
    }
    return fileValue;
}

@end