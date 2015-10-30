//
//  KTVObjectModel.h
//  kugou
//
//  Created by YZX on 14/12/27.
//  Copyright (c) 2014年 YZX. All rights reserved.
//

#import "JSONModel.h"

#define YZXObjectModelNumberInitValue (-2)

@interface YZXObjectModel : JSONModel

-(NSDictionary*)toDictionary;

+(BOOL)propertyIsOptional:(NSString*)propertyName;

@end
