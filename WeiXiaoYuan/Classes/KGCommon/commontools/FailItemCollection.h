//
//  FailItemCollection.h
//  记录播放失败的ipod歌曲项等
//
//  Created by kugou on 2011/11/8.
//  Copyright 2011年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FailedItems :  NSObject
{
    NSMutableArray* failItems;
    NSCondition *m_itemLock;
}
- (id) init;
- (void) addFailedItem: (NSString*) itemURL;
- (void) deleteFailedItem: (NSString*) itemURL;
- (BOOL) isFailedItem: (NSString*) itemURL;
- (void) removeAllItems;
@end

@interface PlayFailedIpodItems : FailedItems 
{
    
}
+ (PlayFailedIpodItems*) playFailedIpodItems;

@end


@interface PlayFailedCacheItems : FailedItems
{

}

+ (PlayFailedCacheItems*) playFailedCacheItems;

@end
