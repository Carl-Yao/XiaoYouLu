//
//  BCDEncoding.h
//  QQMusic
//
//  Created by apple on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCDEncoding : NSObject
{
    
}
+ (NSString *)hexStringFromData:(NSString*) stringValue;
+ (NSString *)dataFromHexString:(NSString*) dataValue;
+(unsigned int)mycharTo4Bits:(unsigned char)c;
@end
