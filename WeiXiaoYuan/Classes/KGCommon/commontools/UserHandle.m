//
//  UserHandle.m
//  YZX
//
//  Created by cheng lixing on 12-3-14.
//  Copyright 2012年 YZX. All rights reserved.
//

#import "UserHandle.h"

UserHandle* g_userHandle;

@implementation UserHandle

@synthesize pausePlayByUser;
@synthesize pausePlayByInterruption;
@synthesize pausePlayByUnplugHeadset;
@synthesize pausePlayBySystem;

+ (id) userHandle
{
    if (g_userHandle == nil)
    {
        g_userHandle = [[UserHandle alloc] init];
    }
    
    return g_userHandle;
}

- (BOOL) isUserPausePlay
{
    return pausePlayByInterruption || pausePlayByUnplugHeadset || pausePlayByUser || pausePlayBySystem;
}

- (void)resetAllPauseStatus
{
    pausePlayByInterruption = NO;
    pausePlayByUnplugHeadset = NO;
    pausePlayByUser = NO;
    pausePlayBySystem = NO;
}

@end
