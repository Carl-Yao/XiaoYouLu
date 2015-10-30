//
//  UserHandle.h
//  记录用户的操作，比如主动暂停播放等
//
//  Created by cheng lixing on 12-3-14.
//  Copyright 2012年 YZX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserHandle : NSObject 
{
    BOOL pausePlayByUser;  // 用户主动暂停播放
    BOOL pausePlayByInterruption; // 中断时暂停播放
    BOOL pausePlayByUnplugHeadset; // 拔出耳机时暂停播放
    BOOL pausePlayBySystem;
}

@property (nonatomic) BOOL pausePlayByUser;
@property (nonatomic) BOOL pausePlayByInterruption;
@property (nonatomic) BOOL pausePlayByUnplugHeadset;
@property (nonatomic) BOOL pausePlayBySystem;

+ (id) userHandle;

// 是否存在用户暂停（包括手动暂停、中断暂停、拔出耳机暂停）
- (BOOL) isUserPausePlay;

// 重置所有暂停状态
- (void)resetAllPauseStatus;

@end
