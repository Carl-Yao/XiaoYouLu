//
//  FailItemCollection.m
//  kugou
//
//  Created by kugou on 2011/11/8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Heads.h"
#import "FailItemCollection.h"

//#ifdef _IPHONE_
////#import "kugouAppDelegate.h"
//#endif

PlayFailedCacheItems *g_playFailedCacheItems;

@implementation FailedItems

- (id) init
{
    self = [super init];
    if (self)
    {
        failItems = [[NSMutableArray alloc] initWithCapacity: 50];
        m_itemLock = [[NSCondition alloc]init];
    }
    return self;
}

- (void) dealloc
{
    [m_itemLock release];
    [failItems release];
    [super dealloc];
}

- (void) addFailedItem: (NSString*) itemURL
{
    if (itemURL == nil)
    {
        return;
    }
    
    [m_itemLock lock];
    [failItems addObject: itemURL];
    [m_itemLock unlock];
}

- (void) deleteFailedItem: (NSString*) itemURL
{
    [m_itemLock lock];
    int count = [failItems count];
    for (int pos = 0; pos < count; pos ++)
    {
        NSString *item = [failItems objectAtIndex:pos];
        if ([item isEqualToString:itemURL])
        {
            [failItems removeObject:itemURL];
            count = [failItems count];
            pos --;
        }
    }
    [m_itemLock unlock];
}

- (BOOL) isFailedItem: (NSString*) itemURL
{
    [m_itemLock lock];
    for (NSString* item in failItems)
    {
        if ([itemURL isEqualToString: item])
        {
            [m_itemLock unlock];
            return YES;
        }
    }
    [m_itemLock unlock];
    return NO;
}

- (void) removeAllItems
{
    [m_itemLock lock];
    [failItems removeAllObjects];
    [m_itemLock unlock];
}

@end


@implementation PlayFailedIpodItems

+ (PlayFailedIpodItems*) playFailedIpodItems
{
    static PlayFailedIpodItems *instance = nil;
    if (instance == nil) {
        instance = [[PlayFailedIpodItems alloc]init];
    }
    return instance;
//#ifdef _IPHONE_
//    kugouAppDelegate* app = [kugouAppDelegate App];
//    @synchronized(self)
//    {
//        if (app.ipodFailedItems == nil)
//        {
//            app.ipodFailedItems = [[PlayFailedIpodItems alloc] init];
//        }
//    }
//    
//    return app.ipodFailedItems;
//#else
//    return nil;
//#endif
}

@end

@implementation PlayFailedCacheItems

+ (PlayFailedCacheItems*) playFailedCacheItems
{
    @synchronized(self)
    {
        if (g_playFailedCacheItems == nil)
        {
            g_playFailedCacheItems = [[PlayFailedCacheItems alloc] init];
        }
    }
    
    return g_playFailedCacheItems;
}

@end
