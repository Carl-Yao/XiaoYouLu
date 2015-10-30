//
//  KGFont.h
//  YZX
//
//  Created by Yunsong on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import "StringTool.h"



#define KG_FONT_AA 18
#define KG_FONT_AAA 19
#define KG_FONT_A 17
#define KG_FONT_B 16
#define KG_FONT_C 15
#define KG_FONT_D 14
#define KG_FONT_E 13
#define KG_FONT_F 12
#define KG_FONT_G 11
#define KG_FONT_H 10

@interface UIFont (KGFont)

+(UIFont*)KGFontWithSize:(CGFloat)size;
+(UIFont*)boldKGFontWithSize:(CGFloat)size;
@end