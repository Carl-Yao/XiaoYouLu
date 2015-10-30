//
//  BCD.m
//  QQMusic
//
//  Created by wavelet on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BCDEncoding.h"

@implementation BCDEncoding
+ (NSString *)hexStringFromData:(NSString*) stringValue {
    NSData *dataValue = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
       UInt32 byteLength = [dataValue length], byteCounter = 0;
       UInt32 stringLength = (byteLength*2) + 1, stringCounter = 0;
       unsigned char dstBuffer[stringLength];
       unsigned char srcBuffer[byteLength];
       unsigned char *srcPtr = srcBuffer;
    [dataValue getBytes:srcBuffer length:byteLength];
       const unsigned char t[16] = "0123456789ABCDEF";
       
       for (;byteCounter < byteLength; byteCounter++){
           unsigned src = *srcPtr;
           dstBuffer[stringCounter++] = t[src>>4];
           dstBuffer[stringCounter++] = t[src & 15];
           srcPtr++;
       }
       dstBuffer[stringCounter] = '\0';
       
       return [NSString stringWithUTF8String:(char*)dstBuffer];
}
+ (NSString *)dataFromHexString:(NSString*) dataValue {
       UInt32 stringLength = [dataValue length];
       UInt32 byteLength = stringLength/2;
       UInt32 byteCounter = 0;
       //unsigned char srcBuffer[stringLength];
       //[dataValue getCString:(char *)srcBuffer];
       const char * srcBuffer = [dataValue cStringUsingEncoding:NSUTF8StringEncoding];
       unsigned char *srcPtr = (unsigned char *)srcBuffer;
       Byte dstBuffer[byteLength];
       Byte *dst = dstBuffer;
       for(;byteCounter < byteLength;){
           unsigned char c = *srcPtr++;
           unsigned char d = *srcPtr++;
           unsigned int hi = 0, lo = 0;
           hi = [self  mycharTo4Bits:c];
           lo = [self  mycharTo4Bits:d];
           if (hi== 255 || lo == 255){
               //errorCase
               return nil;
           }
           dstBuffer[byteCounter++] = ((hi << 4) | lo);
       }
    NSData * tempData = [NSData dataWithBytes:dst length:byteLength ];
    NSString *string_ = [[[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding] autorelease];
       return string_;
}

// '9' to 2
+(unsigned int)mycharTo4Bits:(unsigned char)c
{
    unsigned int res = 0;
    switch (c) {
        case '1':
            res = 1 ;
            break;
        case '2':
             res =  2 ;
            break;
        case '3':
             res =  3;
            break;
        case '4':
             res =  4;
            break;
        case '5':
             res =  5;
            break;
        case '6':
             res =  6;
            break;
        case '7':
             res =  7;
            break;
        case '8':
             res =  8;
            break;
        case '9':
             res =  9;
            break;
        case 'A':
             res =  10;
            break;
        case 'B':
             res =  11;
            break;
        case 'C':
             res =  12;
            break;
        case 'D':
             res =  13;
            break;
        case 'E':
             res =  14;
            break;
        case 'F':
             res =  15;
            break;
        default:
            break;
    }
    return res;
}
@end
