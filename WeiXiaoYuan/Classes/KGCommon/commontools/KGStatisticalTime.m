//
//  KGStatisticalTime.m
//  YZX
//
//  Created by weisun84 on 15/2/9.
//  Copyright (c) 2015年 YZX. All rights reserved.
//

#import "KGStatisticalTime.h"

@implementation KGStatisticalTime
- (id)init
{
    self = [super init];
    if (self)
    {
        self.timeDic = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)startKey:(NSString *) key
{
    if (key==nil)
    {
        return;
    }
    NSDate *interval = [NSDate date] ;
    [self.timeDic setObject:interval forKey:key];
    
}
- (NSTimeInterval)endPrintKey:(NSString *) key
{
    if (key==nil) {
        DLog(@"key is null");
        return 0;
    }
    NSDate *intervalTime = [self.timeDic objectForKey:key];
    if (intervalTime)
    {
        [self.timeDic removeObjectForKey:key];
        NSDate *nowTime = [NSDate date];
        NSTimeInterval interval = [nowTime timeIntervalSinceDate:intervalTime];
        DLog(@"statistical time key:%@ interval:%f",key,interval);
        return interval;
    }
    else
    {
        DLog(@"key is not exsit");
        return 0;
    }
}
+(KGStatisticalTime*) instance
{
    static KGStatisticalTime *vInstace = nil;
    if (vInstace==nil) {
        vInstace = [[KGStatisticalTime alloc]init];
    }
    return vInstace;
}
@end
