//
//  KGFont.m
//  YZX
//
//  Created by Yunsong on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KGFont.h"

@implementation UIFont (KGFont)

+(UIFont*)KGFontWithSize:(CGFloat)size
{
//    return [UIFont fontWithName:@"STHeitiSC-Light" size:size];
    return [UIFont systemFontOfSize:size];
}

+(UIFont*)boldKGFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"STHeitiSC-Light" size:size];
}

@end