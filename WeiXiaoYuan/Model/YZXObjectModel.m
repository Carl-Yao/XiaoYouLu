//
//  KTVObjectModel.m
//  kugou
//
//  Created by YZX on 14/12/27.
//  Copyright (c) 2014年 YZX. All rights reserved.
//

#import "YZXObjectModel.h"

@implementation YZXObjectModel

-(NSDictionary*)toDictionary
{
    NSDictionary * dic = [super toDictionary];
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber * number = (NSNumber *) obj;
            if (number.integerValue == YZXObjectModelNumberInitValue) {
                return;
            }
        }
        
        [mDic setObject:obj forKey:key];
    }];
    
    return mDic;
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
