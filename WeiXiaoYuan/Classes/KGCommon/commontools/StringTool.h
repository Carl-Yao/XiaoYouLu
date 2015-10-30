//
//  StringTool.h
//  字符串相关功能
//
//  Created by YZX on 2011/6/23.
//  Copyright 2011年 YZX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringTool : NSObject 
{
   
}

+ (NSData*) Unicode2GBK: (NSString*)srcContent;
+ (NSData*) GBK2Unicode: (NSString*)srcContent;
// 由外界释放返回的字符串
+ (NSString*) Unicode2GBKString: (NSString*)srcContent;
// 由外界释放返回的字符串
+ (NSString*) GBK2UnicodeString: (NSString*)srcContent;

+(NSString*)ReToSQLStr:(NSString*)str;

+(NSString*) ReToURLStr:(NSString*) str;

/**
 *	@brief	判断字符是不是空字符，例如nil、''、'   '都是空字符
 *
 *	@param 	str 	
 *
 *	@return	
 */
+(BOOL) isEmptyStr:(NSString*)str;
/**
 *  验证输入是否只有中文、数字、字母
 *
 *  @param str
 *
 *  @return
 */
+(BOOL) verifyAccount:(NSString*) str;
+(BOOL) verifyNickName:(NSString*) str;
//+(BOOL) verifyPassword:(NSString*) pw;
+ (BOOL) isValidNumber:(NSString*)value;
+ (BOOL) isValidPhone:(NSString*)value;
+(NSData*)stringToByte:(NSString*)string;
+(NSString*)TimeIntervalToString:(NSTimeInterval)time;
/**
 *  pbData转换字符串
 *
 *  @param pbData
 *
 *  @return
 */
+(NSString*) pbDataToString:(NSData*) pbData;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (NSString *)stringWithAppleEmojiFont:(NSString *)string;

+ (NSString *)fileNameByDeleteBracketWithFileName:(NSString *)title; //去掉中括号及中括号里的内容
+(NSString*) getHostStrFromUrlStr:(NSString*) urlStr;
+(NSDictionary*) getParamsFromUrlStr:(NSString*) urlStr;
@end

@interface NSString (URLEncodingAdditions)
- (NSString *)URLEncodedString;
- (NSString *)gbEncoding;
- (NSString *)utf8Encoding;
- (NSString *)utf8EncodingWithoutSpace;
- (NSString *)fitNSString;
@end

@interface NSObject (StringTool)


-(int)kgIntValue;
@end
