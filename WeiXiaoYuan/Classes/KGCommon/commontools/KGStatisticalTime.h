//
//  KGStatisticalTime.h
//  YZX
//
//  Created by weisun84 on 15/2/9.
//  Copyright (c) 2015年 YZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGStatisticalTime : NSObject
@property (nonatomic,strong) NSMutableDictionary*timeDic;
- (void)startKey:(NSString *) key;
- (NSTimeInterval)endPrintKey:(NSString *) key;
+ (KGStatisticalTime *)instance;
@end
