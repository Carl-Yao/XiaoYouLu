//
//  EasyJSWebViewDelegate.h
//  EasyJS
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasyJSWebViewProxyDelegate : NSObject<UIWebViewDelegate,UIActionSheetDelegate>
{
    NSString* dateText;
}
@property (nonatomic, retain) NSMutableDictionary* javascriptInterfaces;
@property (nonatomic, retain) id<UIWebViewDelegate> realDelegate;
@property (nonatomic, retain) NSString* startedURL;
@property (nonatomic, readwrite) CGFloat startedHeight;
@property (nonatomic, retain) NSString* startedTitle;
@property (nonatomic, retain) UIActionSheet* startsheet;
- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name;

@end
