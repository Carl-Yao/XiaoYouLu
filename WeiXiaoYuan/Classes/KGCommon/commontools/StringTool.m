//
//  StringTool.m
//  YZX
//
//  Created by YZX on 2011/6/23.
//  Copyright 2011年 YZX. All rights reserved.
//

#import "StringTool.h"
#import "MainDef.h"
#import "NSData+Base64.h"
BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}
@implementation StringTool

+(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}
+ (NSData*) Unicode2GBK: (NSString*)srcContent
{
    NSString* unicodeStr = [NSString stringWithString: srcContent];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* retData = [unicodeStr dataUsingEncoding: enc];
    return retData;
}

+ (NSData*) GBK2Unicode: (NSString*)srcContent
{
    NSString* gbkStr = [NSString stringWithString: srcContent];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
    NSData* retData = [gbkStr dataUsingEncoding: enc];
    return retData;
}

+ (NSString*) Unicode2GBKString: (NSString*)srcContent
{
    NSData* data = [StringTool Unicode2GBK: srcContent];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* retStr = [[NSString alloc] initWithData: data encoding: enc];
    return [retStr autorelease];
}

+ (NSString*) GBK2UnicodeString: (NSString*)srcContent
{
    NSData* data = [StringTool GBK2Unicode: srcContent];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
    NSString* retStr = [[NSString alloc] initWithData: data encoding: enc];
    return [retStr autorelease];
}
+(NSString*)ReToSQLStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
//    str=[str stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    str=[str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
//    str=[str stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
//    str=[str stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
//    str=[str stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
//    str=[str stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
//    str=[str stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
//    str=[str stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
//    str=[str stringByReplacingOccurrencesOfString:@")" withString:@"//"];
    return str;
}
+(NSString*) ReToURLStr:(NSString*) str{
    NSString*copyStr = str;
    copyStr=[copyStr stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    copyStr=[copyStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    copyStr=[copyStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    copyStr=[copyStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    copyStr=[copyStr stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    copyStr=[copyStr stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    copyStr=[copyStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    copyStr=[copyStr stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    return copyStr;
}
+(BOOL) isEmptyStr:(NSString*)str{
    if (str==nil||![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    NSString*tempStr = [str  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tempStr isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
+(NSString*)TimeIntervalToString:(NSTimeInterval)time
{
    NSInteger itime = time;
    NSString *str = nil;
    if (time>60*60) {
        str = [NSString stringWithFormat:@"%d:%d:%.2d",itime/60, (itime-itime/60)/60 ,itime%60];
    }else{
        str = [NSString stringWithFormat:@"%d:%.2d",itime/60,itime%60];
    }
    return str;
}
+(BOOL) verifyAccount:(NSString*) str{
    NSString *parten = @"^[\u4e00-\u9fa5a-zA-Z][\u4e00-\u9fa5a-zA-Z0-9]*$";
    
    NSError* error = NULL;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:nil error:&error];
    if (error) {
        return NO;
    }
    NSArray* match = [reg matchesInString:str options:NSMatchingCompleted range:NSMakeRange(0, [str length])];
    if (match.count != 0)
    {
//        for (NSTextCheckingResult *matc in match)
//        {
//            NSRange range = [matc range];
//            NSLog(@"%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,[str substringWithRange:range]);
//        }
        return YES;
    }
    else
    {
        return NO;
    }
}
+(BOOL) verifyNickName:(NSString*) str{
    NSString *parten = @"^[\u4e00-\u9fa5a-zA-Z0-9]*$";
    
    NSError* error = NULL;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:nil error:&error];
    if (error) {
        return NO;
    }
    NSArray* match = [reg matchesInString:str options:NSMatchingCompleted range:NSMakeRange(0, [str length])];
    if (match.count != 0)
    {
        //        for (NSTextCheckingResult *matc in match)
        //        {
        //            NSRange range = [matc range];
        //            NSLog(@"%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,[str substringWithRange:range]);
        //        }
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL) isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}
+ (BOOL) isValidPhone:(NSString*)value {
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    if (len != 11) {
        return FALSE;
    }
    if (![StringTool isValidNumber:value])
    {
        return FALSE;
    }
    NSString *preString = [[NSString stringWithFormat:@"%@",value] substringToIndex:2];
    if ([preString isEqualToString:@"13"] ||
        [preString isEqualToString: @"15"] ||
        [preString isEqualToString: @"18"])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    return TRUE;
}
+(NSString*) getHostStrFromUrlStr:(NSString*) urlStr{
    if ([StringTool isEmptyStr:urlStr]) {
        return nil;
    }
    NSRange startIndex = [urlStr rangeOfString:@"//"];
    NSRange endIndex = [urlStr rangeOfString:@"?"];
    DLog(@"startIndex location:%d lenght:%d",startIndex.location,startIndex.length);
    DLog(@"endIndex location:%d lenght:%d",endIndex.location,endIndex.length);
    NSUInteger location = startIndex.location==NSNotFound?0:startIndex.location+startIndex.length;
    NSUInteger length = endIndex.location==NSNotFound?[urlStr length]-location:endIndex.location - location;
    DLog(@"location:%d lenght:%d",location,length);
    if (length==0) {
        return nil;
    }
    else
    {
        NSRange range = NSMakeRange(location
                                    ,length);
        NSString*hostStr = [urlStr substringWithRange:range];
//        DLog(@"hostStr:%@",hostStr);
        return hostStr;
    }
    
    
}
+(NSDictionary*) getParamsFromUrlStr:(NSString*) urlStr{
    if ([StringTool isEmptyStr:urlStr]) {
        return nil;
    }
    NSRange paramIndex = [urlStr rangeOfString:@"?"];
    if (paramIndex.location==NSNotFound) {
        return nil;
    }
    if (paramIndex.location+paramIndex.length==[urlStr length]) {
        return nil;
    }
    NSString*paramsStr = [urlStr substringFromIndex:paramIndex.location+paramIndex.length];
    NSArray*paramArray = [paramsStr componentsSeparatedByString:@"&"];
    NSMutableDictionary*paramDic = [NSMutableDictionary dictionary];
    for (NSString*itemStr in paramArray) {
        NSArray*itemArray = [itemStr componentsSeparatedByString:@"="];
        if ([itemArray count]==2) {
            NSString*name = [itemArray objectAtIndex:0];
            NSString*value = [itemArray objectAtIndex:1];
            [paramDic setObject:value forKey:name];
        }
    }
    return paramDic;
}
//+(BOOL) verifyPassword:(NSString*) pw{
//    
//    NSString *parten = @"^[a-zA-Z0-9\\pP\\pS]*$";
//    
//    NSError* error = NULL;
//    
//    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:nil error:&error];
//    if (error) {
//        return NO;
//    }
//    NSArray* match = [reg matchesInString:pw options:NSMatchingCompleted range:NSMakeRange(0, [pw length])];
//    if (match.count != 0)
//    {
//        for (NSTextCheckingResult *matc in match)
//        {
//            NSRange range = [matc range];
//            NSLog(@"%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,[pw substringWithRange:range]);
//        }
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         }
         
         if (!returnValue) {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}
+(NSString*) pbDataToString:(NSData*) pbData{
    return [[[pbData base64EncodedString] stringByReplacingOccurrencesOfString:@"+" withString:@"-"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}
+ (NSString *)stringWithAppleEmojiFont:(NSString *)string
{
    __block NSMutableString *mutableStr = [NSMutableString string];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         BOOL returnValue = NO;
         BOOL needWhiteSpace = YES;
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         }
         
         if (!returnValue) {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
//                 needWhiteSpace = NO;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
         
         if (returnValue) {
             [mutableStr appendString:[NSString stringWithFormat:@"<font face = 'AppleColorEmoji'>%@</font>",substring]];
             if (needWhiteSpace && !isIOS7) {
                 [mutableStr appendString:@" "];
             }
         }
         else {
             [mutableStr appendString:substring];
         }
         
     }];
    
    return mutableStr;
}

+ (NSString *)fileNameByDeleteBracketWithFileName:(NSString *)title
{
    NSString *noBracketStr = title;
    NSRange rangeLeft = [noBracketStr rangeOfString:@"【"];
    NSRange rangeRight = [noBracketStr rangeOfString:@"】"];
    
    do {
        if (rangeLeft.length > 0 && rangeRight.length > 0) {
            int len = rangeRight.location-rangeLeft.location+1;
            if (len < 0) {
                break;
            }
            NSString *bracketStr = [noBracketStr substringWithRange:NSMakeRange(rangeLeft.location, rangeRight.location-rangeLeft.location+1)];
            if (!bracketStr || [bracketStr length] <= 0) {
                break;
            }
            noBracketStr = [noBracketStr stringByReplacingOccurrencesOfString:bracketStr withString:@""];
            rangeLeft = [noBracketStr rangeOfString:@"【"];
            rangeRight = [noBracketStr rangeOfString:@"】"];
        }
    } while (rangeLeft.length > 0 && rangeRight.length > 0);
    
    return noBracketStr;
}

@end


@implementation NSString (OAURLEncodingAdditions)

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)
	CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
											(CFStringRef)self,
											NULL,
	                                        CFSTR("!*'();:@&=+$,/?%#[] "),
											kCFStringEncodingUTF8);
    return result;
}


- (NSString *)fitNSString
{
	return [self stringByReplacingOccurrencesOfString: @" " withString: @""];;
}

- (NSString *)gbEncoding
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *result = (NSString *)
	CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
											(CFStringRef)self,
											NULL,
	                                        CFSTR("!*'();:@&=+$,/?%#[] "),
											enc);
    
    NSString *ecodedContent = [NSString stringWithString: result];
    [result release];

    return ecodedContent;
}

- (NSString *)utf8Encoding
{
    NSString *result = (NSString *)
	CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
											(CFStringRef)self,
											NULL,
	                                        CFSTR("!*'();:@&=+$,/?%#[] "),
											kCFStringEncodingUTF8);
    
    NSString *ecodedContent = [NSString stringWithString: result];
    [result release];
    
    return ecodedContent;
}

- (NSString *)utf8EncodingWithoutSpace
{
    NSString *result = (NSString *)
	CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
											(CFStringRef)self,
											NULL,
	                                        CFSTR("!*'();:@&=+$,/?%#[]"),
											kCFStringEncodingUTF8);
    
    NSString *ecodedContent = [NSString stringWithString: result];
    [result release];
    
    return ecodedContent;
}

@end

@implementation NSObject (StringTool)


-(int)kgIntValue
{
    NSScanner* scan = [NSScanner scannerWithString:[NSString stringWithFormat:@"%@",self]];
    int val;
    if ([scan scanInt:&val] && [scan isAtEnd])
    {
        return val;
    }
    return 0;
}




@end
